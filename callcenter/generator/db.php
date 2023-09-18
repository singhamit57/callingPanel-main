<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, HEAD');
header("Access-Control-Allow-Headers: X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

date_default_timezone_set("Asia/Kolkata");

$SuperAdminPrefix = "agsuper";
$AdminPrefix = "agadmin";
$ManagerPrefix = "agmanager";
$CallerPrefix = "agcaller";
$Basewebsite = "https://sinoxfx.com";
$MainAppWebsite = "http://agcaller.com";


$hostname = 'localhost';
$database_user = 'sinoxfx_calling';
$password = 'Sinox@8979_#';
$database_name = 'sinoxfx_CallingCenter';

$conn= new mysqli($hostname,$database_user,$password,$database_name);
if($conn->connect_error){ die("Connection failed: " . $conn->connect_error); }

?>