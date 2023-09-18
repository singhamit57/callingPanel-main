<?php
class OneLeadResponse{
public $condition;
function __construct($condition){
include '../db.php';
$havedata = false;
if($condition!=''){
$query = "SELECT * FROM LeadResponse $condition limit 1;";}
$result =mysqli_query($conn,$query);
if($conn->affected_rows>=1){
$row = $result->fetch_assoc();
$havedata = true;
$Table_id = $row['Table_id'];
$AddStamp = $row['AddStamp'];
$CompanyID = $row['CompanyID'];
$LeadID = $row['LeadID'];
$Userid = $row['Userid'];
$Department = $row['Department'];
$Response = $row['Response'];
$IntDate = $row['IntDate'];
$Remark = $row['Remark'];
$CallDuration = $row['CallDuration'];
$DataCode = $row['DataCode'];
$RespCount = $row['RespCount'];
$LastUpdateStamp = $row['LastUpdateStamp'];
$LastUpdateBy = $row['LastUpdateBy'];

}

$this->HaveData = $havedata;
$this->TableId = $Table_id;
$this->AddStamp = $AddStamp;
$this->CompId = $CompanyID;
$this->LeadId = $LeadID;
$this->UserId = $Userid;
$this->Department = $Department;
$this->Response = $Response;
$this->IntDate = $IntDate;
$this->Remark = $Remark;
$this->CallDuration = $CallDuration;
$this->DataCode = $DataCode;
$this->RespCount = $RespCount;
$this->LastUpdateStamp = $LastUpdateStamp;
$this->LastUpdateBy = $LastUpdateBy;
}
}

?>