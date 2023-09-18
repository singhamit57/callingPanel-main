<?php
include '../../db.php';
include ('../../setresult.php');
$Resultdata = array();
$Postdata = json_decode(file_get_contents('php://input'), true);
if($Postdata != null){
    $CompID = $Postdata['CompId'];
    $CompName = $Postdata['CompName'];
    $LogedUserID = $Postdata['UserId'];
    $LogedUserName = $Postdata['UserName'];
    $Post = $Postdata['Post'];
    $LogedUserCompId = $Postdata['LogedUserCompId'];
    $LogedUsersId = $Postdata['LogedUsersId']; //LogedUsersPost
    $LogedUsersPost = $Postdata['LogedUsersPost'];
    
}else{
    goto NoData;
}

//$Post = "Manager";

if($Post == "Super Admin"){
    $Post_condi = " AND Designation = 'Super Admin' ";
}

if($Post == "Admin"){
    $Post_condi = " AND Designation = 'Admin' ";
}

if($Post == "Manager"){
    $Post_condi = " AND Designation = 'Manager' ";
}

if($Post == "Telecaller"){
    $Post_condi = " AND Designation = 'Telecaller' ";
}

if($LogedUsersPost!='Super Admin'){
$Comp_Que = " and CompanyID = '$LogedUserCompId' ";}

$querry = "SELECT * FROM `UserDetails`  WHERE FullName <>'' $Post_condi $Comp_Que ";
$result =mysqli_query($conn,$querry);
if($conn->affected_rows >=1){
    while($User_row =$result->fetch_assoc()){
        $Onedata = array();
     
        $pretableid = $User_row['Table_id'];
        $UserID = $User_row['UserID'];
        $Onedata['LogedUserId'] = $LogedUserId??'';
        $Onedata['LogedUserName'] = $LogedUserName??'';
        $Onedata['Isnewuser'] = 0;
        $Onedata['PreTableId'] = $pretableid??'';
        $Onedata['CompanyID'] = $CompID??'';
        $Onedata['CompanyName'] = $LogedUserID??'';
      
        $Onedata = array_merge($Onedata,$User_row);
       
        $Per_que = "SELECT * FROM `PermissionDetails` WHERE UserID = '$UserID' limit 1 ;";
        $result2 =mysqli_query($conn,$Per_que);
        $Permi_row =$result2->fetch_assoc();
        $Onedata2 = array_merge($Onedata,$Permi_row);
        
        $Login_que = "SELECT * FROM `LoginDetails` WHERE UserID = '$UserID';";
        $result3 =mysqli_query($conn,$Login_que);
        $Login_row =$result3->fetch_assoc();
       $Onedata2 = array_merge($Onedata2,$Login_row);
       
       //LastLogin
       $Onedata2['LastLogin'] = '';
        
        
        array_push($Resultdata,$Onedata2);
        
    }
    
    goto GotData;
}else{
    goto NoData;
}

GotData:
    setresult(true,"Response Received",$Resultdata);
NoData:
    setresult(false,"No Details Found",$Resultdata);

?>