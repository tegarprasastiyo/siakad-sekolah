<?php
/**
 * Database Configuration
 * SIAKAD - Sistem Informasi Akademik Administrasi Sekolah
 */

// Database Connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "siakad_sekolah";
$port = 3306;

try {
    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname, $port);
    
    // Check connection
    if ($conn->connect_error) {
        die(json_encode([
            'status' => 'error',
            'message' => 'Database connection failed: ' . $conn->connect_error
        ]));
    }
    
    // Set charset to utf8
    $conn->set_charset("utf8");
    
} catch (Exception $e) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Connection error: ' . $e->getMessage()
    ]));
}

// Function untuk escape string
function escape_string($string) {
    global $conn;
    return $conn->real_escape_string($string);
}

// Function untuk hash password
function hash_password($password) {
    return md5($password); // Gunakan bcrypt di production
}

// Function untuk verify password
function verify_password($password, $hash) {
    return md5($password) === $hash;
}

// Set timezone
date_default_timezone_set('Asia/Jakarta');
?>
