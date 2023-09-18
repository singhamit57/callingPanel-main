<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();

$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompId = $Postdata['CompId'];
    $UserID = $Postdata['UserID'];
    $LeadId = $Postdata['LeadId'];
    
}

$querry = "SELECT * FROM `LeadsDataBase` WHERE Table_id = '$LeadId';";
$result =mysqli_query($conn,$querry);
if($conn->affected_rows >=1){
    $row =$result->fetch_assoc();
    $Resultdata = $row;
   
   
    goto GotData;
}else{
   goto NoData;  
}

GotData:
    setresult(true,"Response Received",$Resultdata);
NoData:
    setresult(false,"No Details Found",$Resultdata);

?>