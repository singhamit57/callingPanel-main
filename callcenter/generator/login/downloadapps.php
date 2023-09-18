<?php
include ('../db.php');
include ('../setresult.php');
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata == null){
    goto failed;
    $operation = "Mobile App";
}else{
    $operation = $Postdata['operation'];
    
}
$gotapplink = false;
$applink = "";

if($operation =="Mobile App"){
    $gotapplink = true;
$applink = "https://agcaller.com/products/agcaller.apk";
goto Success;
}

if($operation =="Web App"){
    $gotapplink = true;
$applink = "http://agcaller.com";
goto Success;
}

if($operation =="Window App"){
    $gotapplink = true;
$applink = "https://agcaller.com/products/agcaller.zip";
goto Success;
}


failed:
    setresult(false,"No data found","");
    
Success:
setresult(true,"",array("gotapplink"=>$gotapplink,"applink"=>$applink));
?>