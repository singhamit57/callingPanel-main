<?php
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompId'];
    $Code = $Postdata['Code'];
}

function gettableupdate($Comp){
    include 'db.php';
    $Stamp = date('Y-m-d G:i:s');
    $update = "SELECT * FROM `UpdateHistory` WHERE Comp_Id = '$Comp' ;";
    $result =mysqli_query($conn,$update);
if($conn->affected_rows >=1){
    $resultdata = array();
    while($row =$result->fetch_assoc()){
        
        $tableName = $row['TableName'];
        $updatestamp = $row['UpdateStamp'];
        if($updatestamp == '0000-00-00 00:00:00'){
            $updatestamp = "0";
        }
       $updatestamp= str_replace("-","",$updatestamp);
       $updatestamp= str_replace(" ","",$updatestamp);
       $updatestamp= str_replace(":","",$updatestamp);
        $resultdata[$tableName] = $updatestamp;
       
    }
    $obj->Status=true;
    $obj->ResultData=$resultdata;
    echo json_encode($obj);
   
}
 
}
if($CompID != null){
    gettableupdate($CompID);
}




?>