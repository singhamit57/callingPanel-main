<?php

class OneResponsesDetails{
public $condition;
function __construct($condition){
include '../db.php';
$havedata = false;
if($condition!=''){
$query = "SELECT * FROM ResponsesDetails $condition limit 1;";}
$result =mysqli_query($conn,$query);
if($conn->affected_rows>=1){
$row = $result->fetch_assoc();
$havedata = true;
$Table_id = $row['Table_id'];
$CompanyID = $row['CompanyID'];
$CompanyName = $row['CompanyName'];
$Response = $row['Response'];
$NeedIntDate = $row['NeedIntDate'];
$NeedRemark = $row['NeedRemark'];
$SendSms = $row['SendSms'];
$SendMail = $row['SendMail'];
$LastUpdateBy = $row['LastUpdateBy'];
$LastUpdateStamp = $row['LastUpdateStamp'];

}

$this->HaveData = $havedata;
$this->TableId = $Table_id;
$this->CompId = $CompanyID;
$this->CompName = $CompanyName;
$this->Response = $Response;
$this->NeedIntDate = $NeedIntDate;
$this->NeedRemark = $NeedRemark;
$this->SendSms = $SendSms;
$this->SendMail = $SendMail;
$this->LastUpdateBy = $LastUpdateBy;
$this->LastUpdateStamp = $LastUpdateStamp;
}
}

?>