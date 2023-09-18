<?php
include '../db.php';
include '../setresult.php';
include '../setupdateStamp.php';

$message = 'No Data Received';

function propercase($value){
    return ucwords(strtolower($value)); 
}

$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
$LogedUserId = $Postdata['LogedUserID'];
$LogedUserName = $Postdata['LogedUserName'];
$LogedUserCompId = $Postdata['LogedUserCompID'];
$IsNewCompany = $Postdata['IsNewCompany'];
$PreTableId = $Postdata['TableId'];
$CompanyId = $Postdata['CompId'];
$CompanyName = ($Postdata['CompName']);
$CompanyStatus = ($Postdata['CompStatus']);
$FullAddress = propercase($Postdata['FullAddress']);
$Mobile = ($Postdata['CompMobile']);
$AltMobile = ($Postdata['CompAltMobile']);
$Email = strtolower($Postdata['CompEmail']);
$Website = strtolower($Postdata['Website']);
$GSTIN = ($Postdata['GSTIN']);
$Country = propercase($Postdata['Country']);
$State = propercase($Postdata['State']);
$City = propercase($Postdata['City']);

$Prefix = strtolower($Postdata['CompPrefix']);

$EnableSms = ($Postdata['SmsEnable']);
$EnableMail = ($Postdata['MailEnable']);
$LastUpdateBy = ($Postdata['LastUpdateBy']);
$LastUpdateStamp = ($Postdata['LastUpdateStamp']);
$MaxResponses = ($Postdata['MaxResponses']);
$MaxDepartment= ($Postdata['MaxDeparts']);
$MaxManager= ($Postdata['MaxManagers']);
$MaxTelecaller= ($Postdata['MaxTelecallers']);
$ActivateDate= ($Postdata['ActivateDate']);
}else{
    goto Failed;
}

$CompanyID = "";
$AddStamp = date('Y-m-d G:i:s');
if($CompanyStatus=='Active'){
    $CompanyStatus = '1';
}else{
    $CompanyStatus = '0';
}

if($MaxResponses >=1 ==false ){
    $message = 'Please enter max response limit';
    goto Failed;
}

if($MaxDepartment >=1 ==false ){
    $message = 'Please enter max department limit';
    goto Failed;
}

if($MaxManager >=1 ==false ){
    $message = 'Please enter max managers limit';
    goto Failed;
}

if($MaxTelecaller >=1 ==false ){
    $message = 'Please enter max telecallers limit';
    goto Failed;
}


if($PreTableId == ''){
    goto InsertCompany ;
}


UpdateCompany:
$Update_comp = "UPDATE CompaniesDetails SET ActivationDate = '$ActivateDate', CompanyName = '$CompanyName', CompanyStatus = '$CompanyStatus', Mobile = '$Mobile', AltMobile = '$AltMobile', Email = '$Email', Country = '$Country', State = '$State', City = '$City', Prefix = '$Prefix', MaxResponses = '$MaxResponses', MaxDepartment = '$MaxDepartment', MaxManager = '$MaxManager', MaxTelecaller = '$MaxTelecaller', EnableSms = '$EnableSms', EnableMail = '$EnableMail', LastUpdateBy = '$LogedUserId', LastUpdateStamp = '$AddStamp' WHERE Table_id = '$PreTableId' AND CompanyID = '$CompanyId' ;";

$result = mysqli_query($conn,$Update_comp);
if($conn->affected_rows){
    $message = 'Compnay updated successfully....';
goto Success;
}else{
    $message = 'Failed to update company...';
goto Failed;
}


InsertCompany:
$uniqueid = uniqid()."_".$LogedUserId;

$insert_comp = " INSERT INTO CompaniesDetails (AddStamp,ActivationDate ,CompanyID, CompanyName, CompanyStatus, FullAddress, Mobile, AltMobile, Email, Website, Country, State, City, Prefix, MaxResponses, MaxDepartment, MaxManager, MaxTelecaller, EnableSms, EnableMail, LastUpdateBy, LastUpdateStamp ) VALUE ('$AddStamp','$ActivateDate' ,'', '$CompanyName', '$CompanyStatus', '$FullAddress', '$Mobile', '$AltMobile', '$Email', '$Website', '$Country', '$State', '$City','$Prefix', '$MaxResponses', '$MaxDepartment', '$MaxManager', '$MaxTelecaller', '$EnableSms', '$EnableMail', '$LogedUserId', '$AddStamp' ) ; ";
$result = mysqli_query($conn,$insert_comp);
if($conn -> affected_rows >=1){
    $InsetedRow = $conn ->insert_id ;
    $newcompid = "agcomp$InsetedRow";
    $updateId = "UPDATE CompaniesDetails SET CompanyID ='$newcompid' WHERE Table_id = '$InsetedRow';";
    $result = mysqli_query($conn,$updateId);
    if($conn ->affected_rows>=1){
        $message = 'New company saved successfully...';
    goto Success;
    }else{
        $message = "Failed to generate company id... $updateId";
    goto Failed;
    }

    
}else{
    $message = 'Failed to save new company...';
goto Failed;
}

Success:
settableupdate($LogedUserCompId,'CompaniesDetails');
setresult(true,$message,'');

Failed:
setresult(false,$message,'');

?>