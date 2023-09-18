<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompId'];
    $LogedUser = $Postdata['UserID'];
}


// WHERE LastPriority <> 'NA'
 $querry = "SELECT * FROM `MessageTemplate`";
    $result =mysqli_query($conn,$querry);
    if($conn->affected_rows >=1){
    while($row =$result->fetch_assoc()){
    $onedata = array();
    $stamp = $row['Addstamp'];
    $onedata['Table_Id'] = $row['Table_Id'];
    $onedata['ShowDate'] = date("d-M-Y", strtotime($stamp));
    $onedata['ShowTime'] = date("G:i:s A", strtotime($stamp));
    $onedata['Lable'] = $row['Lable'];
    $onedata['Content'] = $row['Content'];
    
    array_push($Resultdata,$onedata);
    
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