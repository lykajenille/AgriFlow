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

// Per-farm report: farm name, owner, total crops, total expenses, total harvests
$sql = "SELECT f.id, f.farm_name, u.full_name AS owner_name,
    (SELECT COUNT(*) FROM crops WHERE farm_id = f.id) AS crop_count,
    (SELECT COALESCE(SUM(amount), 0) FROM expenses WHERE farm_id = f.id) AS total_expenses,
    (SELECT COALESCE(SUM(h.quantity), 0) FROM harvests h JOIN crops c ON h.crop_id = c.id WHERE c.farm_id = f.id) AS total_harvests
    FROM farms f
    JOIN users u ON f.user_id = u.id
    ORDER BY f.farm_name";

$result = $conn->query($sql);
$reports = [];
while ($row = $result->fetch_assoc()) {
    $reports[] = $row;
}

// Summary totals
$res = $conn->query("SELECT COALESCE(SUM(amount), 0) as total FROM expenses");
$totalExpenses = $res->fetch_assoc()['total'];

$res = $conn->query("SELECT COALESCE(SUM(quantity), 0) as total FROM harvests");
$totalHarvests = $res->fetch_assoc()['total'];

echo json_encode([
    "success" => true,
    "reports" => $reports,
    "summary" => [
        "total_expenses" => (float)$totalExpenses,
        "total_harvests" => (float)$totalHarvests,
    ]
]);

$conn->close();
?>
