<?php
include '../db.php';
include ('../setresult.php');
include ('../setupdateStamp.php');

$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompId'];
    $LogedUser = $Postdata['UserID'];
    $Newpw = $Postdata['Newpw'];
    $Oldpw = $Postdata['Oldpw'];
    
    
}


 $querry = "UPDATE LoginDetails SET UserPassword = '$Newpw' WHERE UserID = '$LogedUser' AND CompanyID = '$CompID' AND UserPassword = '$Oldpw' ;";
    $result =mysqli_query($conn,$querry);
    if($conn->affected_rows >=1){
        $message = "Password reset successfully...";
        goto Success;
    }else{
        
        $message = "Please enter valid details";
        goto Failed;
    }


Success:
settableupdate($CompID,'LoginDetails');
setresult(true,$message,$Resultdata);
Failed:
    setresult(false,$message,$Resultdata);

?>