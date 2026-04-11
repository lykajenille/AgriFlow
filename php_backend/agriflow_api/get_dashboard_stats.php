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

// Total farms
$stmt = $conn->prepare("SELECT COUNT(*) as total FROM farms WHERE user_id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$totalFarms = $stmt->get_result()->fetch_assoc()['total'];
$stmt->close();

// Total crops
$stmt = $conn->prepare("SELECT COUNT(*) as total FROM crops c JOIN farms f ON c.farm_id = f.id WHERE f.user_id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$totalCrops = $stmt->get_result()->fetch_assoc()['total'];
$stmt->close();

// Total expenses
$stmt = $conn->prepare("SELECT COALESCE(SUM(e.amount), 0) as total FROM expenses e JOIN farms f ON e.farm_id = f.id WHERE f.user_id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$totalExpenses = $stmt->get_result()->fetch_assoc()['total'];
$stmt->close();

// Total harvests
$stmt = $conn->prepare("SELECT COALESCE(SUM(h.quantity), 0) as total FROM harvests h JOIN crops c ON h.crop_id = c.id JOIN farms f ON c.farm_id = f.id WHERE f.user_id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$totalHarvests = $stmt->get_result()->fetch_assoc()['total'];
$stmt->close();

// Recent crops (latest 5)
$stmt = $conn->prepare("SELECT c.crop_name, c.status, c.planting_date, f.farm_name 
    FROM crops c JOIN farms f ON c.farm_id = f.id 
    WHERE f.user_id = ? ORDER BY c.created_at DESC LIMIT 5");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
$recentCrops = [];
while ($row = $result->fetch_assoc()) {
    $recentCrops[] = $row;
}
$stmt->close();

echo json_encode([
    "success" => true,
    "stats" => [
        "total_farms" => (int)$totalFarms,
        "total_crops" => (int)$totalCrops,
        "total_expenses" => (float)$totalExpenses,
        "total_harvests" => (float)$totalHarvests,
    ],
    "recent_crops" => $recentCrops,
]);

$conn->close();
?>
