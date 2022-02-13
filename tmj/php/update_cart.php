<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$prid = $_POST['prid'];
$quantity = $_POST['quantity'];

$sqlupdate = "UPDATE tbl_cart SET cart_quantity = '$quantity' WHERE user_email = '$email' AND prid = '$prodid'";

if ($conn->query($sqlupdate) === true)
{
    echo "success";
}
else
{
    echo "failed";
}
    
$conn->close();
?>