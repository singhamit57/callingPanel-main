<?php
include('../db.php');
include ('../setresult.php');


$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata == null){
    setresult(false,"No Data Recived...","");


}
$CompanyID = $Postdata['CompId'];
$CompanyName = $Postdata['CompName'];
$Response = ucwords(strtolower($Postdata['Response']));
$NeedIntDate = $Postdata['NeedIntDate'];
$NeedRemark = $Postdata['NeedRemark'];
$SendSms = $Postdata['SendSms'];
$SendMail = $Postdata['SendMail'];
$LastUpdateBy = $Postdata['LogedID'];
$TableId = $Postdata['TableId'];

if($NeedRemark==''){
    goto Faild;
}
$Stamp = date("Y-m-d G:i:s");


if($TableId != ''){
    $Update = "UPDATE ResponsesDetails SET Response = '$Response', NeedIntDate = '$NeedIntDate', NeedRemark = '$NeedRemark', SendSms = '$SendSms', SendMail = '$SendMail', LastUpdateBy = '$LastUpdateBy', LastUpdateStamp = '$Stamp' WHERE Table_id = '$TableId' ;";
    $result1 =mysqli_query($conn,$Update);
if($conn->affected_rows >=1){
    setresult(true,"Response updated",'');
}else{
     setresult(false,"Failed to update response",'');
}
    
}

$AllowdResponse =0;
$CompDetails_que = "SELECT * FROM `CompaniesDetails` WHERE CompanyID = '$CompanyID';";
$result =mysqli_query($conn,$CompDetails_que);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    $AllowdResponse =$row['MaxResponses'];
}


$check_count = "SELECT COUNT(Response) as 'Count' FROM ResponsesDetails WHERE CompanyID = '$CompanyID';";
$result =mysqli_query($conn,$check_count);
if($conn->affected_rows>=1){
    $row =$result->fetch_assoc();
    $preResponseCount = $row['Count']+1;
}else{$preResponseCount = 1;}

if($preResponseCount> $AllowdResponse){
    setresult(false,"Responses limit over...",'');
}


$check = "SELECT * FROM `ResponsesDetails` WHERE CompanyID = '$CompanyID' AND Response = '$Response';";
$result1 =mysqli_query($conn,$check);
if($conn->affected_rows >=1){
    setresult(false,"Response Alredy Exist",'');
}



$Que = "INSERT INTO ResponsesDetails (CompanyID, CompanyName, Response, NeedIntDate, NeedRemark, SendSms, SendMail,LastUpdateBy,LastUpdateStamp) VALUE ('$CompanyID', '$CompanyName', '$Response', '$NeedIntDate', '$NeedRemark', '$SendSms', '$SendMail','$LastUpdateBy','$Stamp');";
$result =mysqli_query($conn,$Que);
if($conn->affected_rows >=1){
    setresult(true,"Response Addes Successfully",'');
}




Faild:
setresult(false,"Someting is worng...",$Alldata);



?>