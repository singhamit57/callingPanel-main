<?php

function settableupdate($Comp,$Table){
    include 'db.php';
    $Stamp = date('Y-m-d G:i:s');
    $update = "UPDATE UpdateHistory SET UpdateStamp = '$Stamp' WHERE Comp_Id = '$Comp' AND TableName = '$Table' ;";
    $result =mysqli_query($conn,$update);
if($conn->affected_rows >=1){
    
}else{
    
    $Alltable = array('CompaniesDetails','DepartmentsDetails','DesignationDetails','FollowUpHistory','LeadResponse','LeadsDataBase','LoginDetails','MailDetails','MessageTemplate','PermissionDetails','ResponsesDetails','SmsDetails','UserDetails');
   

    foreach($Alltable as $value){
        if($value==$Table){
            $Setstamp = $Stamp;
        }else{
           $Setstamp = null; 
        }
        
     $insert = "INSERT INTO UpdateHistory (Comp_Id, TableName, UpdateStamp) VALUE ('$Comp', '$value', '$Setstamp') ;";
     $result =mysqli_query($conn,$insert);  
     
    }
    
    
}
 
}

// settableupdate('Text1234','UserDetails');


?>