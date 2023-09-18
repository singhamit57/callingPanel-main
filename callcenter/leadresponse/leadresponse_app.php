<?php

include '../db.php';
include ('../setresult.php');
include ('../setupdateStamp.php');

$Resultdata = array();
$message = 'No data received';
function replacer($value){
   $value= str_replace("'","",$value);
   $value = ucwords(strtolower($value));
   if($value==null or $value == ''){
       $value = 'NA';
   }
   return $value;
}

$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompId'];
    $CompName = $Postdata['CompName'];
    $UserID = $Postdata['UserID'];
    $UserName = $Postdata['UserName'];
    $UserDepart = $Postdata['UserDepart'];
    $TableID = $Postdata['TableID'];
    $DataType = $Postdata['DataType'];
    $HaveData = $Postdata['HaveData'];
    $FullName = replacer($Postdata['FullName']);
    $Mobile = $Postdata['Mobile'];
    $AltMobile = $Postdata['AltMobile'];
    $Email = strtolower(replacer($Postdata['Email']));
    $Profile = replacer($Postdata['Profile']);
    $Country = replacer($Postdata['Country']);
    $State = replacer($Postdata['State']);
    $City = replacer($Postdata['City']);
    $SelectedDepart = $Postdata['SelectedDepart'];
    $SelectedResponse = $Postdata['SelectedResponse'];
    $MeetingDate = $Postdata['MeetingDate'];
    $Priority = $Postdata['Priority'];
    $Remark = replacer($Postdata['Remark']);
    $FinalResult = $Postdata['FinalResult'];
    $callstart = $Postdata['callstart'];
    $callend = $Postdata['callend'];
    
   
    
}else{
        goto Fail;
}

$MeetingDate = date_format(date_create($MeetingDate),"Y-m-d");
if($MeetingDate == date('Y-m-d')){
    $MeetingDate = '0000-00-00';
}
if($FinalResult=='' or $FinalResult =='Lead Result'){
    $FinalResult = 'NA';
}

$Timestamp = date("Y-m-d G:i:s");
function callduration($Start,$end){
    try{
$datetime1 = new DateTime($Start);//start time
$datetime2 = new DateTime($end);//end time
$interval = $datetime1->diff($datetime2);
return $interval->format('%s');
}catch(Exception $e){
return "0";
}

   
}




if($DataType == 'newdata'){

$GRepeateCount = "1";
$CRepeateCount = "1";

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
$message = 'Lead alredy exist...';
//goto Fail;
}

$Departments = $UserDepart[0];
$Newsql = "INSERT INTO LeadsDataBase (AddStamp, CompanyID, AddedBy, CompanyName, FullName, Mobile, AltMobile, Email, Profile, Experience,Country, State, City, Departments, DataCode, GRepeateCount, CRepeateCount) VALUE ('$Timestamp', '$CompID', '$UserID', '$CompName', '$FullName', '$Mobile', '$AltMobile', '$Email', '$Profile', '$Experience','$Country', '$State', '$City', '$Departments', '$UserID', '$GRepeateCount', '$CRepeateCount') ;";
$result =mysqli_query($conn,$Newsql);
if($conn->affected_rows>=1){
    $message = 'Lead saved successfully...';
goto Success;
}else{
    $message = 'Failed to save lead...';
goto Fail;
}
    
}

///Data Types ---> callhistory newdata leaddata
if($DataType == 'callhistory' or $DataType == 'leaddata'){
    
    $CallDure_Que = "SELECT TIMESTAMPDIFF(SECOND,CallStartStamp,CallEndStamp) as 'CallDuration' FROM LeadsDataBase WHERE Table_id = '$TableID' ";
    $result =mysqli_query($conn,$CallDure_Que);
    if($conn->affected_rows >=1){
        $Predata =$result->fetch_assoc();
        $CallDurationByTable = $Predata['CallDuration'];
        
    }
    
    $callDuartionByInput = callduration($callstart,$callend);
    
    if($CallDurationByTable >=1){
        $callDuartion = $CallDurationByTable;
    }else{
        $callDuartion = $callDuartionByInput;
    }
    
    
    $Datadetails = "SELECT * FROM `LeadsDataBase` WHERE Table_id = '$TableID';";
    $result =mysqli_query($conn,$Datadetails);
    if($conn->affected_rows >=1){
        $Predata =$result->fetch_assoc();
        $DataCode = $Predata['DataCode'];
        $PreFollowStamp = $Predata['AddStamp'];
        $PreUserid= $Predata['IssuedUser'];
        $PreRespose= $Predata['LastResponse'];
        $PreIntDate= $Predata['LastIntDate'];
        $PrePriority= $Predata['LastPriority'];
        $PreLeadResult= $Predata['LastLeadResult'];
        $PreRemark= $Predata['LastRemark'];
        $PreCallDuration= $Predata['LastCallDuration'];
        $PreDepartment= $Predata['LastDepartment'];
        
    }else{
        $message = 'No Details found';
        goto Fail;
    }
    
    $respCountQue = "SELECT COUNT(LeadID) as 'RespCount' FROM LeadResponse WHERE LeadID = '$TableID';";
    $result =mysqli_query($conn,$respCountQue);
    if($conn->affected_rows >=1){
        $row =$result->fetch_assoc();
        $RespCount = $row['RespCount']+1;
    }else{$RespCount = 1;}
    
    
    
    $Saveresponse = "INSERT  INTO LeadResponse ( AddStamp, CompanyID, LeadID, Userid, Department, Response, IntDate, Priority, LeadResult, Remark, CallDuration, DataCode, RespCount, LastUpdateStamp, LastUpdateBy ) VALUE ( '$Timestamp', '$CompID', '$TableID', '$UserID', '$SelectedDepart', '$SelectedResponse', '$MeetingDate', '$Priority', '$FinalResult', '$Remark', '$callDuartion', '$DataCode', '$RespCount', '$Timestamp', '$UserID' );";
    $result =mysqli_query($conn,$Saveresponse);
    if($conn->affected_rows ==0){  
        $message = 'Failed to save leadresponse';
        goto Fail;  }
        
    
    if($DataType =='callhistory'){
        $Savefollow = "INSERT INTO FollowUpHistory (PreFollowStamp, LastFollowStamp, CompanyID, LeadID, PreUserid, LastUserid, PreRespose, LastResponse, PreIntDate, LastIntDate, PrePriority, LastPriority, PreLeadResult, LastLeadResult, PreRemark, LastRemark, PreCallDuration, LastCallDuration, PreDepartment, LastDepartment ) VALUE (PreFollowStamp, '$Timestamp', '$CompID', '$TableID', '$PreUserid', '$UserID', '$PreRespose', '$SelectedResponse', '$PreIntDate', '$MeetingDate', '$PrePriority', '$Priority', '$PreLeadResult', '$FinalResult', '$PreRemark', '$Remark', '$PreCallDuration', '$callDuartion', '$PreDepartment', '$SelectedDepart' );";
    $result =mysqli_query($conn,$Savefollow);
    if($conn->affected_rows ==0){  
        $message = 'Failed to save followup';
        goto Fail;  }
    }
    
        
    $updatebase = "UPDATE LeadsDataBase SET LastDepartment = '$SelectedDepart', LastResponse = '$SelectedResponse', LastIntDate ='$MeetingDate', LastPriority ='$Priority', LastLeadResult = '$FinalResult', LastRemark = '$Remark',LastCallDuration = '$callDuartion',RespStamp = '$Timestamp' WHERE Table_id = '$TableID';";
    $result =mysqli_query($conn,$updatebase);
    if($conn->affected_rows ==0){  
    $message = 'Failed to update lead base';
    goto Fail;  }else{
            $message = "Response saved successfully";
            goto Success;
        }
    
}

$message = 'No data type found';
goto Fail;



Success:
    settableupdate($CompID,'LeadsDataBase');
    settableupdate($CompID,'FollowUpHistory');
    settableupdate($CompID,'LeadResponse');
   
    setresult(true,$message,$Resultdata);
Fail:
    setresult(false,$message,$Resultdata);

?>