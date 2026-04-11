<?php
header("Content-Type: application/json");
include "db_connect.php";

$farm_id          = $_POST['farm_id'] ?? '';
$crop_name        = $_POST['crop_name'] ?? '';
$planting_date    = $_POST['planting_date'] ?? '';
$expected_harvest = $_POST['expected_harvest'] ?? '';
$status           = $_POST['status'] ?? '';

if ($farm_id == '' || $crop_name == '') {
    echo json_encode(["status" => "error", "message" => "Missing fields"]);
    exit;
}

$sql = "INSERT INTO crops (farm_id, crop_name, planting_date, expected_harvest, status)
        VALUES ('$farm_id', '$crop_name', '$planting_date', '$expected_harvest', '$status')";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["status" => "success", "message" => "Crop added"]);
} else {
    echo json_encode(["status" => "error", "message" => mysqli_error($conn)]);
}
?>