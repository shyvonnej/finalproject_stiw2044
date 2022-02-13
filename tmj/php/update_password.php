<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

if (isset($_POST['password'])) {
    $password = sha1($_POST['password']);
    $useremail = $_POST['useremail'];
    $sqlupdate = "UPDATE tbl_users SET user_password ='$password' WHERE user_email = '$useremail'";
    databaseUpdate($sqlupdate);
    die();
}

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