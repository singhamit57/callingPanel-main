<?php

function getdayname($day){
  $daynaem =  date('D', strtotime("-$day day", strtotime(date('Y-m-d'))));
  return $daynaem;
}

$weekdays_lable = array(
    array("gapCount"=>"0","lable"=>getdayname(6)),
    array("gapCount"=>"1","lable"=>getdayname(5)),
    array("gapCount"=>"2","lable"=>getdayname(4)),
    array("gapCount"=>"3","lable"=>getdayname(3)),
    array("gapCount"=>"4","lable"=>getdayname(2)),
    array("gapCount"=>"5","lable"=>getdayname(1)),
    array("gapCount"=>"6","lable"=>getdayname(0)),
);


function getYlablearray($Maxvalue){

  if($Maxvalue==0 or $Maxvalue == null){
      $Maxvalue = 10;
  }
  $Ylable_array = array(); 
 array_push($Ylable_array , array("gapCount"=>"0","lable"=>"0"));
  $Suffix = "K";
  $gap = ceil($Maxvalue/10);
  $i = $gap;
 
 
  while(($Maxvalue+$gap) > $i){
      array_push($Ylable_array , array("gapCount"=>"$i","lable"=>"$i"));
      $i = $i +$gap ;
  }

// $Ylable_array = array(
//   array("gapCount"=>"0","lable"=>""),
//   array("gapCount"=>"1","lable"=>"1 $Suffix"),
//   array("gapCount"=>"2","lable"=>"2 $Suffix"),
//   array("gapCount"=>"3","lable"=>"3 $Suffix"),
//   array("gapCount"=>"4","lable"=>"4 $Suffix"),
//   array("gapCount"=>"5","lable"=>"5 $Suffix"),
//   array("gapCount"=>"6","lable"=>"6 $Suffix"),
//   array("gapCount"=>"7","lable"=>"7 $Suffix"),
//   array("gapCount"=>"8","lable"=>"8 $Suffix"),
//   array("gapCount"=>"9","lable"=>"9 $Suffix"),
//   array("gapCount"=>"10","lable"=>"10 $Suffix"),
// );

return $Ylable_array;


}


?>