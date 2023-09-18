<?php
//ucwords(strtolower($value));
include('../db.php');
include ('../setresult.php');
$ResultMsj = "No Data Found...";

function propercase($value){
    return ucwords(strtolower($value));
}

$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata == null){goto FailedSaving;}

$CompanyID = ($Postdata['CompanyID']);
$CompanyName = ($Postdata['CompanyName']);
$LogedUserId = $Postdata['LogedUserId'];
$LogedUserName = $Postdata['LogedUserName'];
$Deletefor = ($Postdata['Deletefor']);
$lablename = ($Postdata['lablename']);

if($Deletefor=="Response"){
    $deleteque = "DELETE FROM ResponsesDetails WHERE Response = '$lablename' AND CompanyID = '$CompanyID' ; ";
}

if($Deletefor=="Department"){
    $deleteque = " DELETE FROM DepartmentsDetails WHERE Department = '$lablename' AND CompanyID = '$CompanyID' ; ";
}

if($deleteque != ""){
     $result =mysqli_query($conn,$deleteque);
    if($conn->affected_rows>=1){
         
         goto RecordSaved;
    }else{
         
         goto FailedSaving;
    }
}else{
    goto FailedSaving;
}





RecordSaved:
setresult(true,$ResultMsj,array());

FailedSaving:
setresult(false,$ResultMsj ??'Failed to save record...',"");



?>