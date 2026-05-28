<?php
/**
 * Mata Pelajaran API
 * SIAKAD - Sistem Informasi Akademik
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

session_start();

require_once '../config/database.php';

// Check login
if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode([
        'status' => 'error',
        'message' => 'Unauthorized'
    ]);
    exit;
}

$action = isset($_GET['action']) ? $_GET['action'] : '';
$method = $_SERVER['REQUEST_METHOD'];

switch($action) {
    case 'list':
        if ($method == 'GET') {
            $sql = "SELECT * FROM mata_pelajaran ORDER BY nama_mapel ASC";
            
            $result = $conn->query($sql);
            $mapel = $result->fetch_all(MYSQLI_ASSOC);
            
            http_response_code(200);
            echo json_encode([
                'status' => 'success',
                'data' => $mapel
            ]);
        }
        break;
        
    case 'create':
        if ($method == 'POST') {
            $input = json_decode(file_get_contents("php://input"), true);
            
            if (!$input['kode_mapel'] || !$input['nama_mapel']) {
                http_response_code(400);
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Data tidak lengkap'
                ]);
                exit;
            }
            
            $sql = "INSERT INTO mata_pelajaran (kode_mapel, nama_mapel, deskripsi, kkm, jam_pelajaran, status) 
                    VALUES (?, ?, ?, ?, ?, 'aktif')";
            
            $stmt = $conn->prepare($sql);
            $stmt->bind_param(
                "sssii",
                $input['kode_mapel'],
                $input['nama_mapel'],
                $input['deskripsi'],
                $input['kkm'],
                $input['jam_pelajaran']
            );
            
            if ($stmt->execute()) {
                http_response_code(201);
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Mata pelajaran berhasil ditambahkan',
                    'data' => ['id' => $conn->insert_id]
                ]);
            } else {
                http_response_code(400);
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Gagal membuat mata pelajaran: ' . $stmt->error
                ]);
            }
        }
        break;
        
    case 'update':
        if ($method == 'PUT') {
            $input = json_decode(file_get_contents("php://input"), true);
            $id = $input['id'];
            
            $sql = "UPDATE mata_pelajaran SET nama_mapel=?, deskripsi=?, kkm=?, jam_pelajaran=? WHERE id=?";
            
            $stmt = $conn->prepare($sql);
            $stmt->bind_param(
                "ssiis",
                $input['nama_mapel'],
                $input['deskripsi'],
                $input['kkm'],
                $input['jam_pelajaran'],
                $id
            );
            
            if ($stmt->execute()) {
                http_response_code(200);
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Mata pelajaran berhasil diperbarui'
                ]);
            } else {
                http_response_code(400);
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Gagal mengupdate mata pelajaran: ' . $stmt->error
                ]);
            }
        }
        break;
        
    case 'delete':
        if ($method == 'DELETE') {
            $input = json_decode(file_get_contents("php://input"), true);
            $id = $input['id'];
            
            $sql = "DELETE FROM mata_pelajaran WHERE id = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("i", $id);
            
            if ($stmt->execute()) {
                http_response_code(200);
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Mata pelajaran berhasil dihapus'
                ]);
            } else {
                http_response_code(400);
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Gagal menghapus mata pelajaran: ' . $stmt->error
                ]);
            }
        }
        break;
}

$conn->close();
?>
