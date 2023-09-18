<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();


$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
$CompId = $Postdata['CompId'];
$UserId = $Postdata['UserId'];
$LastUpdate = $Postdata['LastUpdate'];
$FromDate = $Postdata['FromDate'];
$ToDate = $Postdata['ToDate'];
$Isfilter = $Postdata['Isfilter']; 
$FilterName = $Postdata['FilterName'];
$LogedUserCompId = $Postdata['LogedUserCompId'];
$LogedUsersPost = $Postdata['LogedUsersPost']??'';

}else{
    goto NoData;
}

$Stamp = date("Y-m-d G:i:s");
$Todaydate = date("Y-m-d");

$LastupdateTime = "";
$Lastupdate_Que = "SELECT UPDATE_TIME FROM information_schema.tables WHERE TABLE_SCHEMA = 'sinoxfx_CallingCenter' AND TABLE_NAME = 'LeadsDataBase'";

$result =mysqli_query($conn,$Lastupdate_Que);
if($conn->affected_rows >=1){
    $row =$result->fetch_assoc();
    $LastupdateTime = $row['UPDATE_TIME'];
    }

if($LastUpdate == $LastupdateTime and $LastUpdate != "" and $Isfilter == false ){
  //  goto GotData;
}

function getpassword($ID){
    include '../../db.php';
    $querry = "SELECT UserPassword, LastLogin FROM LoginDetails WHERE UserID = '$ID'; ";
$result =mysqli_query($conn,$querry);
if($conn->affected_rows >=1){
    $row =$result->fetch_assoc();
    return $row;
    }
    
}


function getpermission($ID){
    include '../../db.php';
    $querry = "SELECT * FROM `PermissionDetails` WHERE UserID = '$ID';";
$result =mysqli_query($conn,$querry);
if($conn->affected_rows >=1){
    $row =$result->fetch_assoc();
    return $row;
    }
    
}

if($LogedUsersPost == 'Super Admin'){
     $CompFilter = "";
}else{
    $CompFilter = " and CompanyID = '$LogedUserCompId' ";
}

echo "$FilterName && $LogedUsersPost && $UserId " ;

if($Isfilter == true and $FilterName !=''){
   
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
    $querry = "SELECT * FROM `LeadsDataBase` WHERE FullName <> '' $dateQue and CompanyID = '$CompId' limit 20 ";}

$result =mysqli_query($conn,$querry);
if($conn->affected_rows >=1){
    
    while($row =$result->fetch_assoc()){
        $one = array();
      
        $AddStamp = date("d-M-Y", strtotime($row['AddStamp']));
        if($IssueStamp != '0000-00-00 00:00:00'){
        $IssueStamp = date("d-M-Y", strtotime($row['IssueStamp']));}else{
            $IssueStamp = "";
        }
        if($LastIntDate != '0000-00-00'){
        $LastIntDate = date("d-M-Y", strtotime($row['LastIntDate']));}else{
            $LastIntDate = "";
        }
        if($LastUpdateStamp != "0000-00-00 00:00:00"){
        $LastUpdateStamp = date("d-M-Y", strtotime($row['LastUpdateStamp']));}else{
            $LastUpdateStamp = "";
        }
        
        
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
        $one['RespStamp'] = $row['RespStamp'];
        $one['RespCount'] = $row['RespCount'];
        $one['LastUpdateBy'] = $row['LastUpdateBy'];
        $one['LastUpdateStamp'] = $LastUpdateStamp;
        
        array_push($Resultdata,$one);
        
        
    }
    
    goto GotData;
}else{
   goto NoData;  
}

GotData:
    
    setresultwithtime(true,"Response Received ","$LastupdateTime",$Resultdata);
NoData:
    setresultwithtime(false,"No Details Found $filterque && $FilterName",$LastupdateTime,$Resultdata);

?>