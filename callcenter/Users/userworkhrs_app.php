<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompID'];
    $LogedUser = $Postdata['UserID'];
    $workStamp = $Postdata['workDate'];
    $lable = $Postdata['lable'];
    $duration = $Postdata['duration'];
    $LoginKey = $Postdata['LoginKey'];
    $havelocation = $Postdata['havelocation'];
    $latitude = $Postdata['latitude'];
    $longitude = $Postdata['longitude'];
    $accuracy = $Postdata['accuracy'];
    $speed = $Postdata['speed'];
    
    
    
    
}else{
    goto Fail;
}

$workDate = date("Y-m-d", strtotime($workStamp));
$Stamp = date("Y-m-d G:i:s");

$chekkey = "SELECT FullName FROM LoginDetails WHERE UserID = '$LogedUser' AND LoginKey = '$LoginKey';";
$result =mysqli_query($conn,$chekkey);
if($conn->affected_rows ==0){
  goto Fail;
}

///Location
if($havelocation == true and $latitude != '' ){
    $savelocaiton = "INSERT INTO UserLocation ( Comp_Id, User_Id, Addstamp, latitude, longitude, accuracy, speed) VALUE ( '$CompID', '$LogedUser', '$Stamp', '$latitude', '$longitude', '$accuracy', '$speed') ;";
    $result =mysqli_query($conn,$savelocaiton);
}

$WorkDuration = 0;
 $getUration = "SELECT TIMESTAMPDIFF(SECOND, LastWorkStamp, '$workStamp') as 'WorkDuration' FROM UserWorkhrs WHERE User_Id = '$LogedUser' AND WorkDate = '$workDate' ";
$result =mysqli_query($conn,$Update);
if($conn->affected_rows >=1){
    $row = $result->fetch_assoc();
    $WorkDuration = $row['WorkDuration'];
}

if($WorkDuration <=30 and $WorkDuration >=$duration){
    $duration = $WorkDuration;
}

$Update = "UPDATE UserWorkhrs SET WorkDuration = WorkDuration + '$duration', LastWorkStamp = '$workStamp' WHERE Comp_Id = '$CompID' AND User_Id = '$LogedUser' AND WorkDate = '$workDate' AND lable = '$lable';";
$result =mysqli_query($conn,$Update);
if($conn->affected_rows >=1){

goto Success;
}else{
$querry = "INSERT INTO UserWorkhrs ( Comp_Id, User_Id, WorkDate, lable, WorkDuration, LastWorkStamp ) VALUE ( '$CompID', '$LogedUser', '$workDate', '$lable', '$duration', '$workStamp' ); ";
$result =mysqli_query($conn,$querry);
if($conn->affected_rows >=1){

goto Success;
}

}



 
        
    

Fail:
    $Obj->Status = false;
    $Obj->Islogedin = false;
   echo json_encode($Obj);
    die();


Success:
    $Obj->Status = true;
    $Obj->Islogedin = true;
    $Obj->Date = $workDate;
   echo json_encode($Obj);
    die();
    


?>