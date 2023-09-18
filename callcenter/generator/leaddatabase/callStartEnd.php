<?php
include '../db.php';

$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
$CompId = $Postdata['CompId'];
$UserId = $Postdata['UserId'];
$LeadId = $Postdata['LeadId'];
$Operation = $Postdata['Operation'];
$LocalTimeStamp = $Postdata['LocalTimeStamp'];
    
}
$Stamp = date('Y-m-d G:i:s');





if($Operation=='Start'){
    $Startupdate= "UPDATE LeadsDataBase SET CallStartStamp = '$LocalTimeStamp' WHERE Table_id = '$LeadId';";
    $result =mysqli_query($conn,$Startupdate);
}

if($Operation=='End'){
    $EndUpdate = "UPDATE LeadsDataBase SET CallEndStamp = '$LocalTimeStamp' WHERE Table_id = '$LeadId';";
    $result =mysqli_query($conn,$EndUpdate);
}



?>