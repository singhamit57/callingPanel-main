<?php

function makesecure($value){
    include('/db.php');
    if($value !=''){
    $value = real_escape_string($conn,$value);}
    return $value;
}



?>