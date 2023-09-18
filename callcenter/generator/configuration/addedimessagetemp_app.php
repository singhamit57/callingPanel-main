<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompId'];
    $LogedUser = $Postdata['UserID'];
    $haveoldmsj = $Postdata['Haveoldmsj'];
    $Table_Id = $Postdata['Table_Id'];
    $Lable = $Postdata['Lable'];
    $message = $Postdata['message'];
}
$Lable = ucwords(strtolower($Lable));
$stamp =  date("Y-m-d G:i:s");

if($Lable ==''){
    $message = "Please make unique label";
    goto Failed;
}

if($haveoldmsj==true){
    $querry = "UPDATE MessageTemplate SET Lable = '$Lable', Content = '$message' WHERE Table_Id = '$Table_Id';";
}else{
 $querry = "INSERT INTO MessageTemplate ( Addstamp, CompID, UserID, Lable, Content) VALUE ( '$stamp', '$CompID', '$LogedUser', '$Lable', '$message') ;";
}
    $result =mysqli_query($conn,$querry);
    if($conn->affected_rows >=1){
    
        goto Success;
    }else{
        goto Failed;
    }


Success:
    setresult(true,$message,$Resultdata);
Failed:
    setresult(false,$message,$Resultdata);

?>