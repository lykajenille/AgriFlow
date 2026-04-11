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

$stmt = $conn->prepare("SELECT f.*, 
    (SELECT COUNT(*) FROM crops WHERE farm_id = f.id) AS crop_count
    FROM farms f WHERE f.user_id = ? ORDER BY f.created_at DESC");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$farms = [];
while ($row = $result->fetch_assoc()) {
    $farms[] = $row;
}

echo json_encode(["success" => true, "farms" => $farms]);
$stmt->close();
$conn->close();
?>
