<?php
class OneFollowUpHistory{
public $condition;
function __construct($condition){
include '../db.php';
$havedata = false;
if($condition!=''){
$query = "SELECT * FROM FollowUpHistory $condition limit 1;";}
$result =mysqli_query($conn,$query);
if($conn->affected_rows>=1){
$row = $result->fetch_assoc();
$havedata = true;
$Table_id = $row['Table_id'];
$PreFollowStamp = $row['PreFollowStamp'];
$LastFollowStamp = $row['LastFollowStamp'];
$CompanyID = $row['CompanyID'];
$LeadID = $row['LeadID'];
$PreUserid = $row['PreUserid'];
$LastUserid = $row['LastUserid'];
$PreRespose = $row['PreRespose'];
$LastResponse = $row['LastResponse'];
$PreIntDate = $row['PreIntDate'];
$LastIntDate = $row['LastIntDate'];
$PreRemark = $row['PreRemark'];
$LastRemark = $row['LastRemark'];
$PreCallDuration = $row['PreCallDuration'];
$LastCallDuration = $row['LastCallDuration'];

}

$this->HaveData = $havedata;
$this->TableId = $Table_id;
$this->PreFollowStamp = $PreFollowStamp;
$this->LastFollowStamp = $LastFollowStamp;
$this->CompId = $CompanyID;
$this->LeadId = $LeadID;
$this->PreUserid = $PreUserid;
$this->LastUserid = $LastUserid;
$this->PreRespose = $PreRespose;
$this->LastResponse = $LastResponse;
$this->PreIntDate = $PreIntDate;
$this->LastIntDate = $LastIntDate;
$this->PreRemark = $PreRemark;
$this->LastRemark = $LastRemark;
$this->PreCallDuration = $PreCallDuration;
$this->LastCallDuration = $LastCallDuration;
}
}

?>