<?php
// Fix admin password - generate proper bcrypt hash
require_once 'db_connect.php';

$password = 'admin123';
$hashedPassword = password_hash($password, PASSWORD_BCRYPT);

// Update admin password with proper bcrypt hash
$stmt = $conn->prepare("UPDATE users SET password = ? WHERE username = 'admin'");
$stmt->bind_param("s", $hashedPassword);

if ($stmt->execute()) {
    if ($stmt->affected_rows > 0) {
        echo json_encode([
            'success' => true,
            'message' => 'Admin password updated with bcrypt hash'
        ]);
    } else {
        // Admin doesn't exist yet, insert one
        $stmt->close();
        $stmt = $conn->prepare("INSERT INTO users (fullname, username, password, role) VALUES ('System Admin', 'admin', ?, 'admin')");
        $stmt->bind_param("s", $hashedPassword);
        if ($stmt->execute()) {
            echo json_encode([
                'success' => true,
                'message' => 'Admin user created with bcrypt hash'
            ]);
        } else {
            echo json_encode([
                'success' => false,
                'message' => 'Failed to create admin: ' . $conn->error
            ]);
        }
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Failed to update: ' . $conn->error
    ]);
}

$stmt->close();
$conn->close();
?>
