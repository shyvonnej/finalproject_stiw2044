<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['user_email'];

$sql = "SELECT * FROM tbl_cart WHERE user_email = '$email'";    
$quan = 0;
 
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    while ($row = $result->fetch_assoc())
    {
      $quan = $quan + $row["cart_quantity"];
    }
    echo  $quan;
}
else
{
    echo "nodata";
}
?>