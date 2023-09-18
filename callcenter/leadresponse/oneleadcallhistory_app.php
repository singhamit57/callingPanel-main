<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompID'];
    $LogedUser = $Postdata['UserID'];
    $Leadid = $Postdata['TableId'];
    $Mobile = $Postdata['Mobile'];
  
    
}


// WHERE LastPriority <> 'NA'
 $querry = "SELECT * FROM `LeadResponse` WHERE CompanyID = '$CompID' AND LeadID = '$Leadid';";
    $result =mysqli_query($conn,$querry);
    if($conn->affected_rows >=1){
    while($row =$result->fetch_assoc()){
      $LeadID = $row['LeadID'];
      $AddStamp = $row['AddStamp'];
      $IntDate = $row['IntDate'];
      if($IntDate == '0000-00-00'){
          $IntDate = "";
      }else{
          $IntDate = date("d-M-Y", strtotime($IntDate));
      }
      $CallDuration = $row['CallDuration'];
      $showdate = date("d-M-Y", strtotime($AddStamp));
      $showtime = date("G:i:s A", strtotime($AddStamp));
    $one = array();
    $one['department'] = $row['Department'];
    $one['response'] = $row['Response'];
    $one['intdate'] = $row[''];
    $one['priority'] = $row['Priority'];
    $one['leadresult'] = $row['LeadResult'];
    $one['remark'] = $row['Remark'];
    $one['callduration'] = $CallDuration."s";
    $one['updateby'] = $row['Userid'];
    $one['showdate'] = $showdate;
    $one['showtime'] = $showtime;
    $one['showduration'] = $CallDuration."s";
    
    
    array_push($Resultdata,$one);
    
    }
        goto GotData;
    }else{
        goto NoData;
    }




GotData:
    setresult(true,$message,$Resultdata);
NoData:
    setresult(false,$message,$Resultdata);

?>