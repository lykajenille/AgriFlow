<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

include "db_connect.php";

$stmt = $conn->prepare("SELECT c.*, f.farm_name, u.full_name AS owner_name
    FROM crops c
    JOIN farms f ON c.farm_id = f.id
    JOIN users u ON f.user_id = u.id
    ORDER BY c.created_at DESC");
$stmt->execute();
$result = $stmt->get_result();

$crops = [];
while ($row = $result->fetch_assoc()) {
    $crops[] = $row;
}

echo json_encode(["success" => true, "crops" => $crops]);
$stmt->close();
$conn->close();
?>
