<?php
include '../db.php';
include ('../setresult.php');

$Resultdata = array();


$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){

$SearchInput = $Postdata['SearchInput'];
$Isserchingbyinput = $Postdata['Isserchingbyinput'];
$CompId = $Postdata['CompId'];
$UserId = $Postdata['UserId'];
$LastUpdate = $Postdata['LastUpdate'];
$FromDate = $Postdata['FromDate'];
$ToDate = $Postdata['ToDate'];
$Isfilter = $Postdata['Isfilter']; 
$FilterName = $Postdata['FilterName'];
$LogedUserCompId = $Postdata['LogedUserCompId'];
$LogedUsersPost = $Postdata['LogedUsersPost'];
$Operation = $Postdata['operation'];
$AllSelectForDelete = $Postdata['AllSelectForDelete'];
$SelectedLeadList = $Postdata['SelectedLeadList'];

}else{
    goto NoData;
  $CompId = "agcomp23";
  $UserId = "12345";
   $LogedUserCompId = "agcomp23";
   $PageNumber = $_GET['page'];
   $Operation = 'download';

}
//  $CompId = "agcomp23";
//   $LogedUserCompId = "agcomp23";
//   $Isserchingbyinput = true;
//   $SearchInput = 'sanya';

$Stamp = date("Y-m-d G:i:s");
$Todaydate = date("Y-m-d");


if($LogedUsersPost=='Super Admin' or $LogedUserCompId =='agc202101' ){
    $CompFilter = "";
}else{
    $CompFilter = " and CompanyID = '$LogedUserCompId' "; 
}



if($Isfilter == true){
    
    //Total Leads
    if($FilterName == 'Total Leads'){
        $filterque = "SELECT * FROM `LeadsDataBase` where  FullName <> '' $CompFilter ";
    }
    
    //Availbale leads
    if($FilterName == 'Available Leads'){
        $filterque = "SELECT * FROM LeadsDataBase WHERE IssuedID = 'NA' AND CRepeateCount = 1  $CompFilter; ";
    }
    
    //Dublicate Leads
    if($FilterName == 'Duplicate Leads'){
        $filterque = "SELECT * FROM LeadsDataBase  WHERE CRepeateCount > 1 $CompFilter ; ";
    }
    
    //Used Leads
    if($FilterName == 'Used Leads'){
        $filterque = "SELECT * FROM LeadsDataBase  WHERE IssuedID <> 'NA'  and LastResponse <> 'NA' $CompFilter;";
    }
    
    //Hot cold medium lead
    if($FilterName == 'Hot Leads' or $FilterName == 'Cold Leads' or $FilterName == 'Medium Leads' ){
        $leadtype = str_replace('Leads','Lead',$FilterName);
    $filterque = "SELECT * FROM `LeadsDataBase` WHERE LastPriority = '$leadtype' $CompFilter ;"; }
    
    //Open Leads
    if($FilterName == 'Open Leads'){
        $filterque = "SELECT * FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastLeadResult = 'Pending' $CompFilter;";
    }
    
    //Closed Leads
    if($FilterName == 'Closed Leads'){
        $filterque = "SELECT * FROM LeadsDataBase  WHERE LastResponse <>'NA' AND (LastLeadResult = 'Successfull' or LastLeadResult = 'Cancelled')  $CompFilter;";
    }
    
    //Success Leads
    if($FilterName == 'Success Leads'){
        $filterque = "SELECT * FROM LeadsDataBase  WHERE LastResponse <>'NA' AND LastLeadResult = 'Successfull' $CompFilter;";
    }
    
    //Failed Leads
    if($FilterName == 'Failed Leads'){
        $filterque = "SELECT * FROM LeadsDataBase  WHERE LastResponse <>'NA' AND LastLeadResult = 'Cancelled' $CompFilter ; ";
    }
    
    //Total Followups
    if($FilterName == 'Total Followups'){
        $filterque = "SELECT * FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastIntDate > '2021-01-01'  AND LastLeadResult = 'Pending' $CompFilter ;";
    }
    
    //Today's Followups
    if($FilterName == "Today's Followups"){
        $filterque = "SELECT * FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastIntDate = '$Todaydate'  AND LastLeadResult = 'Pending' $CompFilter ; ";
    }
    
    //Pending Followups
    if($FilterName == "Pending Followups"){
        $filterque = "SELECT * FROM LeadsDataBase WHERE LastResponse <>'NA' AND LastIntDate < '$Todaydate'  AND LastLeadResult = 'Pending' $CompFilter ;";
    }
   
}

if($FromDate != ''){
    $FromDate = date("Y-m-d 00:00:00", strtotime($FromDate));
    $ToDate = date("Y-m-d 23:59:59", strtotime($ToDate));
    $dateQue = " AND ( AddStamp >= '$FromDate' AND AddStamp <= '$ToDate') ";
}

$deletecount = 0;
if($AllSelectForDelete == false && count($SelectedLeadList)>=1){
   
    foreach($SelectedLeadList as $leadid){
        $querry = "DELETE FROM LeadsDataBase WHERE Table_id = '$leadid' limit 1;";
        $result =mysqli_query($conn,$querry);
        if($conn->affected_rows>=1){
            $deletecount ++;
        }
    }

    if($deletecount == count($SelectedLeadList)){
        goto GotData;
    }else{
        goto NoData;
    }

}


if($Isfilter == true ){
  $querry = $filterque;  
}else{
    $querry = "SELECT * FROM `LeadsDataBase` WHERE FullName <> '' $dateQue $CompFilter ";}


$result =mysqli_query($conn,$querry);
$GotDataCount = $conn->affected_rows??0;

$newfilterdata = array();


function filteralldata($onearray){
    
    global $SearchInput;
    global $newfilterdata;
    foreach($onearray as $key=>$value){
        if(strpos(strtolower($value), $SearchInput)!== false){
            array_push($newfilterdata,$onearray);
            break;
        }
    }
    
}

if($GotDataCount >=1){
    $TotalData=mysqli_fetch_all($result, MYSQLI_ASSOC);
    
    
    if($Isserchingbyinput==true){
        if(strlen($SearchInput) >=2){
            array_map("filteralldata",$TotalData);
            $TotalData = $newfilterdata;
            $GotDataCount = count($TotalData);
            
        }
        
    }
    
    foreach($TotalData as $onedata){
        $leadid = $onedata['Table_id'];        
        $querry = "DELETE FROM LeadsDataBase WHERE Table_id = '$leadid' limit 1;";
        $result =mysqli_query($conn,$querry);
        if($conn->affected_rows>=1){
            $deletecount ++;
        }

        if($deletecount == count($TotalData)){
            
            goto GotData;
        }else{
           
            goto NoData;
        }


    }
    
    
    goto GotData;
}else{
   goto NoData;  
}

GotData:
$ResulstMessage = "$deletecount Leads deleted successfully !";
    setresultwithtime(true,$ResulstMessage,"","");
NoData:
$ResulstMessage = "Failed to delete leads !";
    setresultwithtime(false,$ResulstMessage,"","");


?>