<!DOCTYPE html>
$ResultData = array();</br>
<?php
$ID = "CompId,CompName,CompStatus,UserId,UserStatus,UserName,UserDesignation,UserDepartment";


$Value = "";


$Data = array();
$idarray = explode(",",$ID);
$valueaary = explode(",",$Value);
$length = count($idarray);
$i = 0;
while($i<$length){
    $Data[$idarray[$i]]=$valueaary[$i];
    $i++;
}

 foreach($Data as $key=>$value){
     
    echo "$"."ResultData['".$key."']"." = $"."Data->".$key." ?? '' ;</br>";
    }
    



?>



    
