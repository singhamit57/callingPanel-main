<?php
include('../db.php');
include ('../setresult.php');
include ('../setupdateStamp.php');
$ResultMsj = "No Data Found...";

$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata == null){die("No Data");}


$CompanyID = ($Postdata['CompID']);
$CompanyName = ($Postdata['CompName']);
$LogedID = ($Postdata['LogedID']);
$LogedName = ($Postdata['LogedName']);
$FullName = ($Postdata['FullName']);
$Mobile = ($Postdata['Mobile']);
$AltMobile = ($Postdata['AltMobile']);
$Email = ($Postdata['EmailID']);
$Profile = ($Postdata['Profile']);
$Experience = ($Postdata['Expirence']);
$Country = ($Postdata['Country']);
$State = ($Postdata['State']);
$City = ($Postdata['City']);
$Departments = ($Postdata['Department']);
$DataCode = ($Postdata['DataCode']);
$GRepeateCount = "1";
$CRepeateCount = "1";
$timezone = new DateTimeZone('Asia/Kolkata');
$current_time = new DateTime('now' , $timezone );
$Date_Only = $current_time -> format('Y-m-d') ;
$AddStamp = $current_time -> format('Y-m-d h:m:s') ;


if($Email != ''){
$Emailcondi = "  Email = '$Email' ";}
if($Mobile != ''){
$Mobilcondi = " (Mobile = '$Mobile' or AltMobile = '$Mobile') ";}
if($AltMobile != ''){
$AltMobilcondi = " (Mobile = '$AltMobile' or AltMobile = '$AltMobile') ";}
if($Emailcondi == '' and $Mobilcondi = '' and $AltMobilcondi = ''){
$nullCondi = " 1 ";}else{$nullCondi = "";}

$GRepeateQue = "SELECT COUNT(FullName) as 'GRepeateCount'  FROM LeadsDataBase where $nullCondi  ;";
$result =mysqli_query($conn,$GRepeateQue);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    $GRepeateCount = $row['GRepeateCount'];
    $GRepeateCount++;
}


 $CRepeateQue = "SELECT COUNT(FullName) as 'CRepeateCount'  FROM LeadsDataBase where  ( Email = '$Email' or (Mobile = '$Mobile' or AltMobile = '$Mobile') or (Mobile = '$AltMobile' or AltMobile = '$AltMobile'))  and Email <>'' AND Mobile <>'' and AltMobile<>'' ;";
// echo "$CRepeateQue </br>";
$result =mysqli_query($conn,$CRepeateQue);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    $CRepeateCount = $row['CRepeateCount'];
    $CRepeateCount++;
}

$insert_data = "INSERT INTO LeadsDataBase (AddStamp, CompanyID, AddedBy, CompanyName, FullName, Mobile, AltMobile, Email, Profile, Experience,Country, State, City, Departments, DataCode, GRepeateCount, CRepeateCount) VALUE ('$AddStamp', '$CompanyID', '$LogedID', '$CompanyName', '$FullName', '$Mobile', '$AltMobile', '$Email', '$Profile', '$Experience','$Country', '$State', '$City', '$Departments', '$DataCode', '$GRepeateCount', '$CRepeateCount') ;";
$result =mysqli_query($conn,$insert_data);
if($conn->affected_rows>=1){
    settableupdate($CompanyID,'LeadsDataBase');
    echo "Saved";
}else{
    echo "Failed";
}




?>