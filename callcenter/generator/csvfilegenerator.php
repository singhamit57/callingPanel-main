<?php


$header = array('Name',"Website");
$data = array(
    array("Name"=>"Kuldeep1","websit"=>"www.kuldeep.com"),
    array("Name"=>"Shivi","websit"=>"www.shivi.com"),
    );


function generatecsv($FilePath,$header,$data){

$fh = fopen($FilePath,"w");
fputcsv($fh,$header);
foreach($data as $one){
    fputcsv($fh,$one);
}

fclose($fh);

    
}

// $databseheadmap = array(
//     "Table_id"=>"",
//     "AddStamp"=>"",
//     "CompanyID"=>"",
//     "AddedBy"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>"",
//     "Table_id"=>""
//     );


?>