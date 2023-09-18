<?php

class OnePermissionDetail{
public $condition;
function __construct($condition){
include '../db.php';
$havedata = false;
if($condition!=''){
$query = "SELECT * FROM PermissionDetails $condition limit 1;";}
$result =mysqli_query($conn,$query);
if($conn->affected_rows>=1){
$row = $result->fetch_assoc();
$havedata = true;
$Table_id = $row['Table_id'];
$AddStamp = $row['AddStamp'];
$CompanyID = $row['CompanyID'];
$CompanyName = $row['CompanyName'];
$UserID = $row['UserID'];
$FullName = $row['FullName'];
$Designation = $row['Designation'];
$AddEditDesignation = $row['AddEditDesignation'];
$AddEditDepartmetn = $row['AddEditDepartmetn'];
$AddEditResponse = $row['AddEditResponse'];
$AddEditUser = $row['AddEditUser'];
$AddEditLead = $row['AddEditLead'];
$DeleteUpdateLead = $row['DeleteUpdateLead'];
$ViewReports = $row['ViewReports'];
$DownloadReport = $row['DownloadReport'];
$UpdateReport = $row['UpdateReport'];
$MakeCall = $row['MakeCall'];
$SendSms = $row['SendSms'];
$SendMail = $row['SendMail'];
$LastUpdateBy = $row['LastUpdateBy'];
$LastUpdateStamp = $row['LastUpdateStamp'];

}

$this->HaveData = $havedata;
$this->TableId = $Table_id;
$this->AddStamp = $AddStamp;
$this->CompId = $CompanyID;
$this->CompName = $CompanyName;
$this->UserId = $UserID;
$this->FullName = $FullName;
$this->Designation = $Designation;
$this->AddEditDesignation = $AddEditDesignation;
$this->AddEditDepartmetn = $AddEditDepartmetn;
$this->AddEditResponse = $AddEditResponse;
$this->AddEditUser = $AddEditUser;
$this->AddEditLead = $AddEditLead;
$this->DeleteUpdateLead = $DeleteUpdateLead;
$this->ViewReports = $ViewReports;
$this->DownloadReport = $DownloadReport;
$this->UpdateReport = $UpdateReport;
$this->MakeCall = $MakeCall;
$this->SendSms = $SendSms;
$this->SendMail = $SendMail;
$this->LastUpdateBy = $LastUpdateBy;
$this->LastUpdateStamp = $LastUpdateStamp;
}
}


?>