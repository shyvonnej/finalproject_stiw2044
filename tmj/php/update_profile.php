<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
    $name = $_POST['name'];
    $phone = $_POST['phone'];
    $address = $_POST['address'];
    $userid = $_POST['userid'];
    $sqlupdate = "UPDATE tbl_users SET user_phone ='$phone', user_name = '$name', user_address = '$address' WHERE user_id = '$userid'";
    databaseUpdate($sqlupdate);


function databaseUpdate($sql){
    include_once("dbconnect.php"); 
    if ($conn->query($sql) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>