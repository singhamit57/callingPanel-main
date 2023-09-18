<?php
include('../db.php');
include ('../setresult.php');
include ('../setupdateStamp.php');
$ResultMsj = "No Data Found...";

$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata == null){
    goto Fail;
}

$TableID = ($Postdata['TableID']);
$CompanyID = ($Postdata['CompID']);
$CompanyName = ($Postdata['CompName']);
$LogedID = ($Postdata['LogedID']);
$LogedName = ($Postdata['LogedName']);

if($CompanyID = 'agc202101'){
    goto Fail;
}


$delete_data = "DELETE FROM CompaniesDetails WHERE Table_id = '$TableID';";
$result =mysqli_query($conn,$delete_data);
if($conn->affected_rows>=1){
    settableupdate($CompanyID,'CompaniesDetails');
     setresult(true,"Company deleted",$Resultdata);
}else{
     setresult(true,"Failed to delete company",$Resultdata);
}


Fail:
setresult(false,"This company can not be deleted",$Resultdata);


?>