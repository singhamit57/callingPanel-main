<?php

include('../db.php');
include ('../setresult.php');
include ('../setupdateStamp.php');
$ResultMsj = "No Data Found...";

function nullcheck($value){
    if($value==''or $value== null){
        return 'Not Available';
    }else{
        return ucwords(strtolower($value));
    }
 
}


$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata == null){goto FailedSaving;}
//print_r($Postdatada
//die("NO Data");

$LogedUserId = $Postdata['LogedUserId'];
$LogedUserName = $Postdata['LogedUserName'];
$Isnewuser = $Postdata['Isnewuser'];
$PreTableId = $Postdata['PreTableId'];
$CompanyID = ($Postdata['CompanyID']);
$CompanyName = ($Postdata['CompanyName']);
$UserID = ($Postdata['UserID']);
$FullName = nullcheck($Postdata['FullName']);
$UserStatus = ($Postdata['UserStatus']);
$Mobile = ($Postdata['Mobile']);
$AltMobile = ($Postdata['AltMobile']);
$Email = nullcheck($Postdata['Email']);
$Country = nullcheck($Postdata['Country']);
$State = nullcheck($Postdata['State']);
$City = nullcheck($Postdata['City']);
$Pincode = nullcheck($Postdata['Pincode']);
$BankName = nullcheck($Postdata['BankName']);
$AccountNumber = nullcheck($Postdata['AccountNumber']);
$IFSC = nullcheck($Postdata['IFSC']);
$Gender = ($Postdata['Gender']);
$UserPassword = ($Postdata['Password']);
$DataCode = ($Postdata['DataCode']);
$ImagePic = ($Postdata['ImagePic']);
$AddressPic = ($Postdata['AddressPic']);
$Designation = ($Postdata['Designation']);
$Department = ($Postdata['Department']);
$Permission = ($Postdata['Permission']);

///Permissions
$AddEditSubAdmin = 0;
$AddEditDesignation = 0;
$AddEditDepartmetn = ($Postdata['AddEditDepartmetn']);
$AddEditResponse = ($Postdata['AddEditResponse']);
$AddEditUser = ($Postdata['AddEditUser']);
$AddEditLead = ($Postdata['AddEditLead']);
$DeleteUpdateLead = ($Postdata['DeleteUpdateLead']);
$ViewReports = ($Postdata['ViewReports']);
$DownloadReport = ($Postdata['DownloadReport']);
$UpdateReport = ($Postdata['UpdateReport']);
$MakeCall = ($Postdata['MakeCall']);
$SendSms = ($Postdata['SendSms']);
$SendMail = ($Postdata['SendMail']);
$LastUpdateBy = ($Postdata['LastUpdateBy']);

//$AddStamp = date("Y-m-d h:m:s", DateTime('now'));
$AddStamp = date("Y-m-d G:i:s");

if($UserStatus=="Active"){
    $UserStatus = '1';
}else{
    $UserStatus = '0';
}

if($Designation == 'Admin'){
$AddEditDepartmetn = "1";
$AddEditResponse = "1";
$AddEditUser = "1";
$AddEditLead = "1";
$DeleteUpdateLead = "1";
$ViewReports = "1";
$DownloadReport = "1";
$UpdateReport = "1";
$MakeCall = "1";
$SendSms = "1";
$SendMail = "1";
}


if( $PreTableId > 1){
    
     goto UpdateData;
}else{
   goto insertdata;
}


UpdateData:
$updatecount = 0;//$PreTableId
if($UserID==''){
$Getid = "SELECT UserID FROM `UserDetails` WHERE Table_id = '$PreTableId';";
$result =mysqli_query($conn,$Getid);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    //$UserID = $row['UserID'];
}

}

$UpdatePermission = "UPDATE PermissionDetails SET FullName = '$FullName', Designation = '$Designation', AddEditSubAdmin = '$AddEditSubAdmin', AddEditDepartmetn = '$AddEditDepartmetn', AddEditResponse = '$AddEditResponse', AddEditUser = '$AddEditUser', AddEditLead = '$AddEditLead', DeleteUpdateLead = '$DeleteUpdateLead', ViewReports = '$ViewReports', DownloadReport = '$DownloadReport', UpdateReport = '$UpdateReport', MakeCall = '$MakeCall' ,SendSms = '$SendSms', SendMail = '$SendMail' WHERE UserID = '$UserID' ;";
$result =mysqli_query($conn,$UpdatePermission);
if($conn->affected_rows>=1){
    $updatecount = $updatecount+1;
}
$UpdateLogin = "UPDATE LoginDetails SET  UserPassword = '$UserPassword',  FullName = '$FullName',UserStatus = '$UserStatus', Designation = '$Designation', Departments = '$Department', DataCode = '$DataCode', LastUpdateBy = '$LogedUserId', LastUpdateStamp = '$AddStamp' WHERE UserID = '$UserID' ;";

$result =mysqli_query($conn,$UpdateLogin);
if($conn->affected_rows>=1){
    $updatecount = $updatecount+1;
}

$UpdateUser = "UPDATE UserDetails SET FullName = '$FullName', Mobile = '$Mobile', AltMobile = '$AltMobile', Email = '$Email', Country = '$Country', State = '$State', City = '$City', BankName = '$BankName', AccountNumber = '$AccountNumber', IFSC = '$IFSC', Gender = '$Gender', Designation = '$Designation', Department = '$Department', LastUpdateBy = '$LogedUserId', LastUpdateStamp = '$AddStamp' WHERE UserID = '$UserID' ;";
$result =mysqli_query($conn,$UpdateUser);
if($conn->affected_rows>=1){
    $updatecount = $updatecount+1;
}

if($updatecount ==0){
    $ResultMsj = "Failed to update record... $UserID";
    goto FailedSaving;
}else{
    
    $updatekey = "UPDATE LoginDetails SET LoginKey = 'nokey' WHERE UserID = '$UserID';";
    $result =mysqli_query($conn,$updatekey);
    $ResultMsj = "Record updated...";
    goto RecordSaved;
    
}


insertdata:
    

$AllowdManager =0;
$AllowdCaller =0;
$CompDetails_que = "SELECT * FROM `CompaniesDetails` WHERE CompanyID = '$CompanyID';";
$result =mysqli_query($conn,$CompDetails_que);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    $AllowdManager =$row['MaxManager'];
    $AllowdCaller =$row['MaxTelecaller'];
    $CompPrefix =$row['Prefix'];
    
}


$check_count = "SELECT COUNT(Designation) as 'Count' FROM UserDetails WHERE CompanyID = '$CompanyID' AND Designation = '$Designation';";
$result =mysqli_query($conn,$check_count);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    $preUserCount = $row['Count']+1;
}else{$preUserCount = 1;}


if($Designation =='Admin'){
    $IDhead = $AdminPrefix ;
    
}
if($Designation =='Manager'){
    $IDhead = $ManagerPrefix ;
    if($preUserCount > $AllowdManager){
        $ResultMsj = "$Designation Limit over...";
        goto FailedSaving;
    }
}
if($Designation =='Telecaller'){
    $IDhead = $CallerPrefix;
    if($preUserCount > $AllowdCaller){
        $ResultMsj = "$Designation Limit over...";
        goto FailedSaving;
    }
}
if($Designation =='Super Admin'){
    $IDhead = $SuperAdminPrefix;
}

if($CompPrefix != ""){
    $IDhead = $CompPrefix;
}
    
$insert_user = "INSERT INTO UserDetails (AddStamp, CompanyID, CompanyName, UserID, FullName,  Mobile, AltMobile, Email, Country, State, City,  BankName, AccountNumber, IFSC, Gender,Designation, Department, Permission, LastUpdateBy, LastUpdateStamp ) VALUE ('$AddStamp', '$CompanyID', '$CompanyName', '', '$FullName',  '$Mobile', '$AltMobile', '$Email', '$Country', '$State', '$City',  '$BankName', '$AccountNumber', '$IFSC','$Gender', '$Designation', '$Department', '$RowID', '$LogedUserId', '$AddStamp' ) ;";
$result3 =mysqli_query($conn,$insert_user);
if($conn->affected_rows>=1){
     $Usertableid = $conn->insert_id;
     $Userid = $IDhead.($Usertableid + 1000) ;
     $Updateid = "UPDATE UserDetails SET UserID = '$Userid' WHERE Table_id = '$Usertableid';";
     $result4 =mysqli_query($conn,$Updateid);
       
    $insert_permi = "INSERT INTO PermissionDetails (AddStamp, CompanyID, CompanyName, UserID, FullName, Designation, AddEditSubAdmin, AddEditDepartmetn, AddEditResponse, AddEditUser, AddEditLead, DeleteUpdateLead, ViewReports, DownloadReport, UpdateReport, MakeCall, SendSms, SendMail, LastUpdateBy, LastUpdateStamp ) VALUE ('$AddStamp', '$CompanyID', '$CompanyName', '$Userid', '$FullName', '$Designation', '$AddEditSubAdmin',  '$AddEditDepartmetn', '$AddEditResponse', '$AddEditUser', '$AddEditLead', '$DeleteUpdateLead', '$ViewReports', '$DownloadReport', '$UpdateReport', '$MakeCall', '$SendSms', '$SendMail', '$LogedUserId', '$AddStamp' ) ;";
    $result =mysqli_query($conn,$insert_permi);
    if($conn->affected_rows>=1){
        $PermissionID = $conn->insert_id;
        
        $updateuser = "UPDATE UserDetails SET Permission = '$PermissionID' WHERE UserID = '$Userid' ;";
        $result2 =mysqli_query($conn,$updateuser);
        
        $insert_login = "INSERT INTO LoginDetails (AddStamp, CompanyID, CompanyName,  UserID, UserPassword, FullName, Designation, Departments, LastUpdateBy, LastUpdateStamp,UserStatus ) VALUE ('$AddStamp', '$CompanyID', '$CompanyName',  '$Userid', '$UserPassword', '$FullName', '$Designation', '$Department', '$LogedUserId', '$AddStamp','$UserStatus') ;";
        $result2 =mysqli_query($conn,$insert_login);
        if($conn->affected_rows>=1){
        $ResultMsj = "User Added...";
        goto RecordSaved;
            
        }else{
            goto FailedSaving;
        }
        
    }else{
        goto FailedSaving;
    }  
    
}else{
    
    goto FailedSaving;
}
    

    
    



RecordSaved:
settableupdate($CompanyID,'PermissionDetails');
settableupdate($CompanyID,'UserDetails');
settableupdate($CompanyID,'LoginDetails');
setresult(true,$ResultMsj,array());

FailedSaving:
setresult(false,$ResultMsj ??'Failed to save record...',"");


?>