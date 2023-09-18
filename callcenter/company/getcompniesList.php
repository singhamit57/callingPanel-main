<?php
include '../db.php';
include '../setresult.php';

function propercase($value){
    return ucwords(strtolower($value)); 
}
$message = 'No data received...';
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
$LogedUserId = $Postdata['LogedUserID'];
$LogedUserName = $Postdata['LogedUserName'];
$LogedUserCompId = $Postdata['LogedUserCompID'];
$IsNewCompany = $Postdata['IsNewCompany'];
$PreTableId = $Postdata['TableId'];
$CompanyId = $Postdata['CompId'];

}else{
  //  goto NoData;
}


function getusedcount($querry){
    include '../db.php';
    $result = mysqli_query($conn,$querry);
    $Count = '0';
    if($conn -> affected_rows >=1){
        $rowresult =  mysqli_fetch_assoc($result);
        $Count = $rowresult['Count'];
    }
    return $Count ??'0';
}
$resultdata = array();
$querry = "SELECT * FROM `CompaniesDetails` WHERE 1";
$result = mysqli_query($conn,$querry);
if($conn -> affected_rows >=1){
    while($row =  mysqli_fetch_assoc($result)){
        $onedata = array();
        $compId = $row['CompanyID'];
        $AddStamp = $row['AddStamp']; //date("d-M-Y", strtotime($row['AddStamp']));
        $ActivationDate = $row['ActivationDate'];
        $LastUpdateStamp = $row['LastUpdateStamp'];
        $onedata['TableId'] = $row['Table_id'];
        $onedata['CompId'] = $row['CompanyID'];
        $onedata['CompName'] = $row['CompanyName'].($compId=='agc202101'?' (Head Company)':'');
        $onedata['CompStatus'] = $row['CompanyStatus'];
        $onedata['CompMobile'] = $row['Mobile'];
        $onedata['CompAltMobile'] = $row['AltMobile'];
        $onedata['CompEmail'] = $row['Email'];
        $onedata['Country'] = $row['Country'];
        $onedata['State'] = $row['State'];
        $onedata['City'] = $row['City'];
        $onedata['CompPrefix'] = $row['Prefix'];
        $onedata['MaxResponses'] = $row['MaxResponses'];
        $onedata['MaxDeparts'] = $row['MaxDepartment'];
        $onedata['MaxManagers'] = $row['MaxManager'];
        $onedata['MaxTelecallers'] = $row['MaxTelecaller'];
        $onedata['SmsEnable'] = $row['EnableSms'];
        $onedata['MailEnable'] = $row['EnableMail'];
        $onedata['LastUpdateBy'] = $row['LastUpdateBy']??'';
        $onedata['LastUpdateDate'] = $LastUpdateStamp =='0000-00-00 00:00:00'?'': date("d-M-Y", strtotime($LastUpdateStamp)) ;
        $onedata['LastUpdateTime'] = $LastUpdateStamp =='0000-00-00 00:00:00'?'':date("G:i:sA", strtotime($LastUpdateStamp)) ;
        $onedata['ActivateDate'] = date("d-M-Y", strtotime($ActivationDate)) ;
        $onedata['AddDate'] = date("d-M-Y", strtotime($AddStamp )) ;
        $onedata['AddTime'] = date("G:i:sA", strtotime($AddStamp )) ;
        //Responses
        $countque = "SELECT COUNT(Response) as 'Count' FROM ResponsesDetails WHERE CompanyID = '$compId';";
        $onedata['UsedResponses'] = getusedcount($countque);
        //Departnebt
        $countque = "SELECT COUNT(Department) as 'Count' FROM DepartmentsDetails WHERE CompanyID = '$compId';";
        $onedata['UsedDeparts'] = getusedcount($countque);
        //Managers
        $countque = "SELECT COUNT(FullName) FROM UserDetails WHERE CompanyID = '$compId' AND Designation = 'Manager' ;";
        $onedata['UsedManagers'] = getusedcount($countque);
        //Telecallers
        $countque = "SELECT COUNT(FullName) FROM UserDetails WHERE CompanyID = '$compId' AND Designation = 'Telecaller' ;";
        $onedata['UsedTelecallers'] = getusedcount($countque);
        //Admin
        $countque = "SELECT COUNT(FullName) FROM UserDetails WHERE CompanyID = '$compId' AND Designation = 'Admin' ;";
        $onedata['UsedAdmin'] = getusedcount($countque);
        array_push($resultdata,$onedata);
    }



}else{
    $message = 'No data found...';
    goto NoData;
}




GotData:
setresult(true,$message,$resultdata);

NoData:
setresult(false,$message,$resultdata);

?>