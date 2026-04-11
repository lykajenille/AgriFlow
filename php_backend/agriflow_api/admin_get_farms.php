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

$stmt = $conn->prepare("SELECT f.*, u.full_name AS owner_name, u.username AS owner_username,
    (SELECT COUNT(*) FROM crops WHERE farm_id = f.id) AS crop_count
    FROM farms f
    JOIN users u ON f.user_id = u.id
    ORDER BY f.created_at DESC");
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
