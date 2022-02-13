<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['useremail'];
$prid = $_POST['prid'];


if (isset($_POST['pr_id'])){
    $sqldelete = "DELETE FROM tbl_cart WHERE user_email = '$email' AND prid='$prid'";
}else{
    $sqldelete = "DELETE FROM tbl_cart WHERE user_email = '$email'";
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>