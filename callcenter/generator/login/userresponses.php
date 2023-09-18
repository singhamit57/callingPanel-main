<?php
include('../db.php');
include ('../setresult.php');
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){

$CompId = $Postdata['LogedUserCompId'];

}else{
// $CompId = $Postdata['Compid'];
// $LogedUserid = $Postdata['LogedUserid'];

}
if($CompId ==""){
    setresult(false,"No Data Recived...","");
}
$Alldata = array();
$Que = "SELECT * FROM `ResponsesDetails` WHERE CompanyID = '$CompId';";
$result =mysqli_query($conn,$Que);
if($conn->affected_rows >=1){
    
    while($row = $result->fetch_assoc()){
        $onedata = array();
        $response = $row['Response'];
        $NeedIntDate = $row['NeedIntDate'];
        $NeedRemark = $row['NeedRemark'];
        $SendSms = $row['SendSms'];
        $SendMail = $row['SendMail'];
        $onedata['Response']=$response;
        $onedata['NeedIntDate']=$NeedIntDate;
        $onedata['NeedRemark']=$NeedRemark;
        $onedata['SendSms']=$SendSms;
        $onedata['SendMail']=$SendMail;
        $onedata['TableId']=$row['Table_id'];;
       
        array_push($Alldata,$onedata);
    }
    setresult(true,"",$Alldata);
    
}




Faild:
setresult(false,"Invalid Userid or Password",$Alldata);



?>