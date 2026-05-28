# SIAKAD - Sistem Informasi Akademik Administrasi Sekolah

Website lengkap untuk mengelola data akademik sekolah dengan database MySQL.

## 🎯 Fitur Utama
- ✅ **Login & Authentication** - Sistem login dengan role-based access
- ✅ **Dashboard** - Statistik real-time dengan visualisasi data
- ✅ **Manajemen Siswa** - CRUD lengkap untuk data siswa
- ✅ **Manajemen Guru** - CRUD lengkap untuk data guru
- ✅ **Manajemen Kelas** - Organisasi kelas dan wali kelas
- ✅ **Mata Pelajaran** - Manajemen mata pelajaran dan KKM
- ✅ **Jadwal Pelajaran** - Penjadwalan kelas, guru, dan ruangan
- ✅ **Absensi** - Pencatatan kehadiran siswa per mata pelajaran
- ✅ **Nilai/Rapor** - Input dan kalkulasi otomatis nilai dengan grading
- ✅ **Export Data** - Export ke Excel (fitur tambahan)
- ✅ **Role-based Access** - Admin, Guru, Siswa dengan hak akses berbeda

## 💻 Tech Stack
- **Backend**: PHP 7.4+
- **Database**: MySQL 5.7+ (XAMPP)
- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Server**: Apache (XAMPP)
- **Authentication**: Session-based dengan password hashing

## 📋 Requirement
- XAMPP (atau server PHP+MySQL lainnya)
- PHP 7.4 atau lebih tinggi
- MySQL 5.7 atau lebih tinggi
- Browser modern (Chrome, Firefox, Safari, Edge)

## 🚀 Instalasi & Setup

### 1. Download Project
```bash
git clone https://github.com/tegarprasastiyo/siakad-sekolah.git
cd siakad-sekolah
```

### 2. Setup Database

**Via XAMPP Control Panel:**
1. Buka **XAMPP Control Panel**
2. Klik tombol "Start" pada Apache dan MySQL
3. Buka browser → http://localhost/phpmyadmin
4. Buat database baru: `siakad_sekolah`
5. Import file: `database/siakad_sekolah.sql`

**Via Command Line:**
```bash
mysql -u root -p < database/siakad_sekolah.sql
```

### 3. Copy Files ke XAMPP

**Windows:**
```bash
xcopy /E siakad-sekolah "C:\xampp\htdocs\siakad-sekolah"
```

**Linux/Mac:**
```bash
cp -r siakad-sekolah /opt/lampp/htdocs/
```

### 4. Konfigurasi Database

Edit file `config/database.php`:
```php
$servername = "localhost";
$username = "root";           // User MySQL (default: root)
$password = "";               // Password MySQL (kosongkan jika tidak ada)
$dbname = "siakad_sekolah";  // Nama database
$port = 3306;                 // Port MySQL (default: 3306)
```

### 5. Akses Aplikasi

Buka browser dan akses:
```
http://localhost/siakad-sekolah/
```

## 🔐 Default Login Credentials

| Role | Username | Password | Keterangan |
|------|----------|----------|-----------|
| Admin | `admin` | `admin123` | Akses penuh ke semua menu |
| Guru | `guru1` | `guru123` | Input nilai, absensi, jadwal |
| Siswa | `siswa1` | `siswa123` | Lihat jadwal, nilai, absensi |

## 📁 Struktur Folder

```
siakad-sekolah/
├── api/                           # Endpoint API
│   ├── login.php                 # Authentication
│   ├── logout.php                # Logout
│   ├── dashboard.php             # Dashboard data
│   ├── siswa.php                 # Manajemen siswa
│   ├── guru.php                  # Manajemen guru
│   ├── kelas.php                 # Manajemen kelas
│   ├── mapel.php                 # Manajemen mata pelajaran
│   ├── jadwal.php                # Manajemen jadwal
│   ├── absensi.php               # Manajemen absensi
│   └── nilai.php                 # Manajemen nilai
├── config/
│   └── database.php              # Konfigurasi database
├── database/
│   └── siakad_sekolah.sql        # Schema dan data default
├── pages/                         # Halaman dashboard
│   ├── dashboard.html            # Halaman utama
│   ├── siswa.html                # Manajemen siswa
│   ├── guru.html                 # Manajemen guru
│   ├── kelas.html                # Manajemen kelas
│   ├── mapel.html                # Manajemen mata pelajaran
│   ├── jadwal.html               # Manajemen jadwal
│   ├── absensi.html              # Manajemen absensi
│   ├── nilai.html                # Manajemen nilai
│   └── profile.html              # Profile user
├── assets/
│   ├── css/
│   │   └── style.css             # Stylesheet utama
│   └── js/
│       └── script.js             # JavaScript utilities
├── index.html                    # Halaman login
├── .htaccess                     # URL rewriting (opsional)
└── README.md                     # File dokumentasi
```

## 📡 API Endpoints

### Authentication
```
POST   /api/login.php              - Login user
GET    /api/login.php              - Check login status
GET    /api/logout.php             - Logout user
GET    /api/dashboard.php          - Get dashboard statistics
```

### Siswa
```
GET    /api/siswa.php?action=list      - Daftar siswa
POST   /api/siswa.php?action=create    - Tambah siswa
PUT    /api/siswa.php?action=update    - Update siswa
DELETE /api/siswa.php?action=delete    - Hapus siswa
```

### Guru
```
GET    /api/guru.php?action=list       - Daftar guru
POST   /api/guru.php?action=create     - Tambah guru
PUT    /api/guru.php?action=update     - Update guru
DELETE /api/guru.php?action=delete     - Hapus guru
```

### Kelas
```
GET    /api/kelas.php?action=list      - Daftar kelas
POST   /api/kelas.php?action=create    - Tambah kelas
PUT    /api/kelas.php?action=update    - Update kelas
DELETE /api/kelas.php?action=delete    - Hapus kelas
```

### Mata Pelajaran
```
GET    /api/mapel.php?action=list      - Daftar mata pelajaran
POST   /api/mapel.php?action=create    - Tambah mata pelajaran
PUT    /api/mapel.php?action=update    - Update mata pelajaran
DELETE /api/mapel.php?action=delete    - Hapus mata pelajaran
```

### Jadwal Pelajaran
```
GET    /api/jadwal.php?action=list     - Daftar jadwal
POST   /api/jadwal.php?action=create   - Tambah jadwal
PUT    /api/jadwal.php?action=update   - Update jadwal
DELETE /api/jadwal.php?action=delete   - Hapus jadwal
```

### Absensi
```
GET    /api/absensi.php?action=list    - Daftar absensi
POST   /api/absensi.php?action=create  - Tambah absensi
PUT    /api/absensi.php?action=update  - Update absensi
DELETE /api/absensi.php?action=delete  - Hapus absensi
```

### Nilai
```
GET    /api/nilai.php?action=list      - Daftar nilai
POST   /api/nilai.php?action=create    - Tambah nilai
PUT    /api/nilai.php?action=update    - Update nilai
DELETE /api/nilai.php?action=delete    - Hapus nilai
```

## 📊 Tabel Database

### users
Menyimpan data user login dengan role (admin, guru, siswa)

### siswa
Data siswa lengkap termasuk identitas, kelas, dan informasi orang tua

### guru
Data guru termasuk NIP, gelar akademik, dan bidang keahlian

### kelas
Data kelas dengan wali kelas dan tahun ajaran

### mata_pelajaran
Daftar mata pelajaran dengan KKM

### jadwal_pelajaran
Jadwal pelajaran per kelas, guru, dan ruangan

### absensi
Pencatatan kehadiran siswa per pelajaran

### nilai
Data nilai siswa per mata pelajaran dengan kalkulasi otomatis

## 🔒 Keamanan

- ✅ Password hashing (MD5 - gunakan bcrypt di production)
- ✅ Session management
- ✅ SQL injection prevention dengan prepared statements
- ✅ CORS headers
- ✅ Role-based access control
- ✅ Input validation di frontend dan backend

## 🛠️ Fitur Kalkulasi

### Nilai Akhir
```
Nilai Akhir = (UTS × 0.35) + (UAS × 0.35) + (Tugas × 0.15) + (Praktik × 0.15)
```

### Grade
- A: 90-100
- B: 80-89
- C: 70-79
- D: 60-69
- E: < 60

## 📝 Catatan Penting

1. **Development Mode**: Saat ini menggunakan MD5 untuk password. Gunakan bcrypt untuk production.
2. **XAMPP Port**: Pastikan Apache berjalan di port 80
3. **Charset**: Semua database menggunakan UTF-8MB4 untuk support Unicode
4. **Session Timeout**: Session tidak ada timeout, bisa ditambahkan sesuai kebutuhan
5. **Excel Export**: Fitur export belum diimplementasikan, bisa menggunakan library seperti PhpSpreadsheet

## 🚨 Troubleshooting

### Error: "Connection refused"
- Pastikan MySQL sudah running
- Cek konfigurasi di `config/database.php`

### Error: "Table already exists"
- Database sudah ada, hapus dan buat ulang, atau skip step import

### Halaman blank atau error 500
- Cek error log di `php.ini` error_log
- Pastikan PHP extensions: mysqli, PDO

## 🎓 Tutorial & Support

Untuk pembelajaran lebih lanjut atau bantuan:
- Dokumentasi PHP: https://www.php.net/manual/
- MySQL Tutorial: https://dev.mysql.com/doc/
- HTML/CSS/JS: https://developer.mozilla.org/

## 📄 Lisensi

MIT License - Bebas untuk digunakan, dimodifikasi, dan didistribusikan.

## 👨‍💻 Author

**Tegar Prasastiyo** (@tegarprasastiyo)
- GitHub: https://github.com/tegarprasastiyo
- Email: tegarprasastiyo@gmail.com

## 🤝 Kontribusi

Silakan fork repository ini dan buat pull request untuk fitur atau perbaikan baru!

---

**Last Updated**: 28 Mei 2026
**Version**: 1.0.0
