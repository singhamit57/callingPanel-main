<!DOCTYPE html>

<?php
$Type = "data";


$ID = "CompId,CompName,CompStatus,UserId,UserStatus,UserName,UserDesignation,UserDepartment";

$idarray = explode(",",$ID);

$length = count($idarray);
$i = 0;
while($i<$length){
    $value =$idarray[$i];
    $method = "_GET";
    if($Type!=''){$method = $Type;}
    echo ", $value = '$".$value."'";
   // echo "$".$value." = $".$method."['".$value."'];</br>";
    $i++;
}

 
    



?>



    
