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
    
}else{
    // goto NoData;
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

$Stamp =  date("Y-m-d G:i:s");
$Todaydate = date("Y-m-d");
$CompFilter = " and CompanyID = '$CompID' ";
$Tilltimestamp = date("Y-m-d G:i:s", strtotime($Stamp)-20);

$Que = "SELECT DISTINCT User_Id , MAX(LastWorkStamp) as 'LastWorkStamp' FROM UserWorkhrs GROUP BY User_Id ";
$result =mysqli_query($conn,$Que);
 if($conn->affected_rows >=1){
     while($row =$result->fetch_assoc()){
         $onedata = array();
         $User_Id = $row['User_Id'];
         $LastWorkStamp = $row['LastWorkStamp'];
         $LastLogin = date_format(date_create($LastWorkStamp),"d-M h:i A");
        if(strtotime($LastWorkStamp)>strtotime($Tilltimestamp)==true){
          
            $isonline = true;
        }else{$isonline = false;}
        //  if($diff )
         
         $onedata['UserID']=$User_Id;
         $onedata['Isonlie']=$isonline;
         $onedata['LastLogin']=$LastLogin;
         
         array_push($Resultdata,$onedata);
     }
    
 }

 

GotData:
    setresult(true,$message,$Resultdata);
NoData:
    setresult(false,$message,$Resultdata);

?>