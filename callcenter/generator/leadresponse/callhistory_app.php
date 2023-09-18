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
    $LogedUsersId = $Postdata['LogedUsersId'];
    $LogedUserCompId = $Postdata['LogedUserCompId'];
    $Operation = $Postdata['operation']??'';
    $LogedUsersPost = $Postdata['LogedUsersPost'];
    
}
if($FrDate != ""){
$FrDate = date("Y-m-d 00:00:00", strtotime($FrDate));
$ToDate = date("Y-m-d 23:59:59", strtotime($ToDate));
    
}
$header = array();
if($LogedUsersPost=='Super Admin' ){
    $CompFilter = "";
    $UserIdQue = "";
}else{
    $CompFilter = " and CompanyID = '$LogedUserCompId' "; 
    $UserIdQue = " AND Userid = '$LogedUsersId'";
}

// WHERE LastPriority <> 'NA'  where Userid = '$LogedUserid'
 $querry = "SELECT * FROM `LeadResponse` WHERE Response <> '' AND (AddStamp >= '$FrDate' AND AddStamp <= '$ToDate') AND Userid = '$LogedUsersId'  ORDER BY AddStamp DESC ;  ";
 if($LogedUsersPost == 'Super Admin'){$querry = "SELECT * FROM `LeadResponse`";}
    $result =mysqli_query($conn,$querry);
    if($conn->affected_rows >=1){
    while($row =$result->fetch_assoc()){
      $LeadID = $row['LeadID'];
    $one = array();
    $one = $row ;
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
        $one['IntDateshow'] = date("d-M-Y", strtotime($one['IntDate'])); 
      
    }
    unset($one['AddStamp']);
    array_push($Resultdata,$one);
    
    }
    
    
    if($Operation == 'download'){
        $lable = "CallHistory";
        foreach($Resultdata[0] as $Key=>$value){
            array_push($header,$Key);
        }
        $fileName = $lable."_$LogedUserid".".csv";
        $filepath = "../csvfiles/$fileName";
        generatecsv($filepath,$header,$Resultdata);
        $filepath = "https://sinoxfx.com/callcenter/csvfiles/$fileName";
        goto Download;
    }
    
    
        goto GotData;
    }else{
        goto NoData;
    }




GotData:
    setresult(true,$message,$Resultdata);
NoData:
    setresult(false,$message,$Resultdata);
Download:
setresultwithtime(true,$filepath??'',$LastupdateTime,$Resultdata);

?>