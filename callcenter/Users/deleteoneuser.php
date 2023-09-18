<?php


include('../db.php');
include ('../setresult.php');
include ('../setupdateStamp.php');

$ResultMsj = "No Data Found...";

$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata == null){goto FailedSaving;}
//print_r($Postdatada
//die("NO Data");

$LogedUserId = $Postdata['LogedUserId'];
$LogedUserName = $Postdata['LogedUserName'];
$CompId = $Postdata['CompId'];
$TableId = $Postdata['TableId'];
$UserId = $Postdata['DeleteUserId'];

$DeleteCount = 0;
if($UserId ==''){
$Getid = "SELECT UserID FROM `UserDetails` WHERE Table_id = '$TableId';";
$result =mysqli_query($conn,$Getid);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    $UserId = $row['UserID'];
}
}

$DeleteUser = "DELETE FROM UserDetails WHERE UserID = '$UserId' ;";
$result =mysqli_query($conn,$DeleteUser);
if($conn->affected_rows>=1){
    $DeleteCount = $DeleteCount+1;
}

$Deletepermission = "DELETE FROM PermissionDetails WHERE UserID = '$UserId' ;";
$result =mysqli_query($conn,$Deletepermission);
if($conn->affected_rows>=1){
    $DeleteCount = $DeleteCount+1;
}

$DeleteLogin = " DELETE FROM LoginDetails WHERE UserID = '$UserId' ;";
$result =mysqli_query($conn,$DeleteLogin);
if($conn->affected_rows>=1){
    $DeleteCount = $DeleteCount+1;
}

if($DeleteCount >=1){
    $ResultMsj = "Record deleted...";
    goto RecordSaved;
    
}else{
    $ResultMsj = "Failed to delete record... ";
    goto FailedSaving;
}


RecordSaved:
settableupdate($CompId,'UserDetails');
settableupdate($CompId,'LoginDetails');
settableupdate($CompId,'PermissionDetails');
setresult(true,$ResultMsj,array());

FailedSaving:
setresult(false,$ResultMsj,"");


?>