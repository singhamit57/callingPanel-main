<?php
include('../db.php');
include('../class/logindetailsclass.php');
include('../class/permissiondetailclass.php');
include ('../setresult.php');
include ('../setupdateStamp.php');

$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata == null){
$ForUserId = $_GET['id'];
$ForUserpw = $_GET['password'];
}else{
$ForUserId = $Postdata['id'];
$ForUserpw = $Postdata['password'];
}
if($ForUserId =="" or $ForUserpw ==""){
    setresult(false,"No Data Recived...","");
}

$LoginKey = uniqid()."_$ForUserId";
$Stamp = date("Y-m-d G:i:s");

$condi = "WHERE UserID =  '$ForUserId'";
$Data = new OneLoginDetail($condi);
$userid = $Data->UserId;
$userpw = $Data->UserPassword;
$userstatus = $Data->UserStatus;
$CompStatus = $Data->CompStatus;
$CompID = $Data->CompId;
///User Details
$ResultData = array();
$ResultData['CompId'] = $Data->CompId ?? '' ;
$ResultData['CompName'] = $Data->CompName ?? '' ;
$ResultData['CompStatus'] = $Data->CompStatus ?? '' ;
$ResultData['UserId'] = $Data->UserId ?? '' ;
$ResultData['UserStatus'] = $Data->UserStatus ?? '' ;
$ResultData['UserName'] = $Data->UserName ?? '' ;
$ResultData['UserDesignation'] = $Data->UserDesignation ?? '' ;
$ResultData['UserDepartment'] = explode(",",$Data->UserDepartment ?? '') ;
$ResultData['LoginKey'] = $LoginKey ??'';
$compdetails_que = "SELECT * FROM `CompaniesDetails` WHERE CompanyID = '$CompID';";
$result = mysqli_query($conn,$compdetails_que);
if($conn -> affected_rows >=1){
    $row_comp = mysqli_fetch_array($result);
    $compmobile = $row_comp['Mobile'];
    $compAddress = $row_comp['FullAddress'];
    $compemail = $row_comp['Email'];
    $compwebsit = $row_comp['Website'];
    
}


$ResultData['compMobile'] = $compmobile??'';
$ResultData['compAddress'] = $compAddress??'';
$ResultData['compEmail'] = $compemail??'';
$ResultData['compWebsite'] = $compwebsit??'';
$user_que = "SELECT Mobile, Email FROM UserDetails WHERE UserID = '$userid';";
$result = mysqli_query($conn,$compdetails_que);
if($conn -> affected_rows >=1){
    $row_User = mysqli_fetch_array($result);
    $Usermobile = $row_User['Mobile'];   
    $Useremail = $row_User['Email']; }

$ResultData['logeduserMobile'] = $Usermobile??'';
$ResultData['logeduserEmail'] = $Useremail??'';


if($ForUserId == $userid and $ForUserpw==$userpw ){
    if($CompStatus !=1){
        setresult(false,"Your Company Is Not Active","");
    }else if($userstatus!=1){
        setresult(false,"Your id is deactivated","");
    }else{
    
    $Update = "UPDATE LoginDetails SET LastLogin = '$Stamp', LoginKey = '$LoginKey' WHERE  UserID = '$ForUserId'; ";
    $result =mysqli_query($conn,$Update);
    
settableupdate($CompID,'LoginDetails');
setresult(true,"Login successfully",$ResultData);
        
}
    
}else{
setresult(false,"Invalid userid or password","");}




?>