<?php
    if (!isset($_POST)) {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
        die();
    }

    include_once ("dbconnect.php");

    $email = $_POST['user_email'];
    $prid = $_POST['prid'];
    $userquantity = $_POST['quantity'];
    
    
    $sqlsearch = "SELECT * FROM tbl_cart WHERE user_email = '$email' AND prid= '$prid'";
    
    $result = $conn->query($sqlsearch);
    if ($result->num_rows > 0) {
        $prquantity = null;
        while ($row = $result ->fetch_assoc()){
            $prquantity = $row["cart_quantity"];
        }
        $prquantity = $prquantity + $userquantity;
        $sqlinsert = "UPDATE tbl_cart SET cart_quantity = '$prquantity' WHERE prid = '$prid' AND user_email = '$email'";
    }else{
        $sqlinsert = "INSERT INTO tbl_cart(user_email,prid,cart_quantity) VALUES ('$email','$prid',$userquantity)";
    }
    
    if ($conn->query($sqlinsert) === true){
        $sqlquantity = "SELECT * FROM tbl_cart WHERE user_email = '$email' AND prid= '$prid'";
    
        $resultq = $conn->query($sqlquantity);
        if ($resultq->num_rows > 0) {
            $quantity = 0;
            while ($row = $resultq ->fetch_assoc()){
                $quantity = $row["cart_quantity"] + $quantity;
                $quantity = $quantity;
            }
        }
        $response = array('status' => 'success');
        sendJsonResponse($response);

    }else{
        $response = array('status' => 'failed');
        sendJsonResponse($response);
    }

    function sendJsonResponse($sentArray)
    {
        echo json_encode($sentArray);
    }
    
    ?>