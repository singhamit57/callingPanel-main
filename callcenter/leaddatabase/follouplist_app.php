<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompID'];
    $LogedUser = $Postdata['UserID'];
    
    $FrDate = $Postdata['FrDate'];
    $ToDate = $Postdata['ToDate'];
    
}


// WHERE LastPriority <> 'NA'
 $querry = "SELECT * FROM `LeadsDataBase` WHERE LastPriority LIKE('%lead') and IssuedUser = '$LogedUser' ";
    $result =mysqli_query($conn,$querry);
    if($conn->affected_rows >=1){
    while($row =$result->fetch_assoc()){
    $RespStamp = $row['LastIntDate'];
    $row['LastIntDate'] = date("d-M-y", strtotime($RespStamp));
    array_push($Resultdata,$row);
    
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