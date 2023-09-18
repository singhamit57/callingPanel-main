<?php 

$FileName = $_GET['name'];
if($FileName==""){
    exit;
}

$path = "files/$FileName";

header('Content-Type: application/octet-stream');
header("Content-Transfer-Encoding: Binary"); 
header("Content-disposition: attachment; filename=\"" . basename($path) . "\""); 
readfile($path);

die();

?> 