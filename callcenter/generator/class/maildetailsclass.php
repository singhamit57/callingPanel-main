<?php
class OneMailDetails{
public $condition;
function __construct($condition){
include '../db.php';
$havedata = false;
if($condition!=''){
$query = "SELECT * FROM MailDetails  $condition limit 1;";}
$result =mysqli_query($conn,$query);
if($conn->affected_rows>=1){
$row = $result->fetch_assoc();
$havedata = true;
$Table_id = $row['Table_id'];
$CompanyID = $row['CompanyID'];
$CompanyName = $row['CompanyName'];
$Response = $row['Response'];
$MailSubject = $row['MailSubject'];
$MailContent = $row['MailContent'];
$LastUpdateBy = $row['LastUpdateBy'];
$LastUpdateStamp = $row['LastUpdateStamp'];

}

$this->HaveData = $havedata;
$this->TableId = $Table_id;
$this->CompId = $CompanyID;
$this->CompName = $CompanyName;
$this->Response = $Response;
$this->MailSubject = $MailSubject;
$this->MailContent = $MailContent;
$this->LastUpdateBy = $LastUpdateBy;
$this->LastUpdateStamp = $LastUpdateStamp;
}
}

?>