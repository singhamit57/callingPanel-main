<?php
include '../db.php';
include ('../setresult.php');
include ('../csvfilegenerator.php');
$Resultdata = array();


$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
$PageNumber = $Postdata['PageNumber'];
$SearchInput = $Postdata['SearchInput'];
$Isserchingbyinput = $Postdata['Isserchingbyinput'];
$CompId = $Postdata['CompId'];
$UserId = $Postdata['UserId'];
$LastUpdate = $Postdata['LastUpdate'];
$FromDate = $Postdata['FromDate'];
$ToDate = $Postdata['ToDate'];
$Isfilter = $Postdata['Isfilter']; 
$FilterName = $Postdata['FilterName'];
$LogedUserCompId = $Postdata['LogedUserCompId'];
$LogedUsersPost = $Postdata['LogedUsersPost'];
$Operation = $Postdata['operation'];

}else{
  //  goto NoData; agcomp23
  $CompId = "agcomp23";
  $UserId = "12345";
   $LogedUserCompId = "agcomp23";
   $PageNumber = $_GET['page'];
   $Operation = 'download';

}
//  $CompId = "agcomp23";
//   $LogedUserCompId = "agcomp23";
//   $Isserchingbyinput = true;
//   $SearchInput = 'sanya';

$Stamp = date("Y-m-d G:i:s");
$Todaydate = date("Y-m-d");
$MaxDataLimit = 50;

if($LogedUsersPost=='Super Admin' or $LogedUserCompId =='agc202101' ){
    $CompFilter = "";
}else{
    $CompFilter = " and CompanyID = '$LogedUserCompId' "; 
}



if($Isfilter == true){
    
    //Total Leads
    if($FilterName == 'Total Leads'){
        $filterque = "SELECT * FROM `LeadsDataBase` where  FullName <> '' $CompFilter ";
    }
    
    //Availbale leads
    if($FilterName == 'Available Leads'){
        $filterque = "SELECT * FROM LeadsDataBase WHERE IssuedID = 'NA' AND CRepeateCount = 1  $CompFilter; ";
    }
    
    //Dublicate Leads
    if($FilterName == 'Duplicate Leads'){
        $filterque = "SELECT * FROM LeadsDataBase  WHERE CRepeateCount > 1 $CompFilter ; ";
    }
    
    //Used Leads
    if($FilterName == 'Used Leads'){
        $filterque = "SELECT * FROM LeadsDataBase  WHERE IssuedID <> 'NA'  and LastResponse <> 'NA' $CompFilter;";
    }
    
    //Hot cold medium lead
    if($FilterName == 'Hot Leads' or $FilterName == 'Cold Leads' or $FilterName == 'Medium Leads' ){
        $leadtype = str_replace('Leads','Lead',$FilterName);
    $filterque = "SELECT * FROM `LeadsDataBase` WHERE LastPriority = '$leadtype' $CompFilter ;"; }
    
    //Open Leads
    if($FilterName == 'Open Leads'){
        $filterque = "SELECT * FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastLeadResult = 'Pending' $CompFilter;";
    }
    
    //Closed Leads
    if($FilterName == 'Closed Leads'){
        $filterque = "SELECT * FROM LeadsDataBase  WHERE LastResponse <>'NA' AND (LastLeadResult = 'Successfull' or LastLeadResult = 'Cancelled')  $CompFilter;";
    }
    
    //Success Leads
    if($FilterName == 'Success Leads'){
        $filterque = "SELECT * FROM LeadsDataBase  WHERE LastResponse <>'NA' AND LastLeadResult = 'Successfull' $CompFilter;";
    }
    
    //Failed Leads
    if($FilterName == 'Failed Leads'){
        $filterque = "SELECT * FROM LeadsDataBase  WHERE LastResponse <>'NA' AND LastLeadResult = 'Cancelled' $CompFilter ; ";
    }
    
    //Total Followups
    if($FilterName == 'Total Followups'){
        $filterque = "SELECT * FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastIntDate > '2021-01-01'  AND LastLeadResult = 'Pending' $CompFilter ;";
    }
    
    //Today's Followups
    if($FilterName == "Today's Followups"){
        $filterque = "SELECT * FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastIntDate = '$Todaydate'  AND LastLeadResult = 'Pending' $CompFilter ; ";
    }
    
    //Pending Followups
    if($FilterName == "Pending Followups"){
        $filterque = "SELECT * FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastIntDate < '$Todaydate'  AND LastLeadResult = 'Pending' $CompFilter ;";
    }
   
}
if($FromDate != ''){
    $dateQue = " AND ( AddStamp BETWEEN '$FromDate' AND '$ToDate') ";
}


if($Isfilter == true ){
  $querry = $filterque;  
}else{
    $querry = "SELECT * FROM `LeadsDataBase` WHERE FullName <> '' $dateQue $CompFilter ";}


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
    $TotalData=mysqli_fetch_all($result, MYSQLI_ASSOC);
    
    
    if($Isserchingbyinput==true){
        if(strlen($SearchInput) >=2){
            array_map("filteralldata",$TotalData);
            $TotalData = $newfilterdata;
            $GotDataCount = count($TotalData);
            // print_r($TotalData);
            // echo "////////";
            // print_r($newfilterdata);
            // die();
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
        $filepath = "https://sinoxfx.com/callcenter/csvfiles/$fileName";
        goto Download;
    }
    while($TotalData){
        $row = $TotalData[$StratLoop];
        $one = array();
        $AddStamp = date("d-M-Y", strtotime($row['AddStamp']));
        $LastIntDate = $row['LastIntDate'];
        $IssueStamp = $row['IssueStamp'];
        $LastUpdateStamp = $row['LastUpdateStamp'];
        $ResponseStamp = $row['RespStamp'];
        if($IssueStamp != '0000-00-00 00:00:00'){
        $IssueStamp = date("d-M-Y", strtotime($IssueStamp));}else{
            $IssueStamp = "";
        }
        if($LastIntDate != '0000-00-00'){
        $LastIntDate = date("d-M-Y", strtotime($LastIntDate ));}else{
            $LastIntDate = "";
        }
        if($LastUpdateStamp != "0000-00-00 00:00:00"){
        $LastUpdateStamp = date("d-M-Y", strtotime($LastUpdateStamp));}else{
            $LastUpdateStamp = "";
        }
        
        if($ResponseStamp  != "0000-00-00 00:00:00"){
        $ResponseStamp  = date("d-M-Y", strtotime($ResponseStamp));}else{
            $ResponseStamp  = "";
        }
        
        $one['SNo'] = $StratLoop;
        $one['Table_id'] = $row['Table_id'];
        $one['AddStamp'] = $AddStamp;
        $one['CompanyID'] = $row['CompanyID'];
        $one['AddedBy'] = $row['AddedBy'];
        $one['CompanyName'] = $row['CompanyName'];
        $one['FullName'] = $row['FullName'];
        $one['Mobile'] = $row['Mobile'];
        $one['AltMobile'] = $row['AltMobile'];
        $one['Email'] = $row['Email'];
        $one['Profile'] = $row['Profile'];
        $one['Experience'] = $row['Experience'];
        $one['Country'] = $row['Country'];
        $one['State'] = $row['State'];
        $one['City'] = $row['City'];
        $one['Departments'] = $row['Departments'];
        $one['DataCode'] = $row['DataCode'];
        $one['GRepeateCount'] = $row['GRepeateCount'];
        $one['CRepeateCount'] = $row['CRepeateCount'];
        $one['IssuedID'] = $row['IssuedID'];
        $one['IssueStamp'] = $IssueStamp;
        $one['IssuedUser'] = $row['IssuedUser'];
        $one['LastDepartment'] = $row['LastDepartment'];
        $one['LastResponse'] = $row['LastResponse'];
        $one['LastIntDate'] = $LastIntDate;
        $one['LastPriority'] = $row['LastPriority'];
        $one['LastLeadResult'] = $row['LastLeadResult'];
        $one['LastRemark'] = $row['LastRemark'];
        $one['LastCallDuration'] = $row['LastCallDuration'];
        $one['RespStamp'] = $ResponseStamp ;
        $one['RespCount'] = $row['RespCount'];
        $one['LastUpdateBy'] = $row['LastUpdateBy'];
        $one['LastUpdateStamp'] = $LastUpdateStamp;
        array_push($Resultdata,$one);
        $StratLoop++;
        if($StratLoop >= $TillLoop or $StratLoop >=$GotDataCount){
            break;
        }
        
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
    setresultwithtime(true,$ResulstMessage,"$LastupdateTime",$Resultdata);
NoData:
    setresultwithtime(false,"No Details Found",$LastupdateTime,$Resultdata);
Download:
    setresultwithtime(true,$filepath??'',$LastupdateTime,$Resultdata);

?>