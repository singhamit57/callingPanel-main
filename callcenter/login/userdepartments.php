<?php
include('../db.php');
include ('../setresult.php');
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata == null){
$CompId = $_GET['Compid'];
$LogedUserid = $_GET['LogedUserid'];

}else{
$CompId = $Postdata['LogedUserCompId'];
$LogedUserid = $Postdata['LogedUsersId'];

}
// $CompId= "KUL111";
if($CompId ==""){
    setresult(false,"No Data Recived...","");
}
$Alldata = array();
$Que = "SELECT * FROM `DepartmentsDetails` WHERE CompanyID = '$CompId';";
$result =mysqli_query($conn,$Que);
if($conn->affected_rows >=1){
    
    while($row = $result->fetch_assoc()){
        $Str = $row['Department']."@@".$row['Responses']."@@".$row['Table_id']."@@".$CompId;
       $Str= str_replace(",","#",$Str);
        array_push($Alldata,$Str);
    }
    setresult(true,"Permission Received",$Alldata);
    
}




Faild:
setresult(false,"Invalid Userid or Password",$Alldata);



?>