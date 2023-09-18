<?php
include '../db.php';
include '../setresult.php';

function propercase($value){
    return ucwords(strtolower($value)); 
}

$message = 'No data received...';
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
$Compid = $Postdata['GetCompId'];

}


$que = "SELECT CompanyName FROM CompaniesDetails WHERE CompanyID = '$Compid';";
$result = mysqli_query($conn,$que);
if($conn -> affected_rows >=1){
    $row = mysqli_fetch_assoc($result);
    $compName = $row['CompanyName'];
    setresult(true,'',$compName);
}else{

    setresult(false,'','');
}





?>