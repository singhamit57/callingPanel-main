<?php
include '../db.php';
include ('../setresult.php');
include 'dashcharthelper.php';


$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['LogedUserCompId'];
    $LogedUser = $Postdata['UserID'];
    $FrDate = $Postdata['FrDate'];
    $ToDate = $Postdata['ToDate'];
    $LogedUsersPost = $Postdata['LogedUsersPost'];
    
}else{
    // goto NoData;
  //  $CompID = "KUL111";
    //$LogedUser = "SuperAdmin";
}

function getcardcont($Que){
    include '../db.php';
    $Count = 0;
    $result =mysqli_query($conn,$Que);
 if($conn->affected_rows >=1){
     $row =$result->fetch_assoc();
    $Count = $row['Count'];
 }
    return $Count??'0';
}

$LineChartArray = array(
    "maxXcount"=>"6",
    "maxYcount"=>"10",
    "flspots"=>array(
        array("x"=>"0","y"=>"4"),
        array("x"=>"1","y"=>"7"),
        array("x"=>"2","y"=>"8"),
        ),
        
    "xaxislable"=>$weekdays_lable,
        "yaxislable"=>getYlablearray(0),
    );


$BarChartArray = array(
     "xaxislable"=>$weekdays_lable,
        "yaxislable"=>getYlablearray(0),
        "maxY"=>"15",
        "barchartdataList"=>array(
            array("x"=>"0","y1"=>"10","y2"=>"6"),
            array("x"=>"1","y1"=>"3","y2"=>"10"),
            array("x"=>"2","y1"=>"8","y2"=>"8"),
            array("x"=>"3","y1"=>"13","y2"=>"7"),
            array("x"=>"4","y1"=>"0","y2"=>"0"),
            array("x"=>"5","y1"=>"0","y2"=>"0"),
            array("x"=>"6","y1"=>"0","y2"=>"0"),
            
            ),
    
    );
$PieChartArray = array(
    array("titel"=>"va1","value"=>"60","indicator"=>"Ind1"),
    array("titel"=>"va2","value"=>"10","indicator"=>"Ind3"),
    array("titel"=>"va3","value"=>"30","indicator"=>"Ind3"),
    );

$Stamp = date("Y-m-d G:i:s");
$Todaydate = date("Y-m-d");
if($LogedUsersPost!='Super Admin'){
$CompFilter = " and CompanyID = '$CompID' ";}else{
    $CompFilter = "";
}

function querygenerate($day,$que){
    $date =  date('Y-m-d', strtotime("-$day day", strtotime(date('Y-m-d'))));
   $que = str_replace("<Date>",$date,$que);
    return $que ;
}


//barchart Start
$TotalLeadvaluedata = array();
$ConvertLeadvaluedata = array();
$barchartdataList = array();
$DailyCallLinechart = $LineChartArray;

$TotalLeadque = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE FullName <>'' and RespStamp LIKE('<Date>%');";
$ConvertLeadque = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE FullName <>'' and RespStamp LIKE('<Date>%')  AND LastPriority LIKE('%Lead');";
 $Count  = getcardcont(querygenerate(6,$TotalLeadque));
 array_push($TotalLeadvaluedata,$Count);
  $Count  = getcardcont(querygenerate(6,$ConvertLeadque));
 array_push($ConvertLeadvaluedata,$Count);
 
 $Count  = getcardcont(querygenerate(5,$TotalLeadque));
 array_push($TotalLeadvaluedata,$Count);
  $Count  = getcardcont(querygenerate(5,$ConvertLeadque));
 array_push($ConvertLeadvaluedata,$Count);
 
 $Count  = getcardcont(querygenerate(4,$TotalLeadque));
 array_push($TotalLeadvaluedata,$Count);
  $Count  = getcardcont(querygenerate(4,$ConvertLeadque));
 array_push($ConvertLeadvaluedata,$Count);
 
 $Count  = getcardcont(querygenerate(3,$TotalLeadque));
 array_push($TotalLeadvaluedata,$Count);
  $Count  = getcardcont(querygenerate(3,$ConvertLeadque));
 array_push($ConvertLeadvaluedata,$Count);
 
 $Count  = getcardcont(querygenerate(2,$TotalLeadque));
 array_push($TotalLeadvaluedata,$Count);
  $Count  = getcardcont(querygenerate(2,$ConvertLeadque));
 array_push($ConvertLeadvaluedata,$Count);
 
 $Count  = getcardcont(querygenerate(1,$TotalLeadque));
 array_push($TotalLeadvaluedata,$Count);
  $Count  = getcardcont(querygenerate(1,$ConvertLeadque));
 array_push($ConvertLeadvaluedata,$Count);
 
 $Count  = getcardcont(querygenerate(0,$TotalLeadque));
 array_push($TotalLeadvaluedata,$Count);
  $Count  = getcardcont(querygenerate(0,$ConvertLeadque));
 array_push($ConvertLeadvaluedata,$Count);


$maxvalue = max($TotalLeadvaluedata);
$maxvalue = ceil($maxvalue/10)*10;
$i=0;
while($i<7){
    array_push($barchartdataList,array("x"=>"$i","y1"=>"$TotalLeadvaluedata[$i]","y2"=>"$ConvertLeadvaluedata[$i]"));
  $i++;  
}
 
$BarChartArray['barchartdataList']=$barchartdataList;
$BarChartArray['maxY']=$maxvalue;
$BarChartArray['yaxislable'] = getYlablearray($maxvalue) ;
//barchart End


//DailyCallLine Start
$valuedata = array();
$DailyCallLinechart = $LineChartArray;

$que = "SELECT COUNT(LeadID) as 'Count' FROM LeadResponse WHERE AddStamp >= '<Date> 00:00:00' AND AddStamp <= '<Date> 23:59:59' $CompFilter;";
 $Count  = getcardcont(querygenerate(6,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(5,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(4,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(3,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(2,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(1,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(0,$que));
 array_push($valuedata,$Count);
 $maxvalue = max($valuedata);
 $maxvalue = ceil($maxvalue/10)*10;
 $flspots = array();
 $i=0;
 foreach($valuedata as $value){
     if($value >=0 ==false){$value = 0;}
     array_push($flspots,array("x"=>"$i","y"=>"$value"));
     $i++;
 }

 $DailyCallLinechart['maxYcount'] = $maxvalue ;
 $DailyCallLinechart['flspots'] = $flspots ;
 $DailyCallLinechart['yaxislable'] = getYlablearray($maxvalue) ;
 
//DailyCallLine End


//ConvertLeadsLine Start
$valuedata = array();
$ConvertLeadsLinechart = $LineChartArray;

$que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastResponse <> 'NA' AND LastPriority LIKE('%Lead') and RespStamp >= '<Date> 00:00:00' AND RespStamp <= '<Date> 23:59:59' $CompFilter;";

 $Count  = getcardcont(querygenerate(6,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(5,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(4,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(3,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(2,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(1,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(0,$que));
 array_push($valuedata,$Count);
 $maxvalue = max($valuedata);
 $maxvalue = ceil($maxvalue/10)*10;
 $flspots = array();
 $i=0;
 foreach($valuedata as $value){
     if($value >=0 ==false){$value = 0;}
     array_push($flspots,array("x"=>"$i","y"=>"$value"));
     $i++;
 }

 $ConvertLeadsLinechart['maxYcount'] = $maxvalue ;
 $ConvertLeadsLinechart['flspots'] = $flspots ;
 $ConvertLeadsLinechart['yaxislable'] = getYlablearray($maxvalue) ;
 
//ConvertLeadsLine End


//SuccessLeadsLine Start
$valuedata = array();
$SuccessLeadsLinechart = $LineChartArray;

$que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastResponse <> 'NA' AND LastLeadResult = 'Successfull' and RespStamp >= '<Date> 00:00:00' AND RespStamp <= '<Date> 23:59:59' $CompFilter;";

 $Count  = getcardcont(querygenerate(6,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(5,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(4,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(3,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(2,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(1,$que));
 array_push($valuedata,$Count);
 $Count  = getcardcont(querygenerate(0,$que));
 array_push($valuedata,$Count);
 $maxvalue = max($valuedata);
 $maxvalue = ceil($maxvalue/10)*10;
 $flspots = array();
 $i=0;
 foreach($valuedata as $value){
     if($value >=0 ==false){$value = 0;}
     array_push($flspots,array("x"=>"$i","y"=>"$value"));
     $i++;
 }

 $SuccessLeadsLinechart['maxYcount'] = $maxvalue ;
 $SuccessLeadsLinechart['flspots'] = $flspots ;
 $SuccessLeadsLinechart['yaxislable'] = getYlablearray($maxvalue) ;
 
//SuccessLeadsLine End

// UsedRemainPie_array Start
$UsedRemainPie_array = array();
$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastResponse = 'NA' AND IssuedID = 'NA' and CRepeateCount = 1  $CompFilter ; ";
$AvailableLead = getcardcont($Que);

$Que = "SELECT COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE FullName <> '' $CompFilter ";
$totalLead = getcardcont($Que);
$usedLead = $totalLead - $AvailableLead;
$usedLead_per = round($usedLead*100/$totalLead,2)."%";
$AvailableLead_per =  round($AvailableLead*100/$totalLead,2)."%";

$UsedRemainPie_array = array(
    array("titel"=>$usedLead_per,"value"=>"$usedLead","indicator"=>"Used Lead"),
    array("titel"=>$AvailableLead_per,"value"=>"$AvailableLead","indicator"=>"Remain Lead"),
   
    );

// UsedRemainPie_array End

//AllResponsePiec Start
$AllResponsePiec_array= array();
$totalValue = 0;
$Que= "SELECT DISTINCT LastResponse , COUNT(FullName) as 'Count' FROM LeadsDataBase WHERE LastResponse <> 'NA' $CompFilter GROUP BY LastResponse";
$result =mysqli_query($conn,$Que);
$totalrows = $conn->affected_rows;
 if($totalrows >=1){
     
     while($row =$result->fetch_assoc()){
         $onearray = array();
         $response = $row['LastResponse'];
         $value = $row['Count'];
         $totalValue = $totalValue + $value;
         $onearray['titel']="";
         $onearray['value']=$value;
         $onearray['indicator']=$response;
         array_push($AllResponsePiec_array,$onearray);
     }
 }
$i =0;

while ($totalrows > $i) {
 $onearray = $AllResponsePiec_array[$i] ;
 $value = $onearray['value'];
 $onearray['titel'] = round($value*100/$totalValue,2)." %";
$AllResponsePiec_array[$i] = $onearray;
    
$i++;
}


//AllResponsePiec End

$Resultdata['DailyCallLine'] = $DailyCallLinechart;
$Resultdata['ConvertLeadsLine'] = $ConvertLeadsLinechart;
$Resultdata['SuccessLeadsLine'] = $SuccessLeadsLinechart;
$Resultdata['LeadVsConvertLeadBar'] = $BarChartArray;
$Resultdata['UsedRemainPie'] = $UsedRemainPie_array;
$Resultdata['AllResponsePiec'] = $AllResponsePiec_array;


GotData:
    setresult(true,$message,$Resultdata);
NoData:
    setresult(false,$message,$Resultdata);

?>