<?php
// Database setup script
header('Content-Type: application/json');

$db_host = 'localhost';
$db_user = 'root';
$db_password = '';

// Connect without database first
$conn = new mysqli($db_host, $db_user, $db_password);

if ($conn->connect_error) {
    echo json_encode([
        'success' => false,
        'message' => 'Connection failed: ' . $conn->connect_error
    ]);
    exit;
}

// Create database
$createDb = "CREATE DATABASE IF NOT EXISTS agriflow";
if (!$conn->query($createDb)) {
    echo json_encode([
        'success' => false,
        'message' => 'Error creating database: ' . $conn->error
    ]);
    exit;
}

// Select the database
$conn->select_db('agriflow');

// Create users table
$createTable = "CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    role ENUM('admin', 'farmer') DEFAULT 'farmer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
)";

if (!$conn->query($createTable)) {
    echo json_encode([
        'success' => false,
        'message' => 'Error creating users table: ' . $conn->error
    ]);
    exit;
}

// Insert demo users if they don't exist
$demoUsers = [
    ['admin', 'admin@agriflow.com', 'admin123', 'Admin User', 'admin'],
    ['farmer', 'farmer@agriflow.com', '1234', 'Farmer User', 'farmer']
];

foreach ($demoUsers as $user) {
    $username = $user[0];
    $email = $user[1];
    $password = $user[2];
    $fullName = $user[3];
    $role = $user[4];

    $checkUser = $conn->prepare("SELECT id FROM users WHERE username = ?");
    $checkUser->bind_param("s", $username);
    $checkUser->execute();
    $result = $checkUser->get_result();

    if ($result->num_rows === 0) {
        $stmt = $conn->prepare("INSERT INTO users (username, email, password, full_name, role) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param("sssss", $username, $email, $password, $fullName, $role);
        $stmt->execute();
        $stmt->close();
    }
    $checkUser->close();
}

$conn->close();

echo json_encode([
    'success' => true,
    'message' => 'Database setup complete!',
    'details' => 'agriflow database created with users table'
]);
?>
