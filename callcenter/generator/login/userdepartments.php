<?php
include('../db.php');
include ('../setresult.php');
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){

$CompId = $Postdata['LogedUserCompId'];
$LogedUserid = $Postdata['LogedUserid'];
$mode = $Postdata['mode'];

}else{
$CompId = "agcomp25";
// $LogedUserid = $Postdata['LogedUsersId'];

}

if($CompId ==""){
    setresult(false,"No Data Recived...","");
}
$AllResponse = array();

$resp = "SELECT * FROM `ResponsesDetails` WHERE CompanyID = '$CompId'";
$result =mysqli_query($conn,$resp);
if($conn->affected_rows >=1){
    
    while($row = $result->fetch_assoc()){
       
        array_push($AllResponse,$row['Response']);
    }
}



$Alldata = array();
$Que = "SELECT * FROM `DepartmentsDetails` WHERE CompanyID = '$CompId';";
$result =mysqli_query($conn,$Que);
if($conn->affected_rows >=1){
   
    
    while($row = $result->fetch_assoc()){
        $response = $row['Responses'];
        $Department = $row['Department'];
        $response_array = explode(",",$response);
        $newresponse = array();
        foreach($response_array as $value){
            if(in_array($value, $AllResponse)){
                 array_push($newresponse,$value);
            }
        }
        
        $response = implode(",",$newresponse);
        $update = "UPDATE DepartmentsDetails SET Responses = '$response' WHERE CompanyID = '$CompId' AND Department = '$Department'; ";
        
        mysqli_query($conn,$update);
        
        $Str = $Department."@@".$response."@@".$row['Table_id']."@@".$CompId;
       $Str= str_replace(",","#",$Str);
        array_push($Alldata,$Str);
    }
    setresult(true, "" ,$Alldata);
    
}




Faild:
setresult(false,"Invalid Userid or Password",$Alldata);



?>