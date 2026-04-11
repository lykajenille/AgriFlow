<?php
header("Content-Type: application/json");
include "db_connect.php";

$farm_id      = $_POST['farm_id'] ?? '';
$description  = $_POST['description'] ?? '';
$amount       = $_POST['amount'] ?? '';
$expense_date = $_POST['expense_date'] ?? '';

if ($farm_id == '' || $amount == '') {
    echo json_encode(["status" => "error", "message" => "Missing fields"]);
    exit;
}

$sql = "INSERT INTO expenses (farm_id, description, amount, expense_date)
        VALUES ('$farm_id', '$description', '$amount', '$expense_date')";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["status" => "success", "message" => "Expense added"]);
} else {
    echo json_encode(["status" => "error", "message" => mysqli_error($conn)]);
}
?>