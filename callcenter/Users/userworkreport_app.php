<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['LogedUserCompId'];
    $LogedUser = $Postdata['LogedUsersId'];
    $CallFrom = $Postdata['CallFrom'];
    $CompId_admin = $Postdata['CompId'];
    $UserID_admin = $Postdata['UserID'];
    $FrDate = $Postdata['FrDate'];
    $ToDate = $Postdata['ToDate'];
    
    
}else{
    goto NoData ;
    $CompID = "agcomp23";
    $LogedUser = "agtel210845";
    $FrDate = "2021-09-11";
    $ToDate = "2021-09-18";
    
}

if($CallFrom=='admin'){
    $CompID = $CompId_admin;
    $LogedUser = $UserID_admin;
}

if($FrDate != ''){
$FrDate = date_format(date_create($FrDate),"Y-m-d");
$ToDate = date_format(date_create($ToDate),"Y-m-d");

$dateQue_UserWorkhrs = " and ( WorkDate >= '$FrDate' AND WorkDate <= '$ToDate' ) ";
$DateQue_Leadbase = " AND ( RespStamp >= '$FrDate 00:00:00' AND RespStamp <= '$ToDate 23:59:59') ";

}
$testing = $_GET['test'];

$workduration = 0;
$Departarray = array();
$Responsearray = array();
$priorityarray = array("Hot Lead"=>"0","Medium Lead"=>"0","Cold Lead"=>"0");
$Openclosearray = array("Open Leads"=>"0","Closed Leads"=>"0");
$Scussfailarray = array("Success Lead"=>"0","Failed Lead"=>"0");

$DateCondi = "";

function getresultcount($querry){
    include '../db.php';    
    $result =mysqli_query($conn,$querry);
    if($conn->affected_rows >=1){
        $row =$result->fetch_assoc();
        $count = $row['Count'];
    }
   
    return $count ?? '0';
}


function makelistarray($array){
    $newarray = array();
    foreach($array as $key=>$value){
        array_push($newarray,$key."@@".$value);
    }
    return $newarray;
}
//Gt workduration
$querry = "SELECT * FROM `UserWorkhrs` where User_Id = '$LogedUser' $dateQue_UserWorkhrs ";
$result =mysqli_query($conn,$querry);
    if($conn->affected_rows >=1){
        while($row =$result->fetch_assoc()){
        $duration = $row['WorkDuration'];
        $workduration = $workduration+ $duration;
    }

}

//total working days
$condi = "SELECT COUNT( DISTINCT WorkDate) as 'Count' FROM UserWorkhrs  WHERE  User_Id = '$LogedUser' $dateQue_UserWorkhrs ;";
$totalWorkDaysCount = getresultcount($condi);
$avgworkhrs = ceil(($workduration/$totalWorkDaysCount)/3600)."";



//total half
$condi = "SELECT COUNT( DISTINCT WorkDate) as 'Count' FROM UserWorkhrs  WHERE  AND User_Id = '$LogedUser' AND WorkDuration < '10800' AND WorkDuration > '12600'  ;";
$totalhalfCount = getresultcount($condi);

//short count
$condi = "SELECT COUNT( DISTINCT WorkDate) as 'Count' FROM UserWorkhrs  WHERE  AND User_Id = '$LogedUser' AND WorkDuration < '21600' AND WorkDuration > '18000'  ;";
$totalshortCount = getresultcount($condi);


function getWorkduration($seconds,$format) 
 {
     if($format ==''){
         $format = '%a:%h:%i:%s';
     }
  $dt1 = new DateTime("@0");
  $dt2 = new DateTime("@$seconds");
  return $dt1->diff($dt2)->format($format);
  } 

$DHMworkduration = getWorkduration($workduration,'') ;
$durationarray = explode(":",$DHMworkduration);


$Departments = "SELECT Department as'Showdepartment' FROM DepartmentsDetails WHERE CompanyID = '$CompID' ;";
$result =mysqli_query($conn,$Departments);
 if($conn->affected_rows >=1){
    while($row =$result->fetch_assoc()){

        $Depart = $row['Showdepartment'];   
        $condi = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase  WHERE CompanyID = '$CompID' AND IssuedUser = '$LogedUser' AND Departments = '$Depart' AND LastResponse <> 'NA' $DateQue_Leadbase ";
        $count = getresultcount("$condi");
        $Departarray[$Depart]= $count;
    }
     
 }
 
$Responseque = "SELECT Response as 'Showresponses' FROM ResponsesDetails WHERE CompanyID = '$CompID' ;";
$result =mysqli_query($conn,$Responseque);
 if($conn->affected_rows >=1){
    while($row =$result->fetch_assoc()){
        $resp = $row['Showresponses'];
        $condi = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase  WHERE CompanyID = '$CompID' AND IssuedUser = '$LogedUser' AND LastResponse = '$resp' $DateQue_Leadbase ";
        $count = getresultcount("$condi");
        $Responsearray[$resp]=$count;
    }
     
 }

foreach($priorityarray as $key=>$value){
 $condi = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase  WHERE CompanyID = '$CompID' AND IssuedUser = '$LogedUser' AND LastPriority = '$key' $DateQue_Leadbase ";
$count = getresultcount($condi);
$priorityarray[$key] = $count;
}

//Open Leads
$condi = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase  WHERE CompanyID = '$CompID' AND IssuedUser = '$LogedUser' AND  (LastLeadResult = 'NA' or LastLeadResult = 'Pending') and LastResponse <> 'NA' $DateQue_Leadbase ; ";
$count = getresultcount($condi);
$Openclosearray['Open Leads'] = $count;

//Closed leads

$condi = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase  WHERE CompanyID = '$CompID' AND IssuedUser = '$LogedUser' AND  (LastLeadResult = 'Sucessfull' or LastLeadResult = 'Cancelled') and LastResponse <> 'NA'; $DateQue_Leadbase ";
$count = getresultcount($condi);
$Openclosearray['Closed Leads'] = $count;



//Sucess Lead
$condi = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase  WHERE CompanyID = '$CompID' AND IssuedUser = '$LogedUser' AND  LastLeadResult = 'Sucessfull'  and LastResponse <> 'NA' $DateQue_Leadbase ; ";
$count = getresultcount($condi);
$Scussfailarray['Success Lead'] = $count;

//Failed Lead
$condi = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase  WHERE CompanyID = '$CompID' AND IssuedUser = '$LogedUser' AND  LastLeadResult = 'Cancelled'  and LastResponse <> 'NA'  $DateQue_Leadbase ; ";
$count = getresultcount($condi);
$Scussfailarray['Failed Lead'] = $count;


$condi = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase  WHERE CompanyID = '$CompID' AND IssuedUser = '$LogedUser' AND  LastResponse <> 'NA' $DateQue_Leadbase ";
$TotalResponses = getresultcount($condi);

$condi = "SELECT COUNT(LeadID) as 'Count' FROM LeadResponse WHERE Userid = '$LogedUser';";
$TotalCalls = getresultcount($condi);




// $temp = '{

//   "WorkingDays":"8",
//   "WorkingHrs":"22",
//   "WorkingMin":"36",
//   "AvgWorking":"6",
//   "Absents":"3",
//   "Half":"5",
//   "ShortLogin":"8",
//   "TotalResponses":"252",
//   "DepartResponse":["Properties@@100","Technology@@50","Sales@@80","Information@@80"],
//   "ResponseCateg":["Busy@@100","Switch Off@@50","Meeting@@60","Wrong Number@@70","Not Answer@@30"],
//   "LeadDetail":["Hot Lead@@100","Medium Lead@@40","Cold Lead@@60"],
//   "OpenCloseLead":["Open Leads@@120","Closed Leads@@50"],
//   "SuccessFailLead":["Success Lead@@70","Failed Lead@@20"]
  
// }';


$Resultdata['WorkingDays'] =$durationarray[0];
$Resultdata['WorkingHrs'] =$durationarray[1];
$Resultdata['WorkingMin'] =$durationarray[2];
$Resultdata['AvgWorking'] = $avgworkhrs;
$Resultdata['Absents'] ="0";
$Resultdata['Half'] =$totalhalfCount;
$Resultdata['ShortLogin'] =$totalshortCount;
$Resultdata['TotalResponses'] = $TotalCalls;
$Resultdata['UsedLeads'] = $TotalResponses;
$Resultdata['DepartResponse'] = makelistarray($Departarray);
$Resultdata['ResponseCateg'] = makelistarray($Responsearray);
$Resultdata['LeadDetail'] = makelistarray($priorityarray);
$Resultdata['OpenCloseLead'] = makelistarray($Openclosearray);
$Resultdata['SuccessFailLead'] = makelistarray($Scussfailarray);
 
    







GotData:
    // $message = " $dateQue_UserWorkhrs && $DateQue_Leadbase";
    setresult(true,$message,$Resultdata);
NoData:
    setresult(false,$message,$Resultdata);


?>