<?php
/**
 * Nilai API
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
            $sql = "SELECT n.*, s.nama_lengkap, m.nama_mapel, k.nama_kelas
                    FROM nilai n
                    JOIN siswa s ON n.siswa_id = s.id
                    JOIN mata_pelajaran m ON n.mapel_id = m.id
                    JOIN kelas k ON n.kelas_id = k.id
                    ORDER BY n.tahun_ajaran DESC, s.nama_lengkap ASC";
            
            $result = $conn->query($sql);
            $nilai = $result->fetch_all(MYSQLI_ASSOC);
            
            http_response_code(200);
            echo json_encode([
                'status' => 'success',
                'data' => $nilai
            ]);
        }
        break;
        
    case 'create':
        if ($method == 'POST') {
            $input = json_decode(file_get_contents("php://input"), true);
            
            if (!$input['siswa_id'] || !$input['mapel_id'] || !$input['kelas_id']) {
                http_response_code(400);
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Data tidak lengkap'
                ]);
                exit;
            }
            
            // Calculate nilai akhir
            $nilai_uts = $input['nilai_uts'] ?? 0;
            $nilai_uas = $input['nilai_uas'] ?? 0;
            $nilai_tugas = $input['nilai_tugas'] ?? 0;
            $nilai_praktik = $input['nilai_praktik'] ?? 0;
            
            $nilai_akhir = ($nilai_uts * 0.35) + ($nilai_uas * 0.35) + ($nilai_tugas * 0.15) + ($nilai_praktik * 0.15);
            
            // Determine grade
            $grade = 'E';
            if ($nilai_akhir >= 90) $grade = 'A';
            elseif ($nilai_akhir >= 80) $grade = 'B';
            elseif ($nilai_akhir >= 70) $grade = 'C';
            elseif ($nilai_akhir >= 60) $grade = 'D';
            
            $sql = "INSERT INTO nilai (siswa_id, mapel_id, kelas_id, semester, tahun_ajaran, nilai_uts, nilai_uas, nilai_tugas, nilai_praktik, nilai_akhir, grade) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            $stmt = $conn->prepare($sql);
            $stmt->bind_param(
                "iiiiidddds",
                $input['siswa_id'],
                $input['mapel_id'],
                $input['kelas_id'],
                $input['semester'],
                $input['tahun_ajaran'],
                $nilai_uts,
                $nilai_uas,
                $nilai_tugas,
                $nilai_praktik,
                $nilai_akhir,
                $grade
            );
            
            if ($stmt->execute()) {
                http_response_code(201);
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Nilai berhasil ditambahkan',
                    'data' => ['id' => $conn->insert_id]
                ]);
            } else {
                http_response_code(400);
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Gagal membuat nilai: ' . $stmt->error
                ]);
            }
        }
        break;
        
    case 'update':
        if ($method == 'PUT') {
            $input = json_decode(file_get_contents("php://input"), true);
            $id = $input['id'];
            
            // Calculate nilai akhir
            $nilai_uts = $input['nilai_uts'] ?? 0;
            $nilai_uas = $input['nilai_uas'] ?? 0;
            $nilai_tugas = $input['nilai_tugas'] ?? 0;
            $nilai_praktik = $input['nilai_praktik'] ?? 0;
            
            $nilai_akhir = ($nilai_uts * 0.35) + ($nilai_uas * 0.35) + ($nilai_tugas * 0.15) + ($nilai_praktik * 0.15);
            
            // Determine grade
            $grade = 'E';
            if ($nilai_akhir >= 90) $grade = 'A';
            elseif ($nilai_akhir >= 80) $grade = 'B';
            elseif ($nilai_akhir >= 70) $grade = 'C';
            elseif ($nilai_akhir >= 60) $grade = 'D';
            
            $sql = "UPDATE nilai SET nilai_uts=?, nilai_uas=?, nilai_tugas=?, nilai_praktik=?, nilai_akhir=?, grade=? WHERE id=?";
            
            $stmt = $conn->prepare($sql);
            $stmt->bind_param(
                "ddddssi",
                $nilai_uts,
                $nilai_uas,
                $nilai_tugas,
                $nilai_praktik,
                $nilai_akhir,
                $grade,
                $id
            );
            
            if ($stmt->execute()) {
                http_response_code(200);
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Nilai berhasil diperbarui'
                ]);
            } else {
                http_response_code(400);
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Gagal mengupdate nilai: ' . $stmt->error
                ]);
            }
        }
        break;
        
    case 'delete':
        if ($method == 'DELETE') {
            $input = json_decode(file_get_contents("php://input"), true);
            $id = $input['id'];
            
            $sql = "DELETE FROM nilai WHERE id = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("i", $id);
            
            if ($stmt->execute()) {
                http_response_code(200);
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Nilai berhasil dihapus'
                ]);
            } else {
                http_response_code(400);
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Gagal menghapus nilai: ' . $stmt->error
                ]);
            }
        }
        break;
}

$conn->close();
?>
