<?php

class OneUserDetails{
public $condition;
function __construct($condition){
include '../db.php';
$havedata = false;
if($condition!=''){
$query = "SELECT * FROM UserDetails $condition limit 1;";}
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
$FatherName = $row['FatherName'];
$Mobile = $row['Mobile'];
$AltMobile = $row['AltMobile'];
$Email = $row['Email'];
$Country = $row['Country'];
$State = $row['State'];
$City = $row['City'];
$Pincode = $row['Pincode'];
$BankName = $row['BankName'];
$AccountNumber = $row['AccountNumber'];
$IFSC = $row['IFSC'];
$ImagePic = $row['ImagePic'];
$AddressPic = $row['AddressPic'];
$Designation = $row['Designation'];
$Department = $row['Department'];
$Permission = $row['Permission'];

}

$this->HaveData = $havedata;
$this->Tableid = $Table_id;
$this->AddStamp = $AddStamp;
$this->CompId = $CompanyID;
$this->CompName = $CompanyName;
$this->UserId = $UserID;
$this->FullName = $FullName;
$this->FatherName = $FatherName;
$this->Mobile = $Mobile;
$this->AltMobile = $AltMobile;
$this->Email = $Email;
$this->Country = $Country;
$this->State = $State;
$this->City = $City;
$this->Pincode = $Pincode;
$this->BankName = $BankName;
$this->AccountNumber = $AccountNumber;
$this->IFSC = $IFSC;
$this->ImagePicId = $ImagePic;
$this->AddressPicId = $AddressPic;
$this->Designation = $Designation;
$this->Department = $Department;
$this->PermissionId = $Permission;
}
}


class UserDetailsByTableId{
public $id;
function __construct($id){
include '../db.php';
$havedata = false;
$query = "SELECT * FROM UserDetails WHERE Table_id = '$id';";
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
$FatherName = $row['FatherName'];
$Mobile = $row['Mobile'];
$AltMobile = $row['AltMobile'];
$Email = $row['Email'];
$Country = $row['Country'];
$State = $row['State'];
$City = $row['City'];
$Pincode = $row['Pincode'];
$BankName = $row['BankName'];
$AccountNumber = $row['AccountNumber'];
$IFSC = $row['IFSC'];
$ImagePic = $row['ImagePic'];
$AddressPic = $row['AddressPic'];
$Designation = $row['Designation'];
$Department = $row['Department'];
$Permission = $row['Permission'];

}

$this->HaveData = $havedata;
$this->Tableid = $Table_id;
$this->AddStamp = $AddStamp;
$this->CompId = $CompanyID;
$this->CompName = $CompanyName;
$this->UserId = $UserID;
$this->FullName = $FullName;
$this->FatherName = $FatherName;
$this->Mobile = $Mobile;
$this->AltMobile = $AltMobile;
$this->Email = $Email;
$this->Country = $Country;
$this->State = $State;
$this->City = $City;
$this->Pincode = $Pincode;
$this->BankName = $BankName;
$this->AccountNumber = $AccountNumber;
$this->IFSC = $IFSC;
$this->ImagePicId = $ImagePic;
$this->AddressPicId = $AddressPic;
$this->Designation = $Designation;
$this->Department = $Department;
$this->PermissionId = $Permission;
}
}



?>