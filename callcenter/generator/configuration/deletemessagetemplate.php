<?php
include '../db.php';
include ('../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['LogedUserCompId'];
    $LogedUsersId = $Postdata['LogedUsersId'];
    $TemplateMessageId = $Postdata['TemplateMessageId'];
}


$querry = "DELETE FROM MessageTemplate WHERE UserID = '$LogedUsersId' AND Table_Id = '$TemplateMessageId' ;";
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