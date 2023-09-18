<?php
class OneSmsDetails{
public $condition;
function __construct($condition){
include '../db.php';
$havedata = false;
if($condition!=''){
$query = "SELECT * FROM SmsDetails $condition limit 1;";}
$result =mysqli_query($conn,$query);
if($conn->affected_rows>=1){
$row = $result->fetch_assoc();
$havedata = true;
$Table_id = $row['Table_id'];
$CompanyID = $row['CompanyID'];
$CompanyName = $row['CompanyName'];
$Response = $row['Response'];
$SmsContent = $row['SmsContent'];
$LastUpdateBy = $row['LastUpdateBy'];
$LastUpdateStamp = $row['LastUpdateStamp'];

}

$this->HaveData = $havedata;
$this->TableId = $Table_id;
$this->CompId = $CompanyID;
$this->CompName = $CompanyName;
$this->Response = $Response;
$this->SmsContent = $SmsContent;
$this->LastUpdateBy = $LastUpdateBy;
$this->LastUpdateStamp = $LastUpdateStamp;
}
}

?>