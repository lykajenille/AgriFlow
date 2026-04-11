<?php
header("Content-Type: application/json");
include "db_connect.php";

$user_id = $_GET['user_id'] ?? '';

$sql = "SELECT f.farm_name,
               SUM(e.amount) AS total_expenses
        FROM farms f
        LEFT JOIN expenses e ON f.id = e.farm_id
        WHERE f.user_id = '$user_id'
        GROUP BY f.id";

$result = mysqli_query($conn, $sql);

$reports = [];

while ($row = mysqli_fetch_assoc($result)) {
    $reports[] = $row;
}

echo json_encode($reports);
?>