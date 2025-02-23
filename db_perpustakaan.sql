-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 23 Feb 2025 pada 13.21
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_perpustakaan`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `daftar_seluruh_buku` ()   BEGIN
    SELECT B.ID_Buku, B.Judul_Buku, B.Penulis, B.Kategori, B.Stok, 
           P.ID_Peminjaman AS Pernah_Dipinjam
    FROM Buku B
    LEFT JOIN Peminjaman P ON B.ID_Buku = P.ID_Buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `daftar_seluruh_siswa` ()   BEGIN
    SELECT S.ID_Siswa, S.Nama, S.Kelas, P.ID_Peminjaman
    FROM Siswa S
    LEFT JOIN Peminjaman P ON S.ID_Siswa = P.ID_Siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `daftar_siswa_peminjam` ()   BEGIN
    SELECT DISTINCT Siswa.ID_Siswa, Siswa.Nama, Siswa.Kelas
    FROM Siswa
    JOIN Peminjaman ON Siswa.ID_Siswa = Peminjaman.ID_Siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_buku` (IN `pID_Buku` INT)   BEGIN
    DELETE FROM Buku WHERE ID_Buku = pID_Buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_peminjaman` (IN `pID_Peminjaman` INT)   BEGIN
    DELETE FROM Peminjaman WHERE ID_Peminjaman = pID_Peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_siswa` (IN `pID_Siswa` INT)   BEGIN
    DELETE FROM Siswa WHERE ID_Siswa = pID_Siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_buku` (`pJudul_Buku` VARCHAR(50), `pPenulis` VARCHAR(50), `pKategori` VARCHAR(50), `pStok` INT)   BEGIN
    INSERT INTO buku (Judul_Buku, Penulis, Kategori, Stok) VALUES (pJudul_Buku, pPenulis, pKategori, pStok);
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_peminjaman` (`pID_Siswa` INT, `pID_Buku` INT, `pTanggal_Pinjam` DATE, `pTanggal_Kembali` DATE, `pStatus` VARCHAR(50))   BEGIN
    INSERT INTO peminjaman (ID_Siswa, ID_Buku, Tanggal_Pinjam, Tanggal_Kembali, Status) 
    VALUES (pID_Siswa, pID_Buku, pTanggal_Pinjam, pTanggal_Kembali, pStatus);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_siswa` (`pNama` VARCHAR(50), `pKelas` VARCHAR(50))   BEGIN
    INSERT INTO siswa (Nama, Kelas) VALUES (pNama, pKelas);
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `kembalikan_buku` (`pID_Peminjaman` INT)   BEGIN
    UPDATE Peminjaman 
    SET Status = 'Dikembalikan' 
    WHERE ID_Peminjaman = p_ID_Peminjaman;

    UPDATE Buku 
    SET Stok = Stok + 1 
    WHERE ID_Buku = (SELECT ID_Buku FROM Peminjaman WHERE ID_Peminjaman = pID_Peminjaman);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `kembalikan_buku_sesuai_hari` (`pID_Peminjaman` INT)   BEGIN
    UPDATE Peminjaman 
    SET Status = 'Dikembalikan', 
        Tanggal_Kembali = CURRENT_DATE
    WHERE ID_Peminjaman = pID_Peminjaman;

    UPDATE Buku 
    SET Stok = Stok + 1 
    WHERE ID_Buku = (SELECT ID_Buku FROM Peminjaman WHERE ID_Peminjaman = pID_Peminjaman);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pinjam_buku` (`pID_Siswa` INT, `pID_Buku` INT, `pTanggal_Pinjam` DATE, `pTanggal_Kembali` DATE)   BEGIN
    INSERT INTO Peminjaman (ID_Siswa, ID_Buku, Tanggal_Pinjam, Tanggal_Kembali, Status)
    VALUES (pID_Siswa, pID_Buku, pTanggal_Pinjam, pTanggal_Kembali, 'Dipinjam');

    UPDATE Buku 
    SET Stok = Stok - 1 
    WHERE ID_Buku = pID_Buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `semua_buku` ()   BEGIN
    SELECT * FROM Buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `semua_peminjaman` ()   BEGIN
    SELECT * FROM Peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `semua_siswa` ()   BEGIN
    SELECT * FROM Siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_buku` (`pID_Buku` INT, `pJudul_Buku` VARCHAR(50), `pPenulis` VARCHAR(50), `pKategori` VARCHAR(50), `pStok` INT)   BEGIN
    UPDATE Buku
    SET 
        Judul_Buku = pJudul_Buku,
        Penulis = pPenulis,
        Kategori = pKategori,
        Stok = pStok
    WHERE ID_Buku = pID_Buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_peminjaman` (`pID_Peminjaman` INT, `pID_Siswa` INT, `pID_Buku` INT, `pTanggal_Pinjam` DATE, `pTanggal_Kembali` DATE, `pStatus` VARCHAR(50))   BEGIN
    UPDATE Peminjaman
    SET 
        ID_Siswa = pID_Siswa,
        ID_Buku = pID_Buku,
        Tanggal_Pinjam = pTanggal_Pinjam,
        Tanggal_Kembali = pTanggal_Kembali,
        Status = pStatus
    WHERE ID_Peminjaman = pID_Peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_siswa` (`pID_Siswa` INT, `pNama` VARCHAR(50), `pKelas` VARCHAR(50))   BEGIN
    UPDATE Siswa
    SET 
        Nama = pNama,
        Kelas = pKelas
    WHERE ID_Siswa = pID_Siswa;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `buku`
--

CREATE TABLE `buku` (
  `ID_Buku` int(11) NOT NULL,
  `Judul_Buku` varchar(50) DEFAULT NULL,
  `Penulis` varchar(50) DEFAULT NULL,
  `Kategori` varchar(50) DEFAULT NULL,
  `Stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `buku`
--

INSERT INTO `buku` (`ID_Buku`, `Judul_Buku`, `Penulis`, `Kategori`, `Stok`) VALUES
(1, 'Algoritma dan Pemrograman', 'Andi Wijaya', 'Teknologi', 5),
(2, 'Dasar-dasar Database', 'Budi Santoso', 'Teknologi', 7),
(3, 'Matematika Diskrit', 'Rina Sari', 'Matematika', 5),
(4, 'Sejarah Dunia', 'John Smith', 'Sejarah', 3),
(5, 'Pemrograman Web dengan PHP', 'Eko Prasetyo', 'Teknologi', 7),
(6, 'Sistem Operasi', 'Dian Kurniawan', 'Teknologi', 6),
(7, 'Jaringan Komputer', 'Ahmad Fauzi', 'Teknologi', 5),
(8, 'Cerita Rakyat Nusantara', 'Lestari Dewi', 'Sastra', 9),
(9, 'Bahasa Inggris untuk Pemula', 'Jane Doe', 'Bahasa', 10),
(10, 'Biologi Dasar', 'Budi Rahman', 'Sains', 7),
(11, 'Kimia Organik', 'Siti Aminah', 'Sains', 5),
(12, 'Teknik Elektro', 'Ridwan Hakim', 'Teknik', 6),
(13, 'Fisika Modern', 'Albert Einstein', 'Sains', 4),
(14, 'Manajemen Waktu', 'Steven Covey', 'Pengembangan', 8),
(15, 'Strategi Belajar Efektif', 'Tony Buzan', 'Pendidikan', 6);

-- --------------------------------------------------------

--
-- Struktur dari tabel `peminjaman`
--

CREATE TABLE `peminjaman` (
  `ID_Peminjaman` int(11) NOT NULL,
  `ID_Siswa` int(11) DEFAULT NULL,
  `ID_Buku` int(11) DEFAULT NULL,
  `Tanggal_Pinjam` date DEFAULT NULL,
  `Tanggal_Kembali` date DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `peminjaman`
--

INSERT INTO `peminjaman` (`ID_Peminjaman`, `ID_Siswa`, `ID_Buku`, `Tanggal_Pinjam`, `Tanggal_Kembali`, `Status`) VALUES
(1, 11, 2, '2025-02-01', '2025-02-08', 'Dipinjam'),
(2, 2, 5, '2025-01-28', '2025-02-04', 'Dikembalikan'),
(3, 3, 8, '2025-02-02', '2025-02-09', 'Dipinjam'),
(4, 4, 10, '2025-01-30', '2025-02-06', 'Dikembalikan'),
(5, 5, 3, '2025-01-25', '2025-02-23', 'Dikembalikan'),
(6, 15, 7, '2025-02-01', '2025-02-08', 'Dipinjam'),
(7, 7, 1, '2025-01-29', '2025-02-05', 'Dikembalikan'),
(8, 8, 9, '2025-02-03', '2025-02-10', 'Dipinjam'),
(9, 13, 4, '2025-01-27', '2025-02-03', 'Dikembalikan'),
(10, 10, 11, '2025-02-01', '2025-02-08', 'Dipinjam'),
(16, 1, 5, '2025-02-21', '2025-02-28', 'Dipinjam');

-- --------------------------------------------------------

--
-- Struktur dari tabel `siswa`
--

CREATE TABLE `siswa` (
  `ID_Siswa` int(11) NOT NULL,
  `Nama` varchar(50) DEFAULT NULL,
  `Kelas` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `siswa`
--

INSERT INTO `siswa` (`ID_Siswa`, `Nama`, `Kelas`) VALUES
(1, 'Andi Saputra', 'X-RPL'),
(2, 'Budi Wijaya', 'X-TKJ'),
(3, 'Citra Lestari', 'XI-RPL'),
(4, 'Dewi Kurniawan', 'XI-TKJ'),
(5, 'Eko Prasetyo', 'XII-RPL'),
(6, 'Farhan Maulana', 'XII-TKJ'),
(7, 'Gita Permata', 'X-RPL'),
(8, 'Hadi Sucipto', 'X-TKJ'),
(9, 'Intan Permadi', 'XI-RPL'),
(10, 'Joko Santoso', 'XI-TKJ'),
(11, 'Kartika Sari', 'XII-RPL'),
(12, 'Lintang Putri', 'XII-TKJ'),
(13, 'Muhammad Rizky', 'X-RPL'),
(14, 'Novi Andriana', 'X-TKJ'),
(15, 'Olivia Hernanda', 'XI-RPL');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`ID_Buku`);

--
-- Indeks untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`ID_Peminjaman`);

--
-- Indeks untuk tabel `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`ID_Siswa`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `buku`
--
ALTER TABLE `buku`
  MODIFY `ID_Buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `ID_Peminjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `siswa`
--
ALTER TABLE `siswa`
  MODIFY `ID_Siswa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
