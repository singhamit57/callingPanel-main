<!DOCTYPE html>

<?php
$ID = "TableId,CompId,CompName,Response,MailSubject,MailContent,LastUpdateBy,LastUpdateStamp";


$Value = "Table_id,CompanyID,CompanyName,Response,MailSubject,MailContent,LastUpdateBy,LastUpdateStamp";


$Data = array();
$idarray = explode(",",$ID);
$valueaary = explode(",",$Value);
$length = count($idarray);
$i = 0;
while($i<$length){
    $Data[$idarray[$i]]=$valueaary[$i];
    $i++;
}


    



?>
class OneMailDetails{</br>
    public $id;</br>
    public $Column;</br>
    
    function __construct($id,$Column){</br>
        include '../db.php';</br>
        $havedata = false;</br>
        $query = "SELECT * FROM MailDetails WHERE $Column = '$id' limit 1;";</br>
        $result =mysqli_query($conn,$query);</br>
        if($conn->affected_rows>=1){</br>
            $row = $result->fetch_assoc();</br>
            $havedata = true;</br>
            <?php
            foreach($Data as $key=>$value){
                echo "$".$value." = "."$"."row['".$value."'];</br>";
            }
            ?>
            </br>
            
        }</br></br>
        $this->HaveData = $havedata;</br>
        <?php
            foreach($Data as $key=>$value){
                echo "$"."this"."->"."$key"." = $"."$value".";</br>";
            }
            ?>
        
       
        
    }</br>
}


