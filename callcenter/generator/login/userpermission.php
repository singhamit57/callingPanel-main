<?php
include('../db.php');
include('../class/logindetailsclass.php');
include('../class/permissiondetailclass.php');
include ('../setresult.php');
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata == null){
$ForUserId = $_GET['id'];
$ForUserpw = $_GET['password'];
}else{
$ForUserId = $Postdata['id'];
$ForUserpw = $Postdata['password'];
}
if($ForUserId ==""){
    setresult(false,"No Data Recived...","");
}

$Que = "SELECT * FROM `PermissionDetails` WHERE UserID = '$ForUserId';";
$result =mysqli_query($conn,$Que);
if($conn->affected_rows >=1){
    $row = $result->fetch_assoc();
    
    setresult(true,"Permission Received",$row);
}

Faild:
setresult(false,"Invalid Userid or Password","");



?>