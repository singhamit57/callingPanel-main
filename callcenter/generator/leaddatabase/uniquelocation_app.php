<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompID'];
    $LogedUser = $Postdata['UserID'];
    $LogedUserCompId = $Postdata['LogedUserCompId'];
    
}
//WHERE CompanyID = '$CompID'

$querry = "SELECT DISTINCT concat(Country,':',State,':',City) as 'LocaionData' FROM LeadsDataBase where  CompanyID = '$LogedUserCompId'  limit 100;";
    $result =mysqli_query($conn,$querry);
    if($conn->affected_rows >=1){
    while($row =$result->fetch_assoc()){
    $one = array();
    $onedata = $row['LocaionData'];
    $ondedataarray = explode(":",$onedata);
    $one['Country'] = $ondedataarray[0];
    $one['State'] = $ondedataarray[1];
    $one['City'] = $ondedataarray[2];
    array_push($Resultdata,$one);
    
    }
    $message = "Location list received";
        goto GotData;
    }else{
        $message = "No Location found";
        goto NoData;
    }



GotData:
    setresult(true,$message,$Resultdata);
NoData:
    setresult(false,$message,$Resultdata);

?>