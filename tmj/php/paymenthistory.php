<?php
include_once ("dbconnect.php");
$email = $_POST['user_email'];

if (isset($email)){
   $sql = "SELECT * FROM tbl_payment WHERE user_email = '$email'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["tbl_payment"] = array();
    while ($row = $result->fetch_assoc())
    {
        $paymentlist = array();
        $paymentlist["order_id"] = $row["ORDER_ID"];
        $paymentlist["bill_id"] = $row["BILL_ID"];
        $paymentlist["total"] = $row["TOTAL"];
        $paymentlist["date"] = $row["DATE"];
        array_push($response["tbl_payment"], $paymentlist);
        echo json_encode($paymentlist);
    }
    echo json_encode($response);
}
}
else
{
    echo "nodata";
}
?>