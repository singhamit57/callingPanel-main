<?php
class OneCompanyDetail{
public $condition;
function __construct($condition){
include '../db.php';
$havedata = false;
if($condition!=''){
$query = "SELECT * FROM CompaniesDetails $condition limit 1;";}
$result =mysqli_query($conn,$query);
if($conn->affected_rows>=1){
    $row = $result->fetch_assoc();
    $havedata = true;
    $Table_id = $row['Table_id'];
    $AddStamp = $row['AddStamp'];
    $CompanyID = $row['CompanyID'];
    $CompanyName = $row['CompanyName'];
    $CompanyStatus = $row['CompanyStatus'];
    $FullAddress = $row['FullAddress'];
    $Mobile = $row['Mobile'];
    $Email = $row['Email'];
    $Website = $row['Website'];
    $GSTIN = $row['GSTIN'];
    $Country = $row['Country'];
    $State = $row['State'];
    $City = $row['City'];
    $Pincode = $row['Pincode'];
    $Prefix = $row['Prefix'];
    $Suffix = $row['Suffix'];
    $LastUpdateBy = $row['LastUpdateBy'];
    $LastUpdateStamp = $row['LastUpdateStamp'];

}

$this->HaveData = $havedata;
$this->Tableid = $Table_id;
$this->AddStamp = $AddStamp;
$this->CompId = $CompanyID;
$this->CompName = $CompanyName;
$this->CompStatus = $CompanyStatus;
$this->CompAddress = $FullAddress;
$this->Mobile = $Mobile;
$this->Email = $Email;
$this->Website = $Website;
$this->Gstin = $GSTIN;
$this->Country = $Country;
$this->State = $State;
$this->City = $City;
$this->Pincode = $Pincode;
$this->Prefix = $Prefix;
$this->Suffix = $Suffix;
$this->LastUpdateBy = $LastUpdateBy;
$this->LastUpdateStamp = $LastUpdateStamp;
}
}


?>