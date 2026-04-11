<?php
// ============================================================
// AgriFlow Database Setup — migrate:fresh --seed
// WARNING: This DROPS all tables and recreates them from scratch!
// All existing data will be lost.
// ============================================================
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$db_host = 'localhost';
$db_user = 'root';
$db_password = '';
$db_name = 'agriflow';

// Connect without database first
$conn = new mysqli($db_host, $db_user, $db_password);

if ($conn->connect_error) {
    echo json_encode(['success' => false, 'message' => 'Connection failed: ' . $conn->connect_error]);
    exit;
}

// ── DROP & RECREATE DATABASE ──
$conn->query("DROP DATABASE IF EXISTS $db_name");
$conn->query("CREATE DATABASE $db_name");
$conn->select_db($db_name);

// ── MIGRATIONS (create tables) ──
$tables = [];

// 1. Users table
$tables['users'] = "CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    role ENUM('admin', 'farmer') DEFAULT 'farmer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
)";

// 2. Farms table
$tables['farms'] = "CREATE TABLE farms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    farm_name VARCHAR(100) NOT NULL,
    location VARCHAR(150),
    size DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
)";

// 3. Crops table
$tables['crops'] = "CREATE TABLE crops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    crop_name VARCHAR(100) NOT NULL,
    planting_date DATE,
    expected_harvest DATE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
)";

// 4. Inventory table
$tables['inventory'] = "CREATE TABLE inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    item_name VARCHAR(100),
    quantity INT,
    unit VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
)";

// 5. Expenses table
$tables['expenses'] = "CREATE TABLE expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    description VARCHAR(150),
    amount DECIMAL(10,2),
    expense_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
)";

// 6. Harvests table
$tables['harvests'] = "CREATE TABLE harvests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    crop_id INT NOT NULL,
    quantity DECIMAL(10,2),
    harvest_date DATE,
    notes VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE
)";

// Run all migrations
$migrated = [];
foreach ($tables as $name => $sql) {
    if (!$conn->query($sql)) {
        echo json_encode([
            'success' => false,
            'message' => "Error creating table '$name': " . $conn->error,
            'migrated' => $migrated
        ]);
        $conn->close();
        exit;
    }
    $migrated[] = $name;
}

// ── SEEDERS (insert demo data) ──
$seeded = [];

// Seed users (passwords hashed with bcrypt)
$demoUsers = [
    ['admin', 'admin@agriflow.com', 'admin123', 'Admin User', 'admin'],
    ['farmer', 'farmer@agriflow.com', '1234', 'Farmer User', 'farmer']
];

foreach ($demoUsers as $user) {
    $hashedPassword = password_hash($user[2], PASSWORD_BCRYPT);
    $stmt = $conn->prepare("INSERT INTO users (username, email, password, full_name, role) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("sssss", $user[0], $user[1], $hashedPassword, $user[3], $user[4]);
    $stmt->execute();
    $seeded[] = "user: {$user[0]} ({$user[4]})";
    $stmt->close();
}

$conn->close();

echo json_encode([
    'success' => true,
    'message' => 'migrate:fresh --seed complete!',
    'migrated_tables' => $migrated,
    'seeded' => $seeded
], JSON_PRETTY_PRINT);
?>
