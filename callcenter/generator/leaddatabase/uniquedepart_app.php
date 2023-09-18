<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompID'];
    $LogedUser = $Postdata['UserID'];
    $LogedUserCompId = $Postdata['LogedUserCompId'];
    
}else{
    // echo "No data found";
    // die();
}
//WHERE CompanyID = '$CompID'

 $querry = "SELECT DISTINCT Departments FROM LeadsDataBase where CompanyID = '$LogedUserCompId'  ;";
    $result =mysqli_query($conn,$querry);
    if($conn->affected_rows >=1){
    while($row =$result->fetch_assoc()){
    $one = $row['Departments'];
    array_push($Resultdata,$one);
    
    }
    $message = "Departmetn list received";
        goto GotData;
    }else{
        $message = "No department found";
        goto NoData;
    }



GotData:
    setresult(true,$message,$Resultdata);
NoData:
    setresult(false,$message,$Resultdata);

?>