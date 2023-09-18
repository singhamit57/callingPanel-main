<?php
class OneLoginDetail{
    public $condition;
    function __construct($condition){
        include '../db.php';
        $havedata = false;
        if($condition!=''){
        $query = "SELECT * FROM LoginDetails $condition limit 1;";}
        $result =mysqli_query($conn,$query);
        if($conn->affected_rows>=1){
            $row = $result->fetch_assoc();
            $Table_id = $row['Table_id'];
            $AddStamp = $row['AddStamp'];
            $CompanyID = $row['CompanyID'];
            $CompanyName = $row['CompanyName'];
            $CompanyStatus = $row['CompanyStatus'];
            $UserID = $row['UserID'];
            $UserPassword = $row['UserPassword'];
            $UserStatus = $row['UserStatus'];
            $FullName = $row['FullName'];
            $Designation = $row['Designation'];
            $Departments = $row['Departments'];
            $LastLogin = $row['LastLogin'];
            $LastUpdateBy = $row['LastUpdateBy'];
            $havedata = true;
        }
        
        
        $this->HaveData = $havedata;
        $this->Tableid = $Table_id;
        $this->AddStamp = $AddStamp;
        $this->CompId = $CompanyID;
        $this->CompName = $CompanyName;
        $this->CompStatus = $CompanyStatus;
        $this->UserId = $UserID;
        $this->UserPassword = $UserPassword;
        $this->UserStatus = $UserStatus;
        $this->UserName = $FullName;
        $this->UserDesignation = $Designation;
        $this->UserDepartment = $Departments;
        $this->LastLogin = $LastLogin;
        $this->LastUpdateBy = $LastUpdateBy;
        
    }
}



?>