<?php
include'../db.php';
include ('../setresult.php');

// $fullpath = "https://{main_domain}/callcenter/uploadfiles/noimagefound.jpg";
// $vari = "https://{main_domain}/callcenter/uploadfiles/files/615e88e7b8379_agtel21085220211007111248180140.m4a";


$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $ID = $Postdata['id'];
    $Operation = $Postdata['Operation'];
}

$query = "SELECT Fullpath FROM UploadedFiles WHERE FileID = '$ID'; ";

    $result=mysqli_query($conn,$query);
    if ( $conn->affected_rows>=1){
        $row = $result->fetch_assoc();
        $fullpath = $row['Fullpath'];
      
   $fullpath = str_replace("{main_domain}","sinoxfx.com",$fullpath);
   goto success;
      
    }else{
       goto failed;
    }
if($Operation == "launchurl"){
    header("Location: $fullpath");
   exit;
}

failed:
    setresult(false,"$message + $query",$Resultdata);
success:
    setresult(true,$message,array("fullFilepath"=>$fullpath));


?>