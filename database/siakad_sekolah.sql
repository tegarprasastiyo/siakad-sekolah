-- SIAKAD Database Schema
-- Sistem Informasi Akademik Administrasi Sekolah

-- Create Database
CREATE DATABASE IF NOT EXISTS siakad_sekolah;
USE siakad_sekolah;

-- ============================================
-- TABLE: users (Login & Authentication)
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('admin', 'guru', 'siswa') NOT NULL DEFAULT 'siswa',
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLE: siswa (Data Siswa)
-- ============================================
CREATE TABLE IF NOT EXISTS siswa (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    nis VARCHAR(20) UNIQUE NOT NULL,
    nama_lengkap VARCHAR(100) NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    tanggal_lahir DATE,
    alamat TEXT,
    nomor_telepon VARCHAR(15),
    email VARCHAR(100),
    nama_ayah VARCHAR(100),
    nama_ibu VARCHAR(100),
    alamat_orang_tua TEXT,
    kelas_id INT,
    status ENUM('aktif', 'tidak-aktif', 'lulus', 'pindah') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_nis (nis),
    INDEX idx_kelas (kelas_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLE: guru (Data Guru)
-- ============================================
CREATE TABLE IF NOT EXISTS guru (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    nip VARCHAR(20) UNIQUE NOT NULL,
    nama_lengkap VARCHAR(100) NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    tanggal_lahir DATE,
    alamat TEXT,
    nomor_telepon VARCHAR(15),
    email VARCHAR(100),
    gelar_akademik VARCHAR(50),
    bidang_keahlian VARCHAR(100),
    status ENUM('aktif', 'tidak-aktif', 'pensiun') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_nip (nip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLE: kelas (Data Kelas)
-- ============================================
CREATE TABLE IF NOT EXISTS kelas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    kode_kelas VARCHAR(20) UNIQUE NOT NULL,
    nama_kelas VARCHAR(50) NOT NULL,
    tingkat INT,
    jurusan VARCHAR(50),
    wali_kelas_id INT,
    tahun_ajaran VARCHAR(10),
    status ENUM('aktif', 'tidak-aktif') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (wali_kelas_id) REFERENCES guru(id),
    INDEX idx_kode (kode_kelas),
    INDEX idx_tingkat (tingkat)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLE: mata_pelajaran (Mata Pelajaran)
-- ============================================
CREATE TABLE IF NOT EXISTS mata_pelajaran (
    id INT PRIMARY KEY AUTO_INCREMENT,
    kode_mapel VARCHAR(20) UNIQUE NOT NULL,
    nama_mapel VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    kkm INT DEFAULT 70,
    jam_pelajaran INT,
    status ENUM('aktif', 'tidak-aktif') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_kode (kode_mapel)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLE: jadwal_pelajaran (Jadwal Pelajaran)
-- ============================================
CREATE TABLE IF NOT EXISTS jadwal_pelajaran (
    id INT PRIMARY KEY AUTO_INCREMENT,
    kelas_id INT NOT NULL,
    mapel_id INT NOT NULL,
    guru_id INT NOT NULL,
    hari VARCHAR(20) NOT NULL,
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,
    ruang VARCHAR(50),
    tahun_ajaran VARCHAR(10),
    status ENUM('aktif', 'tidak-aktif') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (kelas_id) REFERENCES kelas(id) ON DELETE CASCADE,
    FOREIGN KEY (mapel_id) REFERENCES mata_pelajaran(id) ON DELETE CASCADE,
    FOREIGN KEY (guru_id) REFERENCES guru(id) ON DELETE CASCADE,
    INDEX idx_kelas (kelas_id),
    INDEX idx_hari (hari)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLE: absensi (Data Absensi)
-- ============================================
CREATE TABLE IF NOT EXISTS absensi (
    id INT PRIMARY KEY AUTO_INCREMENT,
    siswa_id INT NOT NULL,
    jadwal_id INT NOT NULL,
    tanggal DATE NOT NULL,
    status ENUM('hadir', 'izin', 'sakit', 'alfa') DEFAULT 'hadir',
    keterangan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (siswa_id) REFERENCES siswa(id) ON DELETE CASCADE,
    FOREIGN KEY (jadwal_id) REFERENCES jadwal_pelajaran(id) ON DELETE CASCADE,
    UNIQUE KEY unique_absensi (siswa_id, jadwal_id, tanggal),
    INDEX idx_siswa (siswa_id),
    INDEX idx_tanggal (tanggal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLE: nilai (Data Nilai/Rapor)
-- ============================================
CREATE TABLE IF NOT EXISTS nilai (
    id INT PRIMARY KEY AUTO_INCREMENT,
    siswa_id INT NOT NULL,
    mapel_id INT NOT NULL,
    kelas_id INT NOT NULL,
    semester INT,
    tahun_ajaran VARCHAR(10),
    nilai_uts DECIMAL(5,2),
    nilai_uas DECIMAL(5,2),
    nilai_tugas DECIMAL(5,2),
    nilai_praktik DECIMAL(5,2),
    nilai_akhir DECIMAL(5,2),
    grade VARCHAR(2),
    keterangan VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (siswa_id) REFERENCES siswa(id) ON DELETE CASCADE,
    FOREIGN KEY (mapel_id) REFERENCES mata_pelajaran(id) ON DELETE CASCADE,
    FOREIGN KEY (kelas_id) REFERENCES kelas(id) ON DELETE CASCADE,
    UNIQUE KEY unique_nilai (siswa_id, mapel_id, semester, tahun_ajaran),
    INDEX idx_siswa (siswa_id),
    INDEX idx_mapel (mapel_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- INSERT DEFAULT DATA
-- ============================================

-- Insert Admin User
INSERT INTO users (username, password, email, role, status) VALUES
('admin', '21232f297a57a5a743894a0e4a801fc3', 'admin@siakad.local', 'admin', 'active'); -- password: admin123

-- Insert Sample Guru Users
INSERT INTO users (username, password, email, role, status) VALUES
('guru1', 'c3e3ff6a906e3e4db88d0f849485c72a', 'guru1@siakad.local', 'guru', 'active'), -- password: guru123
('guru2', 'c3e3ff6a906e3e4db88d0f849485c72a', 'guru2@siakad.local', 'guru', 'active');

-- Insert Sample Siswa Users
INSERT INTO users (username, password, email, role, status) VALUES
('siswa1', '5d793d4c3c8e6b1f3d5a9c0b6e8a2f4d', 'siswa1@siakad.local', 'siswa', 'active'), -- password: siswa123
('siswa2', '5d793d4c3c8e6b1f3d5a9c0b6e8a2f4d', 'siswa2@siakad.local', 'siswa', 'active'),
('siswa3', '5d793d4c3c8e6b1f3d5a9c0b6e8a2f4d', 'siswa3@siakad.local', 'siswa', 'active');

-- Insert Guru Data
INSERT INTO guru (user_id, nip, nama_lengkap, jenis_kelamin, tanggal_lahir, alamat, nomor_telepon, email, gelar_akademik, bidang_keahlian, status) VALUES
(2, '199001011990001', 'Budi Santoso, S.Pd', 'L', '1990-01-01', 'Jl. Merdeka No. 123', '081234567890', 'guru1@siakad.local', 'S1', 'Matematika', 'aktif'),
(3, '199102021991002', 'Siti Nurhaliza, S.Pd', 'P', '1991-02-02', 'Jl. Gajah Mada No. 456', '081234567891', 'guru2@siakad.local', 'S1', 'Bahasa Indonesia', 'aktif');

-- Insert Kelas Data
INSERT INTO kelas (kode_kelas, nama_kelas, tingkat, jurusan, wali_kelas_id, tahun_ajaran, status) VALUES
('X-A', 'Kelas X A', 10, 'IPA', 1, '2024/2025', 'aktif'),
('X-B', 'Kelas X B', 10, 'IPS', 2, '2024/2025', 'aktif'),
('XI-A', 'Kelas XI A', 11, 'IPA', 1, '2024/2025', 'aktif');

-- Insert Mata Pelajaran Data
INSERT INTO mata_pelajaran (kode_mapel, nama_mapel, deskripsi, kkm, jam_pelajaran, status) VALUES
('MTK-01', 'Matematika', 'Pelajaran Matematika Dasar', 70, 4, 'aktif'),
('BIN-01', 'Bahasa Indonesia', 'Pelajaran Bahasa Indonesia', 75, 3, 'aktif'),
('ENG-01', 'Bahasa Inggris', 'Pelajaran Bahasa Inggris', 70, 3, 'aktif'),
('IPA-01', 'Ilmu Pengetahuan Alam', 'Pelajaran IPA', 70, 4, 'aktif');

-- Insert Siswa Data
INSERT INTO siswa (user_id, nis, nama_lengkap, jenis_kelamin, tanggal_lahir, alamat, nomor_telepon, email, nama_ayah, nama_ibu, kelas_id, status) VALUES
(4, '2024001', 'Ahmad Ridho', 'L', '2008-05-15', 'Jl. Sudirman No. 789', '081234567892', 'siswa1@siakad.local', 'Achmad', 'Siti', 1, 'aktif'),
(5, '2024002', 'Nurul Hidayah', 'P', '2008-06-20', 'Jl. Diponegoro No. 321', '081234567893', 'siswa2@siakad.local', 'Hasan', 'Nur', 1, 'aktif'),
(6, '2024003', 'Reza Pratama', 'L', '2008-07-10', 'Jl. Pahlawan No. 654', '081234567894', 'siswa3@siakad.local', 'Pranoto', 'Sinta', 2, 'aktif');

-- Insert Jadwal Pelajaran
INSERT INTO jadwal_pelajaran (kelas_id, mapel_id, guru_id, hari, jam_mulai, jam_selesai, ruang, tahun_ajaran, status) VALUES
(1, 1, 1, 'Senin', '07:00:00', '08:30:00', 'Ruang 10', '2024/2025', 'aktif'),
(1, 2, 2, 'Selasa', '08:30:00', '10:00:00', 'Ruang 10', '2024/2025', 'aktif'),
(1, 3, 1, 'Rabu', '10:00:00', '11:30:00', 'Ruang 10', '2024/2025', 'aktif'),
(2, 1, 2, 'Senin', '07:00:00', '08:30:00', 'Ruang 11', '2024/2025', 'aktif'),
(2, 2, 1, 'Selasa', '08:30:00', '10:00:00', 'Ruang 11', '2024/2025', 'aktif');

-- Create Index
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_kelas_wali ON kelas(wali_kelas_id);
CREATE INDEX idx_jadwal_kelas ON jadwal_pelajaran(kelas_id);
CREATE INDEX idx_absensi_siswa ON absensi(siswa_id);
CREATE INDEX idx_nilai_siswa ON nilai(siswa_id);
