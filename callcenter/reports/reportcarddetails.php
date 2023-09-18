<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['LogedUserCompId'];
    $LogedUser = $Postdata['UserID'];
    $FrDate = $Postdata['FrDate'];
    $ToDate = $Postdata['ToDate'];
    $LogedUsersPost = $Postdata['LogedUsersPost'];
    
}else{
    goto NoData;
  //  $CompID = "KUL111";
    //$LogedUser = "SuperAdmin";
}

function getcardcont($Que){
    include '../db.php';
    $Count = 0;
    $result =mysqli_query($conn,$Que);
 if($conn->affected_rows >=1){
     $row =$result->fetch_assoc();
    $Count = $row['Count'];
 }
    return $Count;
}

$Stamp = date("Y-m-d G:i:s");
$Todaydate = date("Y-m-d");
if($LogedUsersPost!='Super Admin'){
$CompFilter = " and CompanyID = '$CompID' ";}

$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE FullName <>'' $CompFilter;";
$Resultdata['TotalLeads'] = getcardcont($Que);

 
$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE IssuedID = 'NA' AND CRepeateCount = 1 $CompFilter ;";
$Resultdata['AvailableLeads'] = getcardcont($Que);

$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE CRepeateCount > 1 $CompFilter ;";
$Resultdata['DublicatieLeads'] = getcardcont($Que);

$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE IssuedID <> 'NA'  and LastResponse <> 'NA' $CompFilter ;";
$Resultdata['UsedLeads'] = getcardcont($Que);


$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastPriority= 'Hot Lead' $CompFilter;";
$Resultdata['HotLeads'] = getcardcont($Que);

$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastPriority = 'Medium Lead' $CompFilter;";
$Resultdata['MediumLeads'] = getcardcont($Que);

$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastPriority = 'Cold Lead' $CompFilter ;";
$Resultdata['ColdLeads'] = getcardcont($Que);

//Open Leads
$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastLeadResult = 'Pending' $CompFilter ;";
$Resultdata['OpenLeads'] = getcardcont($Que);

//Closed Leads
$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastResponse <>'NA' AND (LastLeadResult = 'Successfull' or LastLeadResult = 'Cancelled') $CompFilter ;";
$Resultdata['ClosedLeads'] = getcardcont($Que);

//sucess leads
$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastLeadResult = 'Successfull' $CompFilter ;";
$Resultdata['SuccessLeads'] = getcardcont($Que);

//failed leads
$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastLeadResult = 'Cancelled' $CompFilter ;";
$Resultdata['FailedLeads'] = getcardcont($Que);

//total followups
$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastIntDate > '2021-01-01'  AND LastLeadResult = 'Pending' $CompFilter ;";
$Resultdata['TotalFollowups'] = getcardcont($Que);

//pending followups
$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastIntDate < '$Todaydate'  AND LastLeadResult = 'Pending' $CompFilter ;";
$Resultdata['PendingFollowups'] = getcardcont($Que);

//today followups
$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastIntDate = '$Todaydate'  AND LastLeadResult = 'Pending' $CompFilter ;";
$Resultdata['TodayFollowups'] = getcardcont($Que);

//call history
$Que = "SELECT COUNT(LeadID) as 'Count' FROM LeadResponse $CompFilter ;";
$Resultdata['CallHistory'] = getcardcont($Que);


GotData:
    setresult(true,$message,$Resultdata);
NoData:
    setresult(false,$message,$Resultdata);

?>