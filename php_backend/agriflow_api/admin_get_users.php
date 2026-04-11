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

$stmt = $conn->prepare("SELECT u.id, u.username, u.email, u.full_name, u.role, u.created_at,
    (SELECT COUNT(*) FROM farms WHERE user_id = u.id) AS farm_count
    FROM users u ORDER BY u.created_at DESC");
$stmt->execute();
$result = $stmt->get_result();

$users = [];
while ($row = $result->fetch_assoc()) {
    $users[] = $row;
}

echo json_encode(["success" => true, "users" => $users]);
$stmt->close();
$conn->close();
?>
