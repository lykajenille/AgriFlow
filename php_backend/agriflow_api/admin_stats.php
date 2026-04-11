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

// Total farmers
$res = $conn->query("SELECT COUNT(*) as total FROM users WHERE role = 'farmer'");
$totalFarmers = $res->fetch_assoc()['total'];

// Total farms
$res = $conn->query("SELECT COUNT(*) as total FROM farms");
$totalFarms = $res->fetch_assoc()['total'];

// Total crops
$res = $conn->query("SELECT COUNT(*) as total FROM crops");
$totalCrops = $res->fetch_assoc()['total'];

// Total harvests (yield)
$res = $conn->query("SELECT COALESCE(SUM(quantity), 0) as total FROM harvests");
$totalHarvests = $res->fetch_assoc()['total'];

// Recent activity (latest users, crops, expenses)
$activity = [];

$res = $conn->query("SELECT full_name, created_at FROM users WHERE role = 'farmer' ORDER BY created_at DESC LIMIT 3");
while ($row = $res->fetch_assoc()) {
    $activity[] = [
        'type' => 'user',
        'title' => 'New farmer registered',
        'subtitle' => $row['full_name'] ?? 'Unknown',
        'time' => $row['created_at'],
    ];
}

$res = $conn->query("SELECT c.crop_name, c.status, c.created_at, f.farm_name FROM crops c JOIN farms f ON c.farm_id = f.id ORDER BY c.created_at DESC LIMIT 3");
while ($row = $res->fetch_assoc()) {
    $activity[] = [
        'type' => 'crop',
        'title' => 'Crop added: ' . $row['crop_name'],
        'subtitle' => $row['farm_name'] . ' — ' . ($row['status'] ?? 'Unknown'),
        'time' => $row['created_at'],
    ];
}

$res = $conn->query("SELECT e.description, e.amount, e.created_at, f.farm_name FROM expenses e JOIN farms f ON e.farm_id = f.id ORDER BY e.created_at DESC LIMIT 3");
while ($row = $res->fetch_assoc()) {
    $activity[] = [
        'type' => 'expense',
        'title' => 'Expense logged',
        'subtitle' => '₱' . number_format($row['amount'], 2) . ' — ' . ($row['description'] ?? $row['farm_name']),
        'time' => $row['created_at'],
    ];
}

// Sort by time desc
usort($activity, function ($a, $b) {
    return strtotime($b['time']) - strtotime($a['time']);
});
$activity = array_slice($activity, 0, 5);

echo json_encode([
    "success" => true,
    "stats" => [
        "total_farmers" => (int)$totalFarmers,
        "total_farms" => (int)$totalFarms,
        "total_crops" => (int)$totalCrops,
        "total_harvests" => (float)$totalHarvests,
    ],
    "recent_activity" => $activity,
]);

$conn->close();
?>
