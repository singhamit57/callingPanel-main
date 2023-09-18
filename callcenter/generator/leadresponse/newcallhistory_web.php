<?php
include '../db.php';
include ('../setresult.php');
include ('../csvfilegenerator.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompId'];
    $LogedUserid = $Postdata['UserID'];
    $LogedUser = $Postdata['UserName'];
    $FrDate = $Postdata['FrDate'];
    $ToDate = $Postdata['ToDate'];
    $LogedUsersId = $Postdata['LogedUsersId']??$LogedUserid ;
    $LogedUserCompId = $Postdata['LogedUserCompId'];
    $LogedUsersPost = $Postdata['LogedUsersPost'];
    $Operation = $Postdata['operation']??'';
    $PageNumber = $Postdata['PageNumber'];
$SearchInput = strtolower($Postdata['SearchInput'])??'';
$Isserchingbyinput = $Postdata['Isserchingbyinput'];

    
}else{
    $message = "No data received...";
    // goto NoData;
}

if($FrDate != ""){
    
$FrDate = date_format(date_create($FrDate),"Y-m-d 00:00:00");
$ToDate = date_format(date_create($ToDate),"Y-m-d 23:59:59"); 
$DateQue = " AND AddStamp >= '$FrDate' AND AddStamp <= '$ToDate' ";
    
}else{
   $FrDate = "2020-01-01 00:00:00";
   $ToDate = "2024-01-01 23:59:59";
   
}
$header = array();
$MaxDataLimit = 50;

if($LogedUsersPost=='Super Admin' ){
    $CompFilter = "";
    $UserIdQue = "";
}else{
    $CompFilter = " and CompanyID = '$LogedUserCompId' "; 
    $UserIdQue = " AND Userid = '$LogedUsersId'";
}
// WHERE LastPriority <> 'NA'  where Userid = '$LogedUserid'
 $querry = "SELECT * FROM `LeadResponse` WHERE LeadID <> '' $CompFilter $DateQue   order by AddStamp desc ;  ";

$result =mysqli_query($conn,$querry);
$GotDataCount = $conn->affected_rows??0;
$PageNumber = $PageNumber ??0;
$StratLoop = $PageNumber==0?0:($PageNumber*$MaxDataLimit);
$TillLoop = ($PageNumber+1)*$MaxDataLimit;
$newfilterdata = array();
$header = array();

function filteralldata($onearray){
    
    global $SearchInput;
    global $newfilterdata;
    foreach($onearray as $key=>$value){
        if(strpos(strtolower($value), $SearchInput)!== false){
            array_push($newfilterdata,$onearray);
            break;
        }
    }
    
}

if($GotDataCount >=1){
    $AllData=mysqli_fetch_all($result, MYSQLI_ASSOC);
    $TotalData = array();

foreach ($AllData as $Onedata){
    $LeadID = $Onedata["LeadID"];
    $one = array();
    $one = $Onedata ;
    $intdate = $one['IntDate'];
    $CallRecordID = $one['CallRecordID'];
    $LastUpdateBy = $one['Userid'];
    
    if($intdate == "0000-00-00"){
    $one['IntDate'] = "";
    }else{
    $one['IntDate'] = date("d-M-Y", strtotime($one['IntDate'])); 
    }
    if($one['LeadResult']=="NA"){
        $one['LeadResult'] = "Closed";
    }
    if($one['Priority']=="Select Priority"){
        $one['Priority'] = "";
    }
    
    $details = "SELECT FullName, Mobile, AltMobile,Email,Country,State,City FROM `LeadsDataBase` WHERE Table_id = '$LeadID';";
    $result2 =mysqli_query($conn,$details);
    if($conn->affected_rows >=1){
        $row2 =$result2->fetch_assoc();
        $one['FullName'] = $row2['FullName'];
        $one['Mobile'] = $row2['Mobile'];
        $one['AltMobile'] = $row2['AltMobile'];
        $one['Email'] = $row2['Email'];
        $one['Showdate'] = date("d-M-Y", strtotime($one['AddStamp'])); 
        $one['Showtime'] = date("h:i A", strtotime($one['AddStamp'])); 
        $one['ShowDuration'] = $one['CallDuration']."Sec"; 
        $one['Country'] = $row2['Country'];
        $one['State'] = $row2['State'];
        $one['City'] = $row2['City'];
        $one['IntDateshow'] = $one['IntDate'];
      
    }
    
    $recoding_que = "SELECT * FROM `UploadedFiles` WHERE FileID = '$CallRecordID' ";
    $result2 =mysqli_query($conn,$recoding_que);
    if($conn->affected_rows ==0){
        $one["CallRecordID"]= "";
    }
    
    $recoding_que = "SELECT FullName FROM `UserDetails` WHERE UserID = '$LastUpdateBy';";
    $result2 =mysqli_query($conn,$recoding_que);
    if($conn->affected_rows >=1){
        $row2 =$result2->fetch_assoc();
        $one["lastUpdateName"]= $row2['FullName'];
    }else{
        $one["lastUpdateName"] = "Unknown";
    }
    
    // unset($one['AddStamp']);
    array_push($TotalData,$one);
        
}

    if($Isserchingbyinput==true){
        if(strlen($SearchInput) >=2){
            array_map("filteralldata",$TotalData);
            $TotalData = $newfilterdata;
            $GotDataCount = count($TotalData);
           
        }
        
    }
    
    if($Operation == 'download'){
        $lable = str_replace(" ","_",$FilterName??"leads");
        foreach($TotalData[0] as $Key=>$value){
            array_push($header,$Key);
        }
        $fileName = $lable."_$UserId".".csv";
        $filepath = "../csvfiles/$fileName";
        generatecsv($filepath,$header,$TotalData);
        $filepath = "$Basewebsite/callcenter/csvfiles/$fileName";
        goto Download;
    }
    
    
while($TotalData){
    $row = $TotalData[$StratLoop];

array_push($Resultdata,$row);
 $StratLoop++;
if($StratLoop >= $TillLoop or $StratLoop >=$GotDataCount){
    break;
}

}


if($Operation == 'download'){
    $lable = "CallHistory";
    foreach($Resultdata[0] as $Key=>$value){
        array_push($header,$Key);
    }
    $fileName = $lable."_$LogedUserid".".csv";
    $filepath = "../csvfiles/$fileName";
    generatecsv($filepath,$header,$Resultdata);
    $filepath = "$Basewebsite/callcenter/csvfiles/$fileName";
    goto Download;
}


    goto GotData;
}else{
    goto NoData;
}




GotData:
    $TotalAvlPages = ceil($GotDataCount/$MaxDataLimit);
    $previouspage = $PageNumber-1;
    $currentpage = $PageNumber*1;
    $nextpage = $PageNumber+1;
    $ResulstMessage = array('TotalAvlData'=>$GotDataCount,'TotalAvlPages'=>$TotalAvlPages,'PreviousPage'=>$previouspage,'CurrentPage'=>$currentpage,'NextPage'=>$nextpage);
    setresult(true,$ResulstMessage,$Resultdata);
NoData:
    setresult(false,$message,$Resultdata);
Download:
setresultwithtime(true,$filepath??'',$LastupdateTime,$Resultdata);

?>