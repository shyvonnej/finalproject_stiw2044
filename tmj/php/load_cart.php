<?php
include_once ("dbconnect.php");
$email = $_POST['user_email'];

if (isset($email)){
    $sql = "SELECT * TBL_PRODUCTS.PRID, TBL_PRODUCTS.PRNAME, TBL_PRODUCTS.PRPRICE, TBL_PRODUCTS.PRQTY FROM TBL_PRODUCTS AND TBL_CART.CART_QUANTITY FROM TBL_CART WHERE TBL_CART.PRID = TBL_PRODUCTS.PRID WHERE TBL_CARAT.USER_EMAIL = '$email'";

$result = $conn->query($sql);

if ($result-> num_rows > 0) {
    $res["tbl_cart"] = array();
    while ($row = $result->fetch_assoc()){
        $cartlist = array();
        $cartlist["id"] = $row["prid"];
        $cartlist["name"] = $row["prname"];
        $cartlist["price"] = $row["prprice"];
        $cartlist["quantity"] = $row["prqty"];
        $cartlist["cartquantity"] = $row["cart_quantity"];
        $cartlist["yourprice"] = round(doubleval($row["prprice"])*(doubleval($row["cart_quantity"])),2)."";
        array_push($res["tbl_cart"], $cartlist);
    }
    
    $response = array('status' => 'success', 'data' => $res);
    echo json_encode($response);
}
    }else{
        echo "Cart Empty";
    }
?>