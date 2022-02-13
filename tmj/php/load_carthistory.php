<?php
error_reporting(0);
include_once ("dbconnect.php");
$orderid = $_POST['orderid'];

$sql = "SELECT tbl_products.prid, tbl_products.prname, tbl_products.prprice, tbl_products.prqty, tbl_carthistory.cart_quantity FROM tbl_products INNER JOIN tbl_carthistory ON tbl_carthistory.prid = tbl_product.prid WHERE tbl_carthistory.order_id = '$orderid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["tbl_carthistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["prid"] = $row["prid"];
        $cartlist["prname"] = $row["prname"];
        $cartlist["prprice"] = $row["prprice"];
        $cartlist["cart_quantity"] = $row["cart_quantity"];
        array_push($response["tbl_carthistory"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>