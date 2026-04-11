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

$user_id = $_GET['user_id'] ?? '';

if ($user_id === '') {
    echo json_encode(["success" => false, "message" => "Missing user_id"]);
    exit;
}

$stmt = $conn->prepare("SELECT c.*, f.farm_name 
    FROM crops c 
    JOIN farms f ON c.farm_id = f.id 
    WHERE f.user_id = ? 
    ORDER BY c.created_at DESC");
$stmt->bind_param("i", $user_id);
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
