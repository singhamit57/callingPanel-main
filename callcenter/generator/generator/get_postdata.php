<!DOCTYPE html>

<?php
$Type = "";


$ID = "AddStamp,CompanyID,LeadID,Userid,Department,Response,IntDate,Remark,CallDuration,DataCode,RespCount,LastUpdateStamp,LastUpdateBy";

$idarray = explode(",",$ID);

$length = count($idarray);
$i = 0;
while($i<$length){
    $value =$idarray[$i];
    $method = "_GET";
    if($Type!=''){$method = $Type;}
    echo "$".$value." = makesecure("."$".$method."['".$value."']);</br>";
    $i++;
}

 
    



?>



    
