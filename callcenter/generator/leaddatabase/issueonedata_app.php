<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompID'];
    $LogedUser = $Postdata['UserID'];
    $isdepartfilter = $Postdata['isdepartfilter'];
    $islocationfilter = $Postdata['islocationfilter'];
    $Departfilter = $Postdata['Departfilter'];
    $Country = $Postdata['Country'];
    $State = $Postdata['State'];
    $City = $Postdata['City'];
    $predata = $Postdata['predata'];
    $LogedUserCompId = $Postdata['LogedUserCompId'];
     $LogedUsersId = $Postdata['LogedUsersId'];
     $UserDataCode = $Postdata['LogedUsersDataCode'];
}

$Uniqueid = uniqid()."_".$LogedUser;
$timestamp = date("Y-m-d G:i:s");
 
$message = "No data received.";
$issueDataCount = 0;



if($isdepartfilter == true){
    $departque = " and Departments = '$Departfilter' ";
}

if($islocationfilter == true){
    if($Country != ""){
        $Country_que = " AND Country = '$Country' ";
    }
    if($State != ""){
        $State_que = " AND State = '$State' ";
    }
    if($City != ""){
        $City_que = " AND City = '$City' ";
    }
}

$repeate_Filter = " and CRepeateCount = '1' ";

$CompFilter = " and CompanyID = '$LogedUserCompId' ";

$allow = "UPDATE LeadsDataBase SET IssuedID = '$Uniqueid', IssueStamp = '$timestamp', IssuedUser = '$LogedUser' WHERE FullName <> '' and LastResponse ='NA' and DataCode = '$LogedUser' LIMIT 1 ;";
if($issueDataCount==0){
    $result =mysqli_query($conn,$allow);
    if($conn->affected_rows >=1){
       $issueDataCount ++; 
    }
}

$allow = "UPDATE LeadsDataBase SET IssuedID = '$Uniqueid', IssueStamp = '$timestamp', IssuedUser = '$LogedUser' WHERE FullName <> '' and LastResponse ='NA' and IssuedID = 'NA' and DataCode = '$UserDataCode' LIMIT 1 ;";
if($issueDataCount==0 and $UserDataCode != "NA"){
    $result =mysqli_query($conn,$allow);
    if($conn->affected_rows >=1){
       $issueDataCount ++; 
    }
}


$allow = "UPDATE LeadsDataBase SET IssuedID = '$Uniqueid', IssueStamp = '$timestamp', IssuedUser = '$LogedUser' WHERE FullName <> '' and IssuedID ='NA' $repeate_Filter $departque  $Country_que $State_que $City_que $CompFilter LIMIT 1 ;";
if($issueDataCount==0){
    $result =mysqli_query($conn,$allow);
    if($conn->affected_rows >=1){
       $issueDataCount ++; 
    }
}


if($issueDataCount >=1){

if( $predata >1){
    $ClearIssue = "UPDATE LeadsDataBase SET IssuedID = 'NA', IssueStamp = '0000-00-00 00:00:00',IssuedUser = '' WHERE Table_id = '$predata' ;";
  //  $result =mysqli_query($conn,$ClearIssue);
}

    
     $querry = "SELECT * FROM `LeadsDataBase` WHERE IssuedID = '$Uniqueid' ;";
    $result =mysqli_query($conn,$querry);
    if($conn->affected_rows >=1){
    while($row =$result->fetch_assoc()){
    $one = array();
    array_push($Resultdata,$row);
    
    }
        goto GotData;
    }else{
        goto NoData;
    }

    
}else{
    goto NoData;
}




GotData:
    setresult(true,$message,$Resultdata);
NoData:
    setresult(false,$message,$Resultdata);

?>