<?php
function setresult($Status, $Msj,$ResultData){
    if(count($ResultData)==0 or $ResultData==""){
        $ResultData["Data"]="false";
    }
    $obj->Status = $Status??false;
    $obj->Msj = $Msj??'';
    if($Status){
        $obj->ResultData = $ResultData;
    }else{
    $obj->ResultData = array($ResultData);}
    
    echo json_encode($obj);
    die();
    
}



function setresultwithtime($Status, $Msj,$time,$ResultData){
    // if(count($ResultData)==0 or $ResultData==""){
    //     $ResultData["Data"]="false";
    // }
    
    $obj->Status = $Status??false;
    $obj->Msj = $Msj??'';
    $obj->Lastupdate = $time??'';
    $obj->ResultData = $ResultData;
    
    // if($Status){
    //     $obj->ResultData = $ResultData;
    // }else{
    // $obj->ResultData = array($ResultData);}
    
    echo json_encode($obj);
    die();
    
}

?>