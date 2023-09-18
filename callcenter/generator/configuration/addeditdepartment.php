<?php
include('../db.php');
include ('../setresult.php');


$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata == null){
    setresult(false,"No Data Recived...","");
}


// $CompanyID = $Postdata['CompId'];
$CompanyID = $Postdata['LogedUserCompId'];
$CompanyName = $Postdata['CompName'];
$Department = ucwords(strtolower($Postdata['Department']));
$ResponsesList = $Postdata['Responses'];
$LastUpdateBy = $Postdata['LogedID'];
$Tableid = $Postdata['Tableid'];
if($ResponsesList == null){
    setresult(false,"Please select responses",'');
}

$Stamp = date("Y-m-d G:i:s");
$Responses = implode(",",$ResponsesList);

if($Tableid != ''){
   $update = "UPDATE DepartmentsDetails SET Department = '$Department' , Responses = '$Responses' WHERE Table_id = '$Tableid';";
   $result1 =mysqli_query($conn,$update);
   if($conn->affected_rows >=1){
    setresult(true,"Departmetn Updated...",'');
}else{
    setresult(false,"Failed to update department...",'');
}
}


$AllowdDepart =0;
$CompDetails_que = "SELECT * FROM `CompaniesDetails` WHERE CompanyID = '$CompanyID';";
$result =mysqli_query($conn,$CompDetails_que);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    $AllowdDepart =$row['MaxDepartment'];
}


$check_count = "SELECT COUNT(Department) as 'Count' FROM DepartmentsDetails WHERE CompanyID = '$CompanyID';";
$result =mysqli_query($conn,$check_count);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    $preDepartCount = $row['Count']+1;
}else{$preDepartCount = 1;}

if($preDepartCount> $AllowdDepart){
    setresult(false,"Department limit over...",'');
}

$check = "SELECT * FROM `DepartmentsDetails` WHERE CompanyID = '$CompanyID' AND Department = '$Department';";
$result1 =mysqli_query($conn,$check);
if($conn->affected_rows >=1){
    setresult(false,"Departmetn Alredy Exist",'');
}



 $Que = "INSERT INTO DepartmentsDetails (CompanyID, CompanyName, Department, Responses, LastUpdateBy, LastUpdateStamp ) VALUE ('$CompanyID', '$CompanyName', '$Department', '$Responses', '$LastUpdateBy', '$Stamp' ) ;";
$result =mysqli_query($conn,$Que);
if($conn->affected_rows >=1){
    setresult(true,"Departmetn Added Successfully",'');
}else{
    setresult(false,"Someting is worng...",'');
}






?>