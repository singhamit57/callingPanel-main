<?php
include('../db.php');
include ('../setresult.php');
include ('../setupdateStamp.php');

$ResultMsj = "No Data Found...";
$timezone = new DateTimeZone('Asia/Kolkata');
$current_time = new DateTime('now' , $timezone );
$Date_Only = $current_time -> format('Y-m-d') ;
$AddStamp = $current_time -> format('Y-m-d G:i:s') ;
$sql = "";

function proper($value){
    return ucwords(strtolower($value));
}

function namake($value){
    if($value =='' or $value == null){
        return 'NA';
    }else{
        return $value;
    }
    
}


$PostdataList = json_decode(file_get_contents('php://input'), true);
if($PostdataList == null){die("No Data");
    
}



foreach($PostdataList as$Onedata ){
$TableID = ($Onedata['TableId']);
$CompanyID = ($Onedata['CompID']);
$CompanyName = ($Onedata['CompName']);
$LogedID = ($Onedata['LogedID']);
$LogedName = ($Onedata['LogedName']);
$FullName = proper($Onedata['FullName']);
$Mobile = proper($Onedata['Mobile']);
$AltMobile = proper($Onedata['AltMobile']);
$Email = strtolower($Onedata['EmailID']);
$Profile = proper($Onedata['Profile']);
$Experience = proper($Onedata['Expirence']);
$Country = proper($Onedata['Country']);
$State = proper($Onedata['State']);
$City = proper($Onedata['City']);
$Departments = proper($Onedata['Department']);
$DataCode = ($Onedata['Datacode']);
$GRepeateCount = "1";
$CRepeateCount = "1";

if($Email != ''){
$Emailcondi = " and  Email = '$Email' ";}
if($Mobile != ''){
$Mobilcondi = " and (Mobile = '$Mobile' or AltMobile = '$Mobile') ";}
if($AltMobile != ''){
$AltMobilcondi = " and (Mobile = '$AltMobile' or AltMobile = '$AltMobile') ";}
if($Emailcondi == '' and $Mobilcondi = '' and $AltMobilcondi = ''){
$nullCondi = " 1 ";}else{$nullCondi = "";}


$GRepeateQue = "SELECT COUNT(FullName) as 'GRepeateCount'  FROM LeadsDataBase where $nullCondi  ;";
$result =mysqli_query($conn,$GRepeateQue);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    $GRepeateCount = $row['GRepeateCount'];
    $GRepeateCount++;
}


 $CRepeateQue = "SELECT COUNT(FullName) as 'CRepeateCount'  FROM LeadsDataBase where CompanyID = '$CompanyID' $Emailcondi $Mobilcondi  $AltMobilcondi ; ";
// echo "$CRepeateQue </br>";
$result =mysqli_query($conn,$CRepeateQue);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    $CRepeateCount = $row['CRepeateCount'];
    $CRepeateCount++;
}

$FullName = namake($FullName);
$Mobile = namake($Mobile);
$AltMobile = namake($AltMobile);
$Email = namake($Email);
$Profile = namake($Profile);
$Experience = namake($Experience);
$Country = namake($Country);
$State = namake($State);
$City = namake($City);
$Departments = namake($Departments);
$DataCode = namake($DataCode);

if($TableID >1){
    $Newsql = "UPDATE LeadsDataBase SET FullName = '$FullName', Mobile = '$Mobile', AltMobile = '$AltMobile', Email = '$Email', Profile = '$Profile', Country = '$Country', State = '$State', City = '$City', Departments = '$Departments', DataCode = '$DataCode', LastUpdateBy = '$LogedID', LastUpdateStamp = '$AddStamp' WHERE Table_id = '$TableID'; ";
}else{
    $Newsql = "INSERT INTO LeadsDataBase (AddStamp, CompanyID, AddedBy, CompanyName, FullName, Mobile, AltMobile, Email, Profile, Experience,Country, State, City, Departments, DataCode, GRepeateCount, CRepeateCount) VALUE ('$AddStamp', '$CompanyID', '$LogedID', '$CompanyName', '$FullName', '$Mobile', '$AltMobile', '$Email', '$Profile', '$Experience','$Country', '$State', '$City', '$Departments', '$DataCode', '$GRepeateCount', '$CRepeateCount') ;";
}



$sql = $sql.$Newsql;
}





if ($conn->multi_query($sql) === TRUE) {
    settableupdate($CompanyID,'LeadsDataBase');
  echo "New records created successfully $AddStamp";
} else {
  echo "Error: " . $sql . "<br>" . $conn->error;
}




?>