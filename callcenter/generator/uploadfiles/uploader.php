<?php
include '../db.php';
include ('../setresult.php');

$message = "No data received";
$Resultdata = array();
$folder = "files/";
$base_name = basename($_FILES['file']['name']);
$Unique = str_replace(".","",uniqid());
$base_name = $Unique."_".$base_name;
$Operation = $_POST['Operation'];
$Category = $_POST['Category'];
$FileID = $_POST['UploadDocID'];
if($Operation ==null){
    goto Failed;
}
$target_file = $folder.$base_name ;

$namearray = explode(".",$base_name);

$ext = end($namearray);
$Nameonly = str_replace(".$ext","",$base_name);
$TimeStamp = date("Y-m-d G:i:s");
$Fullpath  = "https://{main_domain}/callcenter/uploadfiles/$target_file";
if(!$_FILES['files']['error'])
{
    if(move_uploaded_file($_FILES['file']['tmp_name'],$target_file)){
        
        $query = "INSERT INTO UploadedFiles (Category, AddStamp,ImgNameOnly,ImgExten,Fullpath,FileID) VALUE ('$Category','$TimeStamp','$Nameonly','$ext','$Fullpath','$FileID') ;";
        $result=mysqli_query($conn,$query);
        if ( $conn->affected_rows>=1){
            $last_id = $conn->insert_id;
            $message = "File uploaded successfully";
            goto Success;
        }
        
    }else{
        $message = "Failed to upload file";
            goto Failed;
    }
}else{
    $message = "Failed to upload file";
            goto Failed;
}


Failed:
   setresult(false,$message,$Resultdata);
Success:
   setresult(true,$message,$Resultdata);
    

?>

