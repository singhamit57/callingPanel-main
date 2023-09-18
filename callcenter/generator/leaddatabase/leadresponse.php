<?php

$AddStamp = makesecure($_GET['AddStamp']);
$CompanyID = makesecure($_GET['CompanyID']);
$LeadID = makesecure($_GET['LeadID']);
$Userid = makesecure($_GET['Userid']);
$Department = makesecure($_GET['Department']);
$Response = makesecure($_GET['Response']);
$IntDate = makesecure($_GET['IntDate']);
$Remark = makesecure($_GET['Remark']);
$CallDuration = makesecure($_GET['CallDuration']);
$DataCode = makesecure($_GET['DataCode']);
$RespCount = makesecure($_GET['RespCount']);
$LastUpdateStamp = makesecure($_GET['LastUpdateStamp']);
$LastUpdateBy = makesecure($_GET['LastUpdateBy']);

$AddStamp = "";

$insert_resp = "INSERT INTO LeadResponse (AddStamp,CompanyID,LeadID,Userid,Department,Response,IntDate,Remark,CallDuration,DataCode,RespCount,LastUpdateStamp,LastUpdateBy) VALUE ('$AddStamp','$CompanyID','$LeadID','$Userid','$Department','$Response','$IntDate','$Remark','$CallDuration','$DataCode','$RespCount','$AddStamp','$LastUpdateBy'); ";

?>