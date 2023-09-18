<?php

class OneActivityDetail{
public $condition;

function __construct($condition){
include '../db.php';
$havedata = false;
if($condition!=''){
$query = "SELECT * FROM ActivityDetails $condition limit 1;";}
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
$Category = $row['Category'];
$Detail = $row['Detail'];

}

$this->HaveData = $havedata;
$this->TableId = $Table_id;
$this->AddStamp = $AddStamp;
$this->CompId = $CompanyID;
$this->CompName = $CompanyName;
$this->UserId = $UserID;
$this->FullName = $FullName;
$this->Category = $Category;
$this->Detail = $Detail;
}
}

?>