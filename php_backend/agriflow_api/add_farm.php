<?php
header("Content-Type: application/json");
include "db_connect.php";

$user_id   = $_POST['user_id'] ?? '';
$farm_name = $_POST['farm_name'] ?? '';
$location  = $_POST['location'] ?? '';
$size      = $_POST['size'] ?? '';

if ($user_id == '' || $farm_name == '') {
    echo json_encode(["status" => "error", "message" => "Missing fields"]);
    exit;
}

$sql = "INSERT INTO farms (user_id, farm_name, location, size)
        VALUES ('$user_id', '$farm_name', '$location', '$size')";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["status" => "success", "message" => "Farm added"]);
} else {
    echo json_encode(["status" => "error", "message" => mysqli_error($conn)]);
}
?>