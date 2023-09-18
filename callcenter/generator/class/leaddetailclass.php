<?php
class OneLeadDetail{
public $condition;
function __construct($condition){
include '../db.php';
$havedata = false;
if($condition!=''){
$query = "SELECT * FROM LeadsDataBase $condition limit 1;";}
$result =mysqli_query($conn,$query);
if($conn->affected_rows>=1){
$row = $result->fetch_assoc();
$havedata = true;
$Table_id = $row['Table_id'];
$AddStamp = $row['AddStamp'];
$CompanyID = $row['CompanyID'];
$CompanyName = $row['CompanyName'];
$FullName = $row['FullName'];
$Mobile = $row['Mobile'];
$AltMobile = $row['AltMobile'];
$Email = $row['Email'];
$Profile = $row['Profile'];
$Experience = $row['Experience'];
$City = $row['City'];
$Locality = $row['Locality'];
$Qualification = $row['Qualification'];
$Departments = $row['Departments'];
$DataCode = $row['DataCode'];
$GRepeateCount = $row['GRepeateCount'];
$CRepeateCount = $row['CRepeateCount'];
$IssuedID = $row['IssuedID'];
$IssueStamp = $row['IssueStamp'];
$IssuedUser = $row['IssuedUser'];
$LastDepartment = $row['LastDepartment'];
$LastResponse = $row['LastResponse'];
$LastIntDate = $row['LastIntDate'];
$LastRemark = $row['LastRemark'];
$LastCallDuration = $row['LastCallDuration'];
$RespStamp = $row['RespStamp'];
$RespCount = $row['RespCount'];
$LastUpdateStamp = $row['LastUpdateStamp'];
$LastUpdateBy = $row['LastUpdateBy'];

}

$this->HaveData = $havedata;
$this->TableId = $Table_id;
$this->AddStamp = $AddStamp;
$this->CompId = $CompanyID;
$this->CompName = $CompanyName;
$this->FullName = $FullName;
$this->Mobile = $Mobile;
$this->AltMobile = $AltMobile;
$this->Email = $Email;
$this->Profile = $Profile;
$this->Experience = $Experience;
$this->City = $City;
$this->Locality = $Locality;
$this->Qualification = $Qualification;
$this->Departments = $Departments;
$this->DataCode = $DataCode;
$this->GRepeateCount = $GRepeateCount;
$this->CRepeateCount = $CRepeateCount;
$this->IssuedID = $IssuedID;
$this->IssueStamp = $IssueStamp;
$this->IssuedUser = $IssuedUser;
$this->LastDepartment = $LastDepartment;
$this->LastResponse = $LastResponse;
$this->LastIntDate = $LastIntDate;
$this->LastRemark = $LastRemark;
$this->LastCallDuration = $LastCallDuration;
$this->RespStamp = $RespStamp;
$this->RespCount = $RespCount;
$this->LastUpdateStamp = $LastUpdateStamp;
$this->LastUpdateBy = $LastUpdateBy;
}
}

?>