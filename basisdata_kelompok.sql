-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 15 Jul 2024 pada 18.04
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `basisdata_kelompok`
--
CREATE DATABASE IF NOT EXISTS `basisdata_kelompok` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `basisdata_kelompok`;

-- --------------------------------------------------------

--
-- Struktur dari tabel `index_table`
--

CREATE TABLE `index_table` (
  `id` int(11) NOT NULL,
  `category` varchar(50) NOT NULL,
  `value` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_table`
--

CREATE TABLE `log_table` (
  `log_id` int(11) NOT NULL,
  `action_type` varchar(20) DEFAULT NULL,
  `table_name` varchar(20) DEFAULT NULL,
  `old_values` text DEFAULT NULL,
  `new_values` text DEFAULT NULL,
  `action_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_table`
--

INSERT INTO `log_table` (`log_id`, `action_type`, `table_name`, `old_values`, `new_values`, `action_time`) VALUES
(1, 'INSERT', 'produk', NULL, 'ID: 0, Name: Produk G, Price: 350000.00', '2024-07-15 15:07:29'),
(2, 'UPDATE', 'produk', 'ID: 1, Name: Produk A, Price: 50000.00', 'ID: 1, Name: Produk A, Price: 350000.00', '2024-07-15 15:08:10'),
(5, 'INSERT', 'pesanan', NULL, 'ID: 6, User ID: 1, Status: Selesai', '2024-07-15 15:10:48'),
(6, 'INSERT', 'pesanan', NULL, 'ID: 7, User ID: 2, Status: Diproses', '2024-07-15 15:49:40'),
(7, 'UPDATE', 'pesanan', 'ID: 7, User ID: 2, Status: Diproses', 'ID: 7, User ID: 2, Status: Diproses', '2024-07-15 15:52:35');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int(11) NOT NULL,
  `nama` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `tanggal_daftar` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `nama`, `email`, `password`, `tanggal_daftar`) VALUES
(1, 'Andi', 'andi@example.com', 'password1', '2024-01-01'),
(2, 'Budi', 'budi@example.com', 'password2', '2024-02-01'),
(3, 'Cici', 'cici@example.com', 'password3', '2024-03-01'),
(4, 'Dodi', 'dodi@example.com', 'password4', '2024-04-01'),
(5, 'Evi', 'evi@example.com', 'password5', '2024-05-01');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pesanan`
--

CREATE TABLE `pesanan` (
  `id_pesanan` int(11) NOT NULL,
  `id_pengguna` int(11) DEFAULT NULL,
  `tanggal_pesanan` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `total_harga` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pesanan`
--

INSERT INTO `pesanan` (`id_pesanan`, `id_pengguna`, `tanggal_pesanan`, `status`, `total_harga`) VALUES
(1, 1, '2024-06-01', 'Selesai', 150000.00),
(2, 2, '2024-06-02', 'Selesai', 250000.00),
(3, 3, '2024-06-03', 'Dikirim', 300000.00),
(4, 4, '2024-06-04', 'Dibatalkan', 100000.00),
(5, 5, '2024-06-05', 'Diproses', 50000.00),
(6, 1, '2024-07-01', 'Selesai', 200000.00),
(7, 2, '2024-07-10', 'Diproses', 150000.00);

--
-- Trigger `pesanan`
--
DELIMITER $$
CREATE TRIGGER `after_delete_pesanan` AFTER DELETE ON `pesanan` FOR EACH ROW BEGIN
    INSERT INTO log_table (action_type, table_name, old_values)
    VALUES ('DELETE', 'pesanan', CONCAT('ID: ', OLD.id_pesanan, ', User ID: ', OLD.id_pengguna, ', Status: ', OLD.status));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_pesanan` AFTER INSERT ON `pesanan` FOR EACH ROW BEGIN
    INSERT INTO log_table (action_type, table_name, new_values)
    VALUES ('INSERT', 'pesanan', CONCAT('ID: ', NEW.id_pesanan, ', User ID: ', NEW.id_pengguna, ', Status: ', NEW.status));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_pesanan` AFTER UPDATE ON `pesanan` FOR EACH ROW BEGIN
    INSERT INTO log_table (action_type, table_name, old_values, new_values)
    VALUES ('UPDATE', 'pesanan', CONCAT('ID: ', OLD.id_pesanan, ', User ID: ', OLD.id_pengguna, ', Status: ', OLD.status),
                 CONCAT('ID: ', NEW.id_pesanan, ', User ID: ', NEW.id_pengguna, ', Status: ', NEW.status));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pesanan_produk`
--

CREATE TABLE `pesanan_produk` (
  `id_pesanan` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `kuantitas` int(11) DEFAULT NULL,
  `harga_satuan` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pesanan_produk`
--

INSERT INTO `pesanan_produk` (`id_pesanan`, `id_produk`, `kuantitas`, `harga_satuan`) VALUES
(1, 1, 2, 50000.00),
(1, 2, 1, 100000.00),
(2, 3, 2, 150000.00),
(3, 4, 1, 200000.00),
(4, 5, 1, 250000.00),
(5, 1, 1, 50000.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk`
--

CREATE TABLE `produk` (
  `id_produk` int(11) NOT NULL,
  `nama_produk` varchar(50) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `produk`
--

INSERT INTO `produk` (`id_produk`, `nama_produk`, `deskripsi`, `harga`, `stok`) VALUES
(1, 'Produk A', 'Deskripsi Produk A', 350000.00, 100),
(2, 'Produk B', 'Deskripsi Produk B', 100000.00, 50),
(3, 'Produk C', 'Deskripsi Produk C', 150000.00, 30),
(4, 'Produk D', 'Deskripsi Produk D', 200000.00, 20),
(5, 'Produk E', 'Deskripsi Produk E', 250000.00, 10),
(6, 'Produk G', 'Deskripsi Produk G', 350000.00, 10);

--
-- Trigger `produk`
--
DELIMITER $$
CREATE TRIGGER `before_delete_produk` BEFORE DELETE ON `produk` FOR EACH ROW BEGIN
    INSERT INTO log_table (action_type, table_name, old_values)
    VALUES ('DELETE', 'produk', CONCAT('ID: ', OLD.id_produk, ', Name: ', OLD.nama_produk, ', Price: ', OLD.harga));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_produk` BEFORE INSERT ON `produk` FOR EACH ROW BEGIN
    INSERT INTO log_table (action_type, table_name, new_values)
    VALUES ('INSERT', 'produk', CONCAT('ID: ', NEW.id_produk, ', Name: ', NEW.nama_produk, ', Price: ', NEW.harga));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_produk` BEFORE UPDATE ON `produk` FOR EACH ROW BEGIN
    INSERT INTO log_table (action_type, table_name, old_values, new_values)
    VALUES ('UPDATE', 'produk', CONCAT('ID: ', OLD.id_produk, ', Name: ', OLD.nama_produk, ', Price: ', OLD.harga),
                 CONCAT('ID: ', NEW.id_produk, ', Name: ', NEW.nama_produk, ', Price: ', NEW.harga));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `profil`
--

CREATE TABLE `profil` (
  `id_profil` int(11) NOT NULL,
  `id_pengguna` int(11) DEFAULT NULL,
  `alamat` varchar(100) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `jenis_kelamin` enum('L','P') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `profil`
--

INSERT INTO `profil` (`id_profil`, `id_pengguna`, `alamat`, `telepon`, `tanggal_lahir`, `jenis_kelamin`) VALUES
(1, 1, 'Jl. Merdeka 1', '081234567891', '1990-01-01', 'L'),
(2, 2, 'Jl. Merdeka 2', '081234567892', '1991-02-01', 'L'),
(3, 3, 'Jl. Merdeka 3', '081234567893', '1992-03-01', 'P'),
(4, 4, 'Jl. Merdeka 4', '081234567894', '1993-04-01', 'L'),
(5, 5, 'Jl. Merdeka 5', '081234567895', '1994-05-01', 'P');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_high_value_pesanan`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_high_value_pesanan` (
`id_pesanan` int(11)
,`id_pengguna` int(11)
,`tanggal_pesanan` date
,`status` varchar(20)
,`total_harga` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_horizontal_pesanan`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_horizontal_pesanan` (
`id_pesanan` int(11)
,`tanggal_pesanan` date
,`status` varchar(20)
,`total_harga` decimal(10,2)
,`nama_pengguna` varchar(50)
,`email_pengguna` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_pesanan_summary`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_pesanan_summary` (
`id_pengguna` int(11)
,`jumlah_pesanan` bigint(21)
,`total_harga` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_vertical_pengguna`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_vertical_pengguna` (
`id_pengguna` int(11)
,`nama` varchar(50)
,`email` varchar(50)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_high_value_pesanan`
--
DROP TABLE IF EXISTS `vw_high_value_pesanan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_high_value_pesanan`  AS SELECT `pesanan`.`id_pesanan` AS `id_pesanan`, `pesanan`.`id_pengguna` AS `id_pengguna`, `pesanan`.`tanggal_pesanan` AS `tanggal_pesanan`, `pesanan`.`status` AS `status`, `pesanan`.`total_harga` AS `total_harga` FROM `pesanan` WHERE `pesanan`.`total_harga` > 100000WITH CASCADEDCHECK OPTION  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_horizontal_pesanan`
--
DROP TABLE IF EXISTS `vw_horizontal_pesanan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_horizontal_pesanan`  AS SELECT `p`.`id_pesanan` AS `id_pesanan`, `p`.`tanggal_pesanan` AS `tanggal_pesanan`, `p`.`status` AS `status`, `p`.`total_harga` AS `total_harga`, `u`.`nama` AS `nama_pengguna`, `u`.`email` AS `email_pengguna` FROM (`pesanan` `p` join `pengguna` `u` on(`p`.`id_pengguna` = `u`.`id_pengguna`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_pesanan_summary`
--
DROP TABLE IF EXISTS `vw_pesanan_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_pesanan_summary`  AS SELECT `vw_high_value_pesanan`.`id_pengguna` AS `id_pengguna`, count(`vw_high_value_pesanan`.`id_pesanan`) AS `jumlah_pesanan`, sum(`vw_high_value_pesanan`.`total_harga`) AS `total_harga` FROM `vw_high_value_pesanan` GROUP BY `vw_high_value_pesanan`.`id_pengguna` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_vertical_pengguna`
--
DROP TABLE IF EXISTS `vw_vertical_pengguna`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_vertical_pengguna`  AS SELECT `pengguna`.`id_pengguna` AS `id_pengguna`, `pengguna`.`nama` AS `nama`, `pengguna`.`email` AS `email` FROM `pengguna` ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `index_table`
--
ALTER TABLE `index_table`
  ADD PRIMARY KEY (`id`,`category`),
  ADD KEY `idx_value` (`value`),
  ADD KEY `idx_category` (`category`);

--
-- Indeks untuk tabel `log_table`
--
ALTER TABLE `log_table`
  ADD PRIMARY KEY (`log_id`);

--
-- Indeks untuk tabel `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`);

--
-- Indeks untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id_pesanan`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indeks untuk tabel `pesanan_produk`
--
ALTER TABLE `pesanan_produk`
  ADD PRIMARY KEY (`id_pesanan`,`id_produk`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indeks untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_produk`);

--
-- Indeks untuk tabel `profil`
--
ALTER TABLE `profil`
  ADD PRIMARY KEY (`id_profil`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `log_table`
--
ALTER TABLE `log_table`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id_pesanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `produk`
--
ALTER TABLE `produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `profil`
--
ALTER TABLE `profil`
  MODIFY `id_profil` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`);

--
-- Ketidakleluasaan untuk tabel `pesanan_produk`
--
ALTER TABLE `pesanan_produk`
  ADD CONSTRAINT `pesanan_produk_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`),
  ADD CONSTRAINT `pesanan_produk_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Ketidakleluasaan untuk tabel `profil`
--
ALTER TABLE `profil`
  ADD CONSTRAINT `profil_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`);
--
-- Database: `crud_mhs_4800`
--
CREATE DATABASE IF NOT EXISTS `crud_mhs_4800` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `crud_mhs_4800`;

-- --------------------------------------------------------

--
-- Struktur dari tabel `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `admin_password` varchar(20) NOT NULL,
  `admin_email` varchar(50) NOT NULL,
  `admin_nama` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `admin`
--

INSERT INTO `admin` (`admin_id`, `admin_password`, `admin_email`, `admin_nama`) VALUES
(1, '123', 'ada@gmailcom', 'udin');

-- --------------------------------------------------------

--
-- Struktur dari tabel `berita`
--

CREATE TABLE `berita` (
  `berita_id` int(11) NOT NULL,
  `berita_judul` varchar(150) NOT NULL,
  `berita_isi` text NOT NULL,
  `berita_gambar` varchar(100) DEFAULT NULL,
  `berita_tanggal` date NOT NULL,
  `user_nama` varchar(20) NOT NULL,
  `admin_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `berita`
--

INSERT INTO `berita` (`berita_id`, `berita_judul`, `berita_isi`, `berita_gambar`, `berita_tanggal`, `user_nama`, `admin_id`) VALUES
(8, 'qawdadsad', 'qwdsafdw3 v2', 'uploads/1719371282_754355130.jpg', '2024-06-26', 'asep', 1),
(9, 'qawdadsad', 'adxasdas', 'uploads/1719371292_754355130.jpg', '2024-06-14', 'asep', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `user_nama` varchar(25) NOT NULL,
  `user_password` varchar(25) NOT NULL,
  `user_namalengkap` varchar(50) NOT NULL,
  `user_email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`user_nama`, `user_password`, `user_namalengkap`, `user_email`) VALUES
('asep', '123', 'asep suaji', 'asep@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indeks untuk tabel `berita`
--
ALTER TABLE `berita`
  ADD PRIMARY KEY (`berita_id`),
  ADD KEY `user_nama` (`user_nama`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_nama`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `berita`
--
ALTER TABLE `berita`
  MODIFY `berita_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `berita`
--
ALTER TABLE `berita`
  ADD CONSTRAINT `admin_id` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`),
  ADD CONSTRAINT `user_nama` FOREIGN KEY (`user_nama`) REFERENCES `user` (`user_nama`);
--
-- Database: `data_perpus`
--
CREATE DATABASE IF NOT EXISTS `data_perpus` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `data_perpus`;

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_pinjam`
--

CREATE TABLE `log_pinjam` (
  `id_log` int(11) NOT NULL,
  `id_buku` varchar(10) NOT NULL,
  `id_anggota` varchar(10) NOT NULL,
  `tgl_pinjam` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `log_pinjam`
--

INSERT INTO `log_pinjam` (`id_log`, `id_buku`, `id_anggota`, `tgl_pinjam`) VALUES
(1, 'B001', 'A001', '2020-06-23'),
(2, 'B002', 'A001', '2020-06-25'),
(3, 'B003', 'A002', '2020-06-01'),
(4, 'B002', 'A005', '2020-06-23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_anggota`
--

CREATE TABLE `tb_anggota` (
  `id_anggota` varchar(10) NOT NULL,
  `nama` varchar(20) NOT NULL,
  `jekel` enum('Laki-laki','Perempuan') NOT NULL,
  `kelas` varchar(50) NOT NULL,
  `no_hp` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `tb_anggota`
--

INSERT INTO `tb_anggota` (`id_anggota`, `nama`, `jekel`, `kelas`, `no_hp`) VALUES
('A001', 'Ana', 'Perempuan', 'juwana', '089987789000'),
('A002', 'Bagus', 'Laki-laki', 'demak', '089987789098'),
('A003', 'Citra', 'Perempuan', 'demak', '085878526048'),
('A004', 'Didik', 'Laki-laki', 'pati', '087789987654'),
('A005', 'Edi', 'Laki-laki', 'demak', '089987789098');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_buku`
--

CREATE TABLE `tb_buku` (
  `id_buku` varchar(10) NOT NULL,
  `judul_buku` varchar(30) NOT NULL,
  `pengarang` varchar(30) NOT NULL,
  `penerbit` varchar(30) NOT NULL,
  `th_terbit` year(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `tb_buku`
--

INSERT INTO `tb_buku` (`id_buku`, `judul_buku`, `pengarang`, `penerbit`, `th_terbit`) VALUES
('B001', 'Matematika', 'anastasya', 'armi print', '2010'),
('B002', 'RPL 2', 'Eko', 'UMK', '2020'),
('B003', 'C++', 'Anton', 'Toni Perc', '2010'),
('B004', 'CI 4', 'anastasya', 'armi print', '2009'),
('B005', 'Data Mining', 'Anton', 'Toni Perc', '2020');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_pengguna`
--

CREATE TABLE `tb_pengguna` (
  `id_pengguna` int(11) NOT NULL,
  `nama_pengguna` varchar(20) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(15) NOT NULL,
  `level` enum('Administrator','Petugas','','') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `tb_pengguna`
--

INSERT INTO `tb_pengguna` (`id_pengguna`, `nama_pengguna`, `username`, `password`, `level`) VALUES
(1, 'M ivan S', 'admin', '202cb962ac59075', 'Administrator'),
(5, 'Mivan', 'ivan', '123', 'Administrator'),
(6, 'azz', 'azz', 'azz', 'Administrator'),
(7, 'qwe', 'qwe', 'qwe', 'Petugas');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_sirkulasi`
--

CREATE TABLE `tb_sirkulasi` (
  `id_sk` varchar(20) NOT NULL,
  `id_buku` varchar(10) NOT NULL,
  `id_anggota` varchar(10) NOT NULL,
  `tgl_pinjam` date NOT NULL,
  `tgl_kembali` date NOT NULL,
  `status` enum('PIN','KEM') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `tb_sirkulasi`
--

INSERT INTO `tb_sirkulasi` (`id_sk`, `id_buku`, `id_anggota`, `tgl_pinjam`, `tgl_kembali`, `status`) VALUES
('S001', 'B001', 'A001', '2020-06-23', '2020-06-30', 'KEM'),
('S002', 'B002', 'A001', '2020-06-13', '2020-06-20', 'PIN'),
('S003', 'B003', 'A002', '2020-06-22', '2020-06-29', 'PIN'),
('S004', 'B002', 'A005', '2020-06-23', '2020-06-30', 'PIN');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `log_pinjam`
--
ALTER TABLE `log_pinjam`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_anggota` (`id_anggota`),
  ADD KEY `id_buku` (`id_buku`);

--
-- Indeks untuk tabel `tb_anggota`
--
ALTER TABLE `tb_anggota`
  ADD PRIMARY KEY (`id_anggota`);

--
-- Indeks untuk tabel `tb_buku`
--
ALTER TABLE `tb_buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indeks untuk tabel `tb_pengguna`
--
ALTER TABLE `tb_pengguna`
  ADD PRIMARY KEY (`id_pengguna`);

--
-- Indeks untuk tabel `tb_sirkulasi`
--
ALTER TABLE `tb_sirkulasi`
  ADD PRIMARY KEY (`id_sk`),
  ADD KEY `id_buku` (`id_buku`),
  ADD KEY `id_anggota` (`id_anggota`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `log_pinjam`
--
ALTER TABLE `log_pinjam`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `tb_pengguna`
--
ALTER TABLE `tb_pengguna`
  MODIFY `id_pengguna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `log_pinjam`
--
ALTER TABLE `log_pinjam`
  ADD CONSTRAINT `log_pinjam_ibfk_1` FOREIGN KEY (`id_anggota`) REFERENCES `tb_anggota` (`id_anggota`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `log_pinjam_ibfk_2` FOREIGN KEY (`id_buku`) REFERENCES `tb_buku` (`id_buku`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `tb_sirkulasi`
--
ALTER TABLE `tb_sirkulasi`
  ADD CONSTRAINT `tb_sirkulasi_ibfk_1` FOREIGN KEY (`id_buku`) REFERENCES `tb_buku` (`id_buku`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tb_sirkulasi_ibfk_2` FOREIGN KEY (`id_anggota`) REFERENCES `tb_anggota` (`id_anggota`) ON DELETE CASCADE ON UPDATE CASCADE;
--
-- Database: `db_perpustakaan`
--
CREATE DATABASE IF NOT EXISTS `db_perpustakaan` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `db_perpustakaan`;

-- --------------------------------------------------------

--
-- Struktur dari tabel `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul_buku` varchar(125) DEFAULT NULL,
  `kategori_buku` varchar(125) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `penerbit_buku` varchar(125) DEFAULT NULL,
  `pengarang` varchar(125) DEFAULT NULL,
  `tahun_terbit` varchar(125) DEFAULT NULL,
  `isbn` int(50) DEFAULT NULL,
  `jumlah_buku` varchar(125) DEFAULT NULL,
  `averageRating` varchar(125) DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  `language` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `buku`
--

INSERT INTO `buku` (`id_buku`, `judul_buku`, `kategori_buku`, `deskripsi`, `penerbit_buku`, `pengarang`, `tahun_terbit`, `isbn`, `jumlah_buku`, `averageRating`, `img`, `language`) VALUES
(50, 'Harry Potter dan Orde Phoenix', 'Novel', '', 'Gramedia Pustaka Utama', 'J. K. Rowling', '2004', 2147483647, '1', '4.5', 'http://books.google.com/books/content?id=qCLFw5injs8C&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE71zJdlo7Yk04B4i-Ni7cSl1rEjOZWXTxkr2l-oaGkwhQEin5OZCFsnC8Ql_SKTU9J42feUC13kg6kv6MukG7IGvawh_PVztAz96dW3vBAUDVF5FDyQYWGJiQjnnbIsahpHs_YhR&source=gbs_', 'id'),
(51, 'Harry Potter dan Relikui Kematian', 'Novel', '', 'Gramedia Pustaka Utama', 'JK Rowling', '2008', 2147483647, '10', '4.5', 'http://books.google.com/books/content?id=3sSVzLsHIb8C&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE70VDcEIO1aZRptHuuchn2bUo0wKbktpKlytt7BVkckm2y0pemh0tSlb_Cw0STMEyOKf1jzRVVV5vtltYWIK-ZdYTiN50iIWF8uVUZGrmR8zl9Rgn7b5r1vFjC6ed9j5Rnzl0_RN&source=gbs_', 'id');

-- --------------------------------------------------------

--
-- Struktur dari tabel `identitas`
--

CREATE TABLE `identitas` (
  `id_identitas` int(11) NOT NULL,
  `nama_app` varchar(50) NOT NULL,
  `alamat_app` text NOT NULL,
  `email_app` varchar(125) NOT NULL,
  `nomor_hp` char(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `identitas`
--

INSERT INTO `identitas` (`id_identitas`, `nama_app`, `alamat_app`, `email_app`, `nomor_hp`) VALUES
(1, 'E-LIBRARY', 'Jl. Ring Road Utara, Ngringin, Condongcatur, Kec. Depok, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55281', 'ELIBRARY@e-library.com', '628122154566');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int(11) NOT NULL,
  `kode_kategori` varchar(50) NOT NULL,
  `nama_kategori` varchar(125) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `kode_kategori`, `nama_kategori`) VALUES
(2, 'KT-002', 'Cergam'),
(3, 'KT-003', 'Ensiklopedi'),
(4, 'KT-004', 'Biografi'),
(7, 'KT-007', 'Tafsir'),
(9, 'KT-009', 'Majalah'),
(10, 'KT-010', 'Antologi'),
(11, 'KT-011', 'Novel');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pemberitahuan`
--

CREATE TABLE `pemberitahuan` (
  `id_pemberitahuan` int(11) NOT NULL,
  `isi_pemberitahuan` varchar(255) NOT NULL,
  `level_user` varchar(125) NOT NULL,
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int(11) NOT NULL,
  `id_buku` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `tanggal_pinjam` date NOT NULL,
  `tanggal_kembali` date DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `denda` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `penerbit`
--

CREATE TABLE `penerbit` (
  `id_penerbit` int(11) NOT NULL,
  `kode_penerbit` varchar(125) NOT NULL,
  `nama_penerbit` varchar(50) NOT NULL,
  `verif_penerbit` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `penerbit`
--

INSERT INTO `penerbit` (`id_penerbit`, `kode_penerbit`, `nama_penerbit`, `verif_penerbit`) VALUES
(2, 'P002', 'Mizan Pustaka', 'Terverifikasi'),
(3, 'P003', 'Bentang Pustaka', 'Terverifikasi'),
(4, 'P004', 'Erlanggaz', 'Terverifikasi'),
(6, 'P006', 'Gramedia Prambanan', 'Terverifikasi');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengunjung`
--

CREATE TABLE `pengunjung` (
  `id_user` int(11) NOT NULL,
  `tanggal_kunjungan` date NOT NULL,
  `waktu_masuk` time NOT NULL,
  `waktu_keluar` time DEFAULT NULL,
  `keperluan` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengunjung`
--

INSERT INTO `pengunjung` (`id_user`, `tanggal_kunjungan`, `waktu_masuk`, `waktu_keluar`, `keperluan`) VALUES
(3, '2024-06-23', '23:02:00', '02:02:00', 'baca'),
(7, '2024-06-19', '03:03:00', '08:03:00', 'nh'),
(12, '2024-06-19', '23:38:00', '07:00:00', 'baca'),
(3, '2024-06-23', '23:02:00', '02:02:00', 'baca'),
(19, '2024-06-17', '12:10:00', '16:14:00', 'Membaca');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pesan`
--

CREATE TABLE `pesan` (
  `id_pesan` int(11) NOT NULL,
  `penerima` varchar(50) NOT NULL,
  `pengirim` varchar(50) NOT NULL,
  `judul_pesan` varchar(50) NOT NULL,
  `isi_pesan` text NOT NULL,
  `status` varchar(50) NOT NULL,
  `tanggal_kirim` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pesan`
--

INSERT INTO `pesan` (`id_pesan`, `penerima`, `pengirim`, `judul_pesan`, `isi_pesan`, `status`, `tanggal_kirim`) VALUES
(2, 'Fauzan Aditya Putra', 'Petugas', 'Pengembalian', 'terlambat', 'Sudah dibaca', '18-06-2024'),
(3, 'Reza  Saputra', 'Petugas', 'Pengembalian', 'kembali gak', 'Sudah dibaca', '18-06-2024'),
(6, 'Reza  Saputra', 'Administrator', 'Mengembalikan', 'as', 'Sudah dibaca', '25-06-2024');

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `kode_user` varchar(25) NOT NULL,
  `nis` char(20) NOT NULL,
  `fullname` varchar(125) NOT NULL,
  `username` varchar(50) NOT NULL,
  `notelp` int(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(50) NOT NULL,
  `kelas` varchar(50) NOT NULL,
  `alamat` varchar(225) NOT NULL,
  `verif` varchar(50) NOT NULL,
  `role` varchar(50) NOT NULL,
  `join_date` varchar(125) NOT NULL,
  `terakhir_login` varchar(125) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`id_user`, `kode_user`, `nis`, `fullname`, `username`, `notelp`, `email`, `password`, `kelas`, `alamat`, `verif`, `role`, `join_date`, `terakhir_login`) VALUES
(1, '-', '-', 'Administrator', 'admin', 0, '', 'admin', '-', '-', 'Iya', 'Admin', '04-05-2021', '09-07-2024 ( 12:25:22 )'),
(2, '-', '-', 'Petugas', 'petugas', 0, '', 'petugas', '-', '-', 'Iya', 'Petugas', '18-06-2024', '09-07-2024 ( 12:25:35 )'),
(3, 'AP001', '100011', 'Reza  Saputra', 'reza', 831232132, 'reza@gmail.com', 'Reza', 'XI - Farmasi', 'Desa Sambiroto, Kecamatan Tayu, Kabupatem Pati', 'Tidak', 'Anggota', '08-08-2022', '09-07-2024 ( 10:59:10 )'),
(4, 'AP002', '54353', 'Fauzan Aditya Putra', 'zan', 85321341, 'user@example.com', 'secret', 'X - Teknik Kendaraan Ringan', 'klaten', 'Tidak', 'Anggota', '2024-06-19', '08-07-2024 ( 16:14:34 )'),
(5, 'AP003', '200022', 'Dewi Lestari', 'dewi', 812345678, 'dewi@example.com', 'dewi123', 'Lulus', 'Jl. Mawar No. 10, Bandung', 'Tidak', 'Anggota', '2023-03-15', ''),
(6, 'AP004', '300033', 'Ahmad Syahid', 'ahmad', 856789012, 'ahmad@example.com', 'rahasia', 'Lulus', 'Surabaya', 'Tidak', 'Anggota', '2022-11-20', '2024-06-17 09:30:21'),
(7, 'AP005', '400044', 'Siti Nurjanah', 'siti', 899001122, 'siti@example.com', 'siti123', 'XI - Teknik Komputer dan Jaringan', 'Yogyakarta', 'Tidak', 'Anggota', '2023-01-10', ''),
(8, 'AP006', '500055', 'Rudi Setiawan', 'rudi', 877665544, 'rudi@example.com', 'rudi123', 'Lulus', 'Jakarta', 'Tidak', 'Anggota', '2022-09-25', '2024-06-18 11:45:36'),
(9, 'AP007', '600066', 'Lina Wijaya', 'lina', 878787878, 'lina@example.com', 'lina123', 'XI - Teknik Kendaraan Ringan', 'Bandung', 'Tidak', 'Anggota', '2022-12-05', ''),
(10, 'AP008', '700077', 'Fitri Indah', 'fitri', 889900112, 'fitri@example.com', 'fitri123', 'XII - Teknik Komputer dan Jaringan', 'Semarang', 'Tidak', 'Anggota', '2023-02-18', ''),
(11, 'AP009', '800088', 'Hendri Kurniawan', 'hendri', 877788899, 'hendri@example.com', 'hendri123', 'Lulus', 'Solo', 'Tidak', 'Anggota', '2022-10-30', '2024-06-19 08:20:15'),
(12, 'AP010', '900099', 'Nina Rahman', 'nina', 812345678, 'nina@example.com', 'nina123', 'Lulus', 'Malang', 'Tidak', 'Anggota', '2022-11-05', ''),
(13, 'AP011', '1000010', 'Budi Santoso', 'budi', 823456789, 'budi@example.com', 'budi123', 'XII - Teknik Sepeda Motor', 'Surakarta', 'Tidak', 'Anggota', '2023-04-22', '2024-06-18 14:55:10'),
(14, 'AP012', '1100011', 'Sari Wijaya', 'sari', 834567890, 'sari@example.com', 'sari123', 'XII - Perbankan', 'Jakarta Selatan', 'Tidak', 'Anggota', '2022-09-15', ''),
(15, 'AP013', '1200012', 'Rizki Pratama', 'rizki', 845678901, 'rizki@example.com', 'rizki123', 'Lulus', 'Bandung Barat', 'Tidak', 'Anggota', '2023-01-08', '2024-06-17 16:45:30'),
(16, 'AP014', '1300013', 'Wulan Sari', 'wulan', 856789012, 'wulan@example.com', 'wulan123', 'Lulus', 'Bekasi', 'Tidak', 'Anggota', '2022-12-10', ''),
(17, 'AP015', '1400014', 'Dedi Firmansyah', 'dedi', 867890123, 'dedi@example.com', 'dedi123', 'Lulus', 'Depok', 'Tidak', 'Anggota', '2023-03-28', '2024-06-18 09:10:25'),
(18, 'AP016', '1500015', 'Rini Cahyani', 'rini', 878901234, 'rini@example.com', 'rini123', 'Lulus', 'Tangerang', 'Tidak', 'Anggota', '2022-11-25', ''),
(19, 'AP017', '1600016', 'Aldi Nugroho', 'aldi', 889012345, 'aldi@example.com', 'aldi123', 'XI - Rekayasa Perangkat Lunak', 'Bogor', 'Tidak', 'Anggota', '2023-02-05', '2024-06-19 10:30:18'),
(28, 'AP019', '', 'qwer', 'qwer', 0, '', 'qwer', '', '', 'Tidak', 'Anggota', '08-07-2024', '08-07-2024 ( 23:46:32 )'),
(31, 'AP020', '22114789', 'Andre jangrek', 'andrr', 2147483647, 'andrea@gmail.com', '123', 'XII - Rekayasa Perangkat Lunak', 'Gupolo', 'Tidak', 'Anggota', '09-07-2024', '09-07-2024 ( 11:06:48 )'),
(32, 'AP021', '22114789', 'andreas', 'andre', 2147483647, 'qwe@s', 'andre', 'X - Farmasi', 'Klaten', 'Tidak', 'Anggota', '09-07-2024', '09-07-2024 ( 11:31:07 )');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indeks untuk tabel `identitas`
--
ALTER TABLE `identitas`
  ADD PRIMARY KEY (`id_identitas`);

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indeks untuk tabel `pemberitahuan`
--
ALTER TABLE `pemberitahuan`
  ADD PRIMARY KEY (`id_pemberitahuan`);

--
-- Indeks untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `id_buku` (`id_buku`),
  ADD KEY `id_user` (`id_user`);

--
-- Indeks untuk tabel `penerbit`
--
ALTER TABLE `penerbit`
  ADD PRIMARY KEY (`id_penerbit`);

--
-- Indeks untuk tabel `pengunjung`
--
ALTER TABLE `pengunjung`
  ADD KEY `id_user` (`id_user`);

--
-- Indeks untuk tabel `pesan`
--
ALTER TABLE `pesan`
  ADD PRIMARY KEY (`id_pesan`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT untuk tabel `identitas`
--
ALTER TABLE `identitas`
  MODIFY `id_identitas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `pemberitahuan`
--
ALTER TABLE `pemberitahuan`
  MODIFY `id_pemberitahuan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id_peminjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `penerbit`
--
ALTER TABLE `penerbit`
  MODIFY `id_penerbit` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `pesan`
--
ALTER TABLE `pesan`
  MODIFY `id_pesan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`),
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Ketidakleluasaan untuk tabel `pengunjung`
--
ALTER TABLE `pengunjung`
  ADD CONSTRAINT `pengunjung_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);
--
-- Database: `hr-mysql`
--
CREATE DATABASE IF NOT EXISTS `hr-mysql` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `hr-mysql`;

-- --------------------------------------------------------

--
-- Struktur dari tabel `countries`
--

CREATE TABLE `countries` (
  `country_id` char(2) NOT NULL,
  `country_name` varchar(40) DEFAULT NULL,
  `region_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `countries`
--

INSERT INTO `countries` (`country_id`, `country_name`, `region_id`) VALUES
('AR', 'Argentina', 2),
('AU', 'Australia', 3),
('BE', 'Belgium', 1),
('BR', 'Brazil', 2),
('CA', 'Canada', 2),
('CH', 'Switzerland', 1),
('CN', 'China', 3),
('DE', 'Germany', 1),
('DK', 'Denmark', 1),
('EG', 'Egypt', 4),
('FR', 'France', 1),
('HK', 'HongKong', 3),
('IL', 'Israel', 4),
('IN', 'India', 3),
('IT', 'Italy', 1),
('JP', 'Japan', 3),
('KW', 'Kuwait', 4),
('MX', 'Mexico', 2),
('NG', 'Nigeria', 4),
('NL', 'Netherlands', 1),
('SG', 'Singapore', 3),
('UK', 'United Kingdom', 1),
('US', 'United States of America', 2),
('ZM', 'Zambia', 4),
('ZW', 'Zimbabwe', 4);

-- --------------------------------------------------------

--
-- Struktur dari tabel `departments`
--

CREATE TABLE `departments` (
  `department_id` int(11) NOT NULL,
  `department_name` varchar(30) NOT NULL,
  `location_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `departments`
--

INSERT INTO `departments` (`department_id`, `department_name`, `location_id`) VALUES
(1, 'Administration', 1700),
(2, 'Marketing', 1800),
(3, 'Purchasing', 1700),
(4, 'Human Resources', 2400),
(5, 'Shipping', 1500),
(6, 'IT', 1400),
(7, 'Public Relations', 2700),
(8, 'Sales', 2500),
(9, 'Executive', 1700),
(10, 'Finance', 1700),
(11, 'Accounting', 1700);

-- --------------------------------------------------------

--
-- Struktur dari tabel `dependents`
--

CREATE TABLE `dependents` (
  `dependent_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `relationship` varchar(25) NOT NULL,
  `employee_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `dependents`
--

INSERT INTO `dependents` (`dependent_id`, `first_name`, `last_name`, `relationship`, `employee_id`) VALUES
(1, 'Penelope', 'Gietz', 'Child', 206),
(2, 'Nick', 'Higgins', 'Child', 205),
(3, 'Ed', 'Whalen', 'Child', 200),
(4, 'Jennifer', 'King', 'Child', 100),
(5, 'Johnny', 'Kochhar', 'Child', 101),
(6, 'Bette', 'De Haan', 'Child', 102),
(7, 'Grace', 'Faviet', 'Child', 109),
(8, 'Matthew', 'Chen', 'Child', 110),
(9, 'Joe', 'Sciarra', 'Child', 111),
(10, 'Christian', 'Urman', 'Child', 112),
(11, 'Zero', 'Popp', 'Child', 113),
(12, 'Karl', 'Greenberg', 'Child', 108),
(13, 'Uma', 'Mavris', 'Child', 203),
(14, 'Vivien', 'Hunold', 'Child', 103),
(15, 'Cuba', 'Ernst', 'Child', 104),
(16, 'Fred', 'Austin', 'Child', 105),
(17, 'Helen', 'Pataballa', 'Child', 106),
(18, 'Dan', 'Lorentz', 'Child', 107),
(19, 'Bob', 'Hartstein', 'Child', 201),
(20, 'Lucille', 'Fay', 'Child', 202),
(21, 'Kirsten', 'Baer', 'Child', 204),
(22, 'Elvis', 'Khoo', 'Child', 115),
(23, 'Sandra', 'Baida', 'Child', 116),
(24, 'Cameron', 'Tobias', 'Child', 117),
(25, 'Kevin', 'Himuro', 'Child', 118),
(26, 'Rip', 'Colmenares', 'Child', 119),
(27, 'Julia', 'Raphaely', 'Child', 114),
(28, 'Woody', 'Russell', 'Child', 145),
(29, 'Alec', 'Partners', 'Child', 146),
(30, 'Sandra', 'Taylor', 'Child', 176);

-- --------------------------------------------------------

--
-- Struktur dari tabel `employees`
--

CREATE TABLE `employees` (
  `employee_id` int(11) NOT NULL,
  `first_name` varchar(20) DEFAULT NULL,
  `last_name` varchar(25) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `hire_date` date NOT NULL,
  `job_id` int(11) NOT NULL,
  `salary` decimal(8,2) NOT NULL,
  `manager_id` int(11) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `employees`
--

INSERT INTO `employees` (`employee_id`, `first_name`, `last_name`, `email`, `phone_number`, `hire_date`, `job_id`, `salary`, `manager_id`, `department_id`) VALUES
(100, 'Steven', 'King', 'steven.king@sqltutorial.org', '515.123.4567', '1987-06-17', 4, 24000.00, NULL, 9),
(101, 'Neena', 'Kochhar', 'neena.kochhar@sqltutorial.org', '515.123.4568', '1989-09-21', 5, 17000.00, 100, 9),
(102, 'Lex', 'De Haan', 'lex.de \nhaan@sqltutorial.org', '515.123.4569', '1993-01-13', 5, 17000.00, 100, 9),
(103, 'Alexander', 'Hunold', 'alexander.hunold@sqltutorial.org', '590.423.4567', '1990-01-03', 9, 9000.00, 102, 6),
(104, 'Bruce', 'Ernst', 'bruce.ernst@sqltutorial.org', '590.423.4568', '1991-05-21', 9, 6000.00, 103, 6),
(105, 'David', 'Austin', 'david.austin@sqltutorial.org', '590.423.4569', '1997-06-25', 9, 4800.00, 103, 6),
(106, 'Valli', 'Pataballa', 'valli.pataballa@sqltutorial.org', '590.423.4560', '1998-02-05', 9, 4800.00, 103, 6),
(107, 'Diana', 'Lorentz', 'diana.lorentz@sqltutorial.org', '590.423.5567', '1999-02-07', 9, 4200.00, 103, 6),
(108, 'Nancy', 'Greenberg', 'nancy.greenberg@sqltutorial.org', '515.124.4569', '1994-08-17', 7, 12000.00, 101, 10),
(109, 'Daniel', 'Faviet', 'daniel.faviet@sqltutorial.org', '515.124.4169', '1994-08-16', 6, 9000.00, 108, 10),
(110, 'John', 'Chen', 'john.chen@sqltutorial.org', '515.124.4269', '1997-09-28', 6, 8200.00, 108, 10),
(111, 'Ismael', 'Sciarra', 'ismael.sciarra@sqltutorial.org', '515.124.4369', '1997-09-30', 6, 7700.00, 108, 10),
(112, 'Jose Manuel', 'Urman', 'jose \nmanuel.urman@sqltutorial.org', '515.124.4469', '1998-03-07', 6, 7800.00, 108, 10),
(113, 'Luis', 'Popp', 'luis.popp@sqltutorial.org', '515.124.4567', '1999-12-07', 6, 6900.00, 108, 10),
(114, 'Den', 'Raphaely', 'den.raphaely@sqltutorial.org', '515.127.4561', '1994-12-07', 14, 11000.00, 100, 3),
(115, 'Alexander', 'Khoo', 'alexander.khoo@sqltutorial.org', '515.127.4562', '1995-05-18', 13, 3100.00, 114, 3),
(116, 'Shelli', 'Baida', 'shelli.baida@sqltutorial.org', '515.127.4563', '1997-12-24', 13, 2900.00, 114, 3),
(117, 'Sigal', 'Tobias', 'sigal.tobias@sqltutorial.org', '515.127.4564', '1997-07-24', 13, 2800.00, 114, 3),
(118, 'Guy', 'Himuro', 'guy.himuro@sqltutorial.org', '515.127.4565', '1998-11-15', 13, 2600.00, 114, 3),
(119, 'Karen', 'Colmenares', 'karen.colmenares@sqltutorial.org', '515.127.4566', '1999-08-10', 13, 2500.00, 114, 3),
(120, 'Matthew', 'Weiss', 'matthew.weiss@sqltutorial.org', '650.123.1234', '1996-07-18', 19, 8000.00, 100, 5),
(121, 'Adam', 'Fripp', 'adam.fripp@sqltutorial.org', '650.123.2234', '1997-04-10', 19, 8200.00, 100, 5),
(122, 'Payam', 'Kaufling', 'payam.kaufling@sqltutorial.org', '650.123.3234', '1995-05-01', 19, 7900.00, 100, 5),
(123, 'Shanta', 'Vollman', 'shanta.vollman@sqltutorial.org', '650.123.4234', '1997-10-10', 19, 6500.00, 100, 5),
(126, 'Irene', 'Mikkilineni', 'irene.mikkilineni@sqltutorial.org', '650.124.1224', '1998-09-28', 18, 2700.00, 120, 5),
(145, 'John', 'Russell', 'john.russell@sqltutorial.org', NULL, '1996-10-01', 15, 14000.00, 100, 8),
(146, 'Karen', 'Partners', 'karen.partners@sqltutorial.org', NULL, '1997-01-05', 15, 13500.00, 100, 8),
(176, 'Jonathon', 'Taylor', 'jonathon.taylor@sqltutorial.org', NULL, '1998-03-24', 16, 8600.00, 100, 8),
(177, 'Jack', 'Livingston', 'jack.livingston@sqltutorial.org', NULL, '1998-04-23', 16, 8400.00, 100, 8),
(178, 'Kimberely', 'Grant', 'kimberely.grant@sqltutorial.org', NULL, '1999-05-24', 16, 7000.00, 100, 8),
(179, 'Charles', 'Johnson', 'charles.johnson@sqltutorial.org', NULL, '2000-01-04', 16, 6200.00, 100, 8),
(192, 'Sarah', 'Bell', 'sarah.bell@sqltutorial.org', '650.501.1876', '1996-02-04', 17, 4000.00, 123, 5),
(193, 'Britney', 'Everett', 'britney.everett@sqltutorial.org', '650.501.2876', '1997-03-03', 17, 3900.00, 123, 5),
(200, 'Jennifer', 'Whalen', 'jennifer.whalen@sqltutorial.org', '515.123.4444', '1987-09-17', 3, 4400.00, 101, 1),
(201, 'Michael', 'Hartstein', 'michael.hartstein@sqltutorial.org', '515.123.5555', '1996-02-17', 10, 13000.00, 100, 2),
(202, 'Pat', 'Fay', 'pat.fay@sqltutorial.org', '603.123.6666', '1997-08-17', 11, 6000.00, 201, 2),
(203, 'Susan', 'Mavris', 'susan.mavris@sqltutorial.org', '515.123.7777', '1994-06-07', 8, 6500.00, 101, 4),
(204, 'Hermann', 'Baer', 'hermann.baer@sqltutorial.org', '515.123.8888', '1994-06-07', 12, 10000.00, 101, 7),
(205, 'Shelley', 'Higgins', 'shelley.higgins@sqltutorial.org', '515.123.8080', '1994-06-07', 2, 12000.00, 101, 11),
(206, 'William', 'Gietz', 'william.gietz@sqltutorial.org', '515.123.8181', '1994-06-07', 1, 8300.00, 205, 11);

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `job_id` int(11) NOT NULL,
  `job_title` varchar(35) NOT NULL,
  `min_salary` decimal(8,2) DEFAULT NULL,
  `max_salary` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `jobs`
--

INSERT INTO `jobs` (`job_id`, `job_title`, `min_salary`, `max_salary`) VALUES
(1, 'Public Accountant', 4200.00, 9000.00),
(2, 'Accounting Manager', 8200.00, 16000.00),
(3, 'Administration Assistant', 3000.00, 6000.00),
(4, 'President', 20000.00, 40000.00),
(5, 'Administration Vice President', 15000.00, 30000.00),
(6, 'Accountant', 4200.00, 9000.00),
(7, 'Finance Manager', 8200.00, 16000.00),
(8, 'Human Resources Representative', 4000.00, 9000.00),
(9, 'Programmer', 4000.00, 10000.00),
(10, 'Marketing Manager', 9000.00, 15000.00),
(11, 'Marketing Representative', 4000.00, 9000.00),
(12, 'Public Relations Representative', 4500.00, 10500.00),
(13, 'Purchasing Clerk', 2500.00, 5500.00),
(14, 'Purchasing Manager', 8000.00, 15000.00),
(15, 'Sales Manager', 10000.00, 20000.00),
(16, 'Sales Representative', 6000.00, 12000.00),
(17, 'Shipping Clerk', 2500.00, 5500.00),
(18, 'Stock Clerk', 2000.00, 5000.00),
(19, 'Stock Manager', 5500.00, 8500.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `locations`
--

CREATE TABLE `locations` (
  `location_id` int(11) NOT NULL,
  `street_address` varchar(40) DEFAULT NULL,
  `postal_code` varchar(12) DEFAULT NULL,
  `city` varchar(30) NOT NULL,
  `state_province` varchar(25) DEFAULT NULL,
  `country_id` char(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `locations`
--

INSERT INTO `locations` (`location_id`, `street_address`, `postal_code`, `city`, `state_province`, `country_id`) VALUES
(1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US'),
(1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US'),
(1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US'),
(1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA'),
(2400, '8204 Arthur St', NULL, 'London', NULL, 'UK'),
(2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK'),
(2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE');

-- --------------------------------------------------------

--
-- Struktur dari tabel `regions`
--

CREATE TABLE `regions` (
  `region_id` int(11) NOT NULL,
  `region_name` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `regions`
--

INSERT INTO `regions` (`region_id`, `region_name`) VALUES
(1, 'Europe'),
(2, 'Americas'),
(3, 'Asia'),
(4, 'Middle East and Africa');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`country_id`),
  ADD KEY `region_id` (`region_id`);

--
-- Indeks untuk tabel `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`department_id`),
  ADD KEY `location_id` (`location_id`);

--
-- Indeks untuk tabel `dependents`
--
ALTER TABLE `dependents`
  ADD PRIMARY KEY (`dependent_id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Indeks untuk tabel `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`employee_id`),
  ADD KEY `job_id` (`job_id`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `manager_id` (`manager_id`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`job_id`);

--
-- Indeks untuk tabel `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`location_id`),
  ADD KEY `country_id` (`country_id`);

--
-- Indeks untuk tabel `regions`
--
ALTER TABLE `regions`
  ADD PRIMARY KEY (`region_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `departments`
--
ALTER TABLE `departments`
  MODIFY `department_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `dependents`
--
ALTER TABLE `dependents`
  MODIFY `dependent_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT untuk tabel `employees`
--
ALTER TABLE `employees`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=207;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `job_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT untuk tabel `locations`
--
ALTER TABLE `locations`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2701;

--
-- AUTO_INCREMENT untuk tabel `regions`
--
ALTER TABLE `regions`
  MODIFY `region_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `countries`
--
ALTER TABLE `countries`
  ADD CONSTRAINT `countries_ibfk_1` FOREIGN KEY (`region_id`) REFERENCES `regions` (`region_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `dependents`
--
ALTER TABLE `dependents`
  ADD CONSTRAINT `dependents_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `employees_ibfk_3` FOREIGN KEY (`manager_id`) REFERENCES `employees` (`employee_id`);

--
-- Ketidakleluasaan untuk tabel `locations`
--
ALTER TABLE `locations`
  ADD CONSTRAINT `locations_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`country_id`) ON DELETE CASCADE ON UPDATE CASCADE;
--
-- Database: `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(10) UNSIGNED NOT NULL,
  `dbase` varchar(255) NOT NULL DEFAULT '',
  `user` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `query` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

--
-- Dumping data untuk tabel `pma__recent`
--

INSERT INTO `pma__recent` (`username`, `tables`) VALUES
('root', '[{\"db\":\"db_perpustakaan\",\"table\":\"buku\"},{\"db\":\"db_perpustakaan\",\"table\":\"peminjaman\"},{\"db\":\"db_perpustakaan\",\"table\":\"penerbit\"},{\"db\":\"db_perpustakaan\",\"table\":\"pemberitahuan\"},{\"db\":\"db_perpustakaan\",\"table\":\"kategori\"},{\"db\":\"db_perpustakaan\",\"table\":\"user\"},{\"db\":\"db_perpustakaan\",\"table\":\"pesan\"},{\"db\":\"db_perpustakaan\",\"table\":\"identitas\"},{\"db\":\"db_perpustakaan\",\"table\":\"pengunjung\"},{\"db\":\"data_perpus\",\"table\":\"tb_buku\"}]');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Dumping data untuk tabel `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2024-06-25 08:37:14', '{\"Console\\/Mode\":\"collapse\"}');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Struktur dari tabel `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Indeks untuk tabel `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Indeks untuk tabel `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Indeks untuk tabel `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Indeks untuk tabel `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Indeks untuk tabel `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Indeks untuk tabel `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Indeks untuk tabel `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Indeks untuk tabel `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Indeks untuk tabel `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Indeks untuk tabel `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Indeks untuk tabel `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Indeks untuk tabel `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Indeks untuk tabel `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Indeks untuk tabel `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Indeks untuk tabel `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Indeks untuk tabel `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Indeks untuk tabel `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Database: `product_managements`
--
CREATE DATABASE IF NOT EXISTS `product_managements` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `product_managements`;

-- --------------------------------------------------------

--
-- Struktur dari tabel `concerns`
--

CREATE TABLE `concerns` (
  `concern_id` int(11) NOT NULL,
  `name` char(20) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `concerns`
--

INSERT INTO `concerns` (`concern_id`, `name`, `date_created`) VALUES
(1, 'Acne prone', '2022-06-27 06:58:19'),
(2, 'Darkspot', '2022-06-22 12:20:57'),
(3, 'Aging', '2022-06-22 12:20:57'),
(4, 'Hyperpigmentation', '2022-06-22 12:20:57'),
(5, 'Dry skin', '2022-06-22 12:20:57'),
(6, 'Sun Damage', '2022-06-27 06:58:10'),
(7, 'Pigmentation', '2022-06-27 06:58:10'),
(8, 'Redness', '2022-06-27 06:58:10'),
(9, 'Lost of elasticity', '2022-06-27 06:58:10'),
(10, 'Obvious pore', '2022-06-27 06:59:13');

-- --------------------------------------------------------

--
-- Struktur dari tabel `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `full_name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `province` char(25) NOT NULL,
  `district` char(30) NOT NULL,
  `sub_district` char(30) NOT NULL,
  `address` varchar(50) NOT NULL,
  `postal_code` char(6) NOT NULL,
  `join_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `customers`
--

INSERT INTO `customers` (`customer_id`, `full_name`, `email`, `province`, `district`, `sub_district`, `address`, `postal_code`, `join_date`) VALUES
(1, 'Nana Sarifa', 'nanasarifa@gmail.com', 'DIY', 'Gunung Kidul', 'Gedangsari', 'Jl. Ambar No. 21', '55863', '2022-07-25 08:51:20'),
(2, 'Arifa Hasanah', 'arifahasanah@gmail.com', 'DIY', 'Sleman', 'Depok', 'Jl. Ringroad Timur No. 11 Maguwoharjo', '55281', '2022-06-27 05:18:55'),
(3, 'Noni Rauda', 'nonirauda@gmail.com', 'DIY', 'Sleman', 'Godean', 'Jl. Hajaran No. 3', '55264', '2022-06-27 05:18:55'),
(4, 'Tatik Alita', 'tatikalita@gmail.com', 'Jambi', 'Batanghari', 'Maro Sebu Ulu', 'Jl. Gajahmada No. 19', '36652', '2022-07-14 03:59:35'),
(5, 'Rani Rudiani', 'ranirudiani@gmail.com', 'Gorontalo', 'Pahuwato', 'Lemito', 'Jl. Nuri N0.1', '96365', '2022-06-27 06:37:41'),
(6, 'Rudi Ananda', 'rudiananda@gmail.com', 'Kalimantan Selatan', 'Kotabaru', 'Pamukan', 'Jl. Poros Kalimantan Km. 20 Sengayam', '72169', '2022-06-27 06:39:38'),
(7, 'Rifa Fahriani', 'rifafahriani@gmail.com', 'Kalimantan Selatan', 'Kotabaru', 'Kelumpang Hilir', 'Jl. Merah Delima No. 20 Pelajau Baru', '72162', '2022-06-27 06:41:01'),
(8, 'Arina Handayani', 'arinahandayani@gmail.com', 'DKI Jakarta', 'Jakarta Utara', 'Cilincing', 'Jl. Nuri Km. 2', '14120', '2022-07-04 08:00:56'),
(9, 'Reefa Annisa', 'reefannisa@gmail.com', 'DKI Jakarta', 'Jakarta Selatan', 'Kebayoran Lama', 'Perum Ayodya 2 Blok D', '12240', '2022-07-04 08:00:56'),
(10, 'Ratri Wilujeng', 'ratriwi@gmail.com', 'DKI Jakarta', 'Jakarta Barat', 'Kebon Jeruk', 'Jl. Kasturi No. 34', '11530', '2022-07-04 08:00:56'),
(11, 'Shaliha Hasanah', 'salihasan@gmail.com', 'Jawa Tengah', 'Banjarnegara', 'Banjarnegara', 'Cendana RT 2 RW 10', '53418', '2022-07-04 08:53:54'),
(12, 'Novi Gavi', 'novigavi@gmail.com', 'DIY', 'Sleman', 'Wedomartani', 'Jl. Kayen Raya No. 20', '55584', '2022-07-04 08:53:54');

-- --------------------------------------------------------

--
-- Struktur dari tabel `products`
--

CREATE TABLE `products` (
  `product_id` char(10) NOT NULL,
  `name` char(50) NOT NULL,
  `size` int(11) DEFAULT NULL,
  `unit` char(5) DEFAULT NULL,
  `weight` varchar(20) DEFAULT NULL,
  `price` int(11) NOT NULL,
  `stock` int(10) NOT NULL,
  `discount_percentage` int(11) DEFAULT NULL,
  `halal_mui` char(20) DEFAULT NULL,
  `cruelty_free_status` char(3) DEFAULT NULL,
  `age_usage_from` int(11) DEFAULT NULL,
  `main_ingredient` varchar(100) DEFAULT NULL,
  `how_to_use` text DEFAULT NULL,
  `concern_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `products`
--

INSERT INTO `products` (`product_id`, `name`, `size`, `unit`, `weight`, `price`, `stock`, `discount_percentage`, `halal_mui`, `cruelty_free_status`, `age_usage_from`, `main_ingredient`, `how_to_use`, `concern_id`) VALUES
('AV002002', 'Avoskin Miraculous Refining Toner', 100, 'ml', '200gr', 195000, 20, 0, 'NA18181207654', 'YES', 16, 'AHA-BHA-PHA + Nicinamide + 2% Tea Tree + Witch Hazel and Aloe Vera', '\r\n\r\nFollow the steps of use and the following tips to get the benefits of the Miraculous Refining Toner product more optimally:\r\n- Pour Miraculous Refining Toner product on cotton or palms after cleansing facial skin.\r\n- Wipe from the center of the face outwards in an upward motion and let it absorb.\r\n- Rinse the next day, and don\'t forget to use your favorite sunscreen.\r\n\r\nTips:\r\n- Trying to use the product first on certain parts of the face is recommended for sensitive skin.\r\n- At the beginning of use, it is recommended to use it at night with a maximum frequency of use 3 times a week.\r\n- Keep out of eyes. If irritation occurs, discontinue use temporarily and it is recommended to immediately consult an expert.\r\n', 4),
('AV002102', 'Avoskin Retinol Toner', 100, 'ml', '350gr', 179000, 35, 0, 'NA18211205744', 'YES', 20, 'Water, Propylene Glycol, Niacinamide, Glycerin, Polysorbate 20, Phenoxyethanol, PEG-40 Hydrogenated ', '\r\nFollow these steps and tips to get the benefits of using Avoskin Miraculous Retinol Toner more optimally:\r\n- Pour an adequate amount of Miraculous Retinol Toner into your palms after cleansing your facial skin.\r\n- Apply from the center of the face outwards in an upward motion and let it absorb completely.\r\n- Rinse the next day, and don\'t forget to use your favorite sunscreen.\r\n\r\nTips:\r\n- Reduce the frequency of use if redness or irritation occurs.\r\n', 3),
('AV002201', 'Avoskin YSB Alpha Arbutin 3% + Grapeseed', 30, 'ml', '150gr', 139000, 200, 0, 'NA18202000279', 'YES', 15, 'Aqua, Alpha-Arbutin, Butylene Glycol, Glycerin, Hydroxyethyl Cellulose, Phenoxyethanol, Chlorphenesi', 'Apply a few drops to the face in the morning and evening. Massage the skin gently. For optimal results always use The Great Shield Sunscreen the next day.', 1),
('AV002202', 'Avoskin YSB Glow Concentrate Treatment 2', 45, 'ml', '150gr', 259000, 160, 0, 'NA182101019804', 'YES', 0, 'Water, Glycerin, Propanediol, 1,2-Hexanediol, Pentylene Glycol, Dicaprylyl Carbonate, Butylene Glyco', 'Pagi: Oleskan ke seluruh wajah hingga leher setelah penggunaan essence/serum. Lanjutkan dengan penggunaan sunscreen favoritmu.\r\nMalam: Oleskan ke seluruh wajah hingga leher pada step terakhir skincare routine sebelum tidur.', 5),
('AV002203', 'Avoskin YSB Niacinamide 12% + Centella Asiatica', 30, 'ml', '250gr', 139000, 70, 0, 'NA18202000278', 'YES', 15, 'Water, Niacinamide, Glycerin, Butylene Glycol, Biosaccharide gum-1, Hydroxyethyl Cellulose, Centella', 'Apply a few drops to the face in the morning and evening. Massage the skin gently.', 2),
('AV002301', 'Avoskin Natural Sublime Facial Cleanser', 100, 'ml', '200gr', 119000, 2300, 0, 'NA18211200915', 'YES', 15, 'Hyaluronic Acid, Marula Oil, Kale Extract, cactus Extract, Niacinamide, Pentavitin', 'Follow these usage steps to get the benefits of using Natural Sublime Facial Cleanser more optimally:\r\n- Wipe the soap on your hands and washing with water.\r\n- Apply it on your face with a circular massage.\r\n- Rinse with water until clean and now your skin is ready to use the next skincare.', 1);

--
-- Trigger `products`
--
DELIMITER $$
CREATE TRIGGER `after_insert_product` AFTER INSERT ON `products` FOR EACH ROW BEGIN
INSERT INTO product_log (product_id, activity,
date_created, by_who)
VALUES (NEW.product_id, 'INSERT', NOW(), USER());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `province`
--

CREATE TABLE `province` (
  `id` int(11) NOT NULL,
  `name` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `province`
--

INSERT INTO `province` (`id`, `name`) VALUES
(1, 'DIY'),
(2, 'Jambi'),
(3, 'Gorontalo');

-- --------------------------------------------------------

--
-- Struktur dari tabel `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `star` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `product_id` char(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `reviews`
--

INSERT INTO `reviews` (`review_id`, `content`, `star`, `customer_id`, `product_id`) VALUES
(1, 'Mantep banget sih di kulit aku', 5, 1, 'AV002002'),
(2, 'Abis cuci muka langseng keset dong', 5, 2, 'AV002301'),
(3, 'Cekit-cekit diawal pemakaian tapi setelah seminggu udah engga, hasil exfoliate-nya langsung berasa sih, kulitku jadi lebih halus dan cerah', 5, 4, 'AV002002'),
(4, 'Kalo kamu baru di dunia skincare dan pengen cobain produk yang ada retinolnya, produk ini recommended banget sih', 5, 4, 'AV002102');

-- --------------------------------------------------------

--
-- Struktur dari tabel `skin_type`
--

CREATE TABLE `skin_type` (
  `skin_type_id` int(11) NOT NULL,
  `name` char(30) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `skin_type`
--

INSERT INTO `skin_type` (`skin_type_id`, `name`, `date_created`) VALUES
(1, 'Dry', '2022-06-22 14:19:21'),
(2, 'Oily', '2022-06-22 14:19:21'),
(3, 'Combination', '2022-06-22 14:19:21'),
(4, 'Normal', '2022-06-27 07:00:35');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t1`
--

CREATE TABLE `t1` (
  `T_id` int(11) NOT NULL,
  `C1` varchar(20) DEFAULT NULL,
  `C2` int(11) DEFAULT NULL,
  `C3` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `concerns`
--
ALTER TABLE `concerns`
  ADD PRIMARY KEY (`concern_id`);

--
-- Indeks untuk tabel `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`),
  ADD KEY `idx_cust_join_date` (`join_date`);

--
-- Indeks untuk tabel `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `concern_id` (`concern_id`),
  ADD KEY `name_stock` (`name`,`stock`);

--
-- Indeks untuk tabel `province`
--
ALTER TABLE `province`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indeks untuk tabel `skin_type`
--
ALTER TABLE `skin_type`
  ADD PRIMARY KEY (`skin_type_id`);

--
-- Indeks untuk tabel `t1`
--
ALTER TABLE `t1`
  ADD PRIMARY KEY (`T_id`),
  ADD KEY `idx_c1` (`C1`),
  ADD KEY `idx_c1_c2` (`C1`,`C2`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `concerns`
--
ALTER TABLE `concerns`
  MODIFY `concern_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `province`
--
ALTER TABLE `province`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `skin_type`
--
ALTER TABLE `skin_type`
  MODIFY `skin_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`concern_id`) REFERENCES `concerns` (`concern_id`);

--
-- Ketidakleluasaan untuk tabel `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);
--
-- Database: `product_managements2`
--
CREATE DATABASE IF NOT EXISTS `product_managements2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `product_managements2`;

-- --------------------------------------------------------

--
-- Struktur dari tabel `concerns`
--

CREATE TABLE `concerns` (
  `concern_id` int(11) NOT NULL,
  `name` char(20) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `concerns`
--

INSERT INTO `concerns` (`concern_id`, `name`, `date_created`) VALUES
(1, 'Wrinkle', '2024-07-08 04:26:22'),
(2, 'Wrinkle', '2024-07-08 04:26:22'),
(3, 'Wrinkle', '2024-07-08 04:26:22'),
(4, 'Hyperpigmentation', '2022-06-22 12:20:57'),
(5, 'Dry skin', '2022-06-22 12:20:57'),
(6, 'Sun Damage', '2022-06-27 06:58:10'),
(7, 'Pigmentation', '2022-06-27 06:58:10'),
(8, 'Redness', '2022-06-27 06:58:10'),
(9, 'Lost of elasticity', '2022-06-27 06:58:10'),
(10, 'Obvious pore', '2022-06-27 06:59:13'),
(11, 'dark under eye', '2024-07-08 04:53:37');

--
-- Trigger `concerns`
--
DELIMITER $$
CREATE TRIGGER `after_update_concern` AFTER UPDATE ON `concerns` FOR EACH ROW BEGIN
INSERT concern_log VALUES
(OLD.concern_id,"UPDATE",OLD.name,NOW(),SESSION_USER());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `concern_log`
--

CREATE TABLE `concern_log` (
  `concern_id` int(11) NOT NULL,
  `activity` varchar(20) DEFAULT NULL,
  `old_name` varchar(200) DEFAULT NULL,
  `date_modified` date DEFAULT NULL,
  `who_is` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `concern_log`
--

INSERT INTO `concern_log` (`concern_id`, `activity`, `old_name`, `date_modified`, `who_is`) VALUES
(1, 'UPDATE', 'Acne prone', '2024-07-08', 'root@localhost'),
(2, 'UPDATE', 'Darkspot', '2024-07-08', 'root@localhost'),
(3, 'UPDATE', 'Aging', '2024-07-08', 'root@localhost');

-- --------------------------------------------------------

--
-- Struktur dari tabel `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `full_name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `province` char(25) NOT NULL,
  `district` char(30) NOT NULL,
  `sub_district` char(30) NOT NULL,
  `address` varchar(50) NOT NULL,
  `postal_code` char(6) NOT NULL,
  `join_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `customers`
--

INSERT INTO `customers` (`customer_id`, `full_name`, `email`, `province`, `district`, `sub_district`, `address`, `postal_code`, `join_date`) VALUES
(1, 'Nana Sarifa', 'nanasarifa@gmail.com', 'DIY', 'Gunung Kidul', 'Gedangsari', 'Jl. Ambar No. 21', '55863', '2022-07-25 08:51:20'),
(2, 'Arifa Hasanah', 'arifahasanah@gmail.com', 'DIY', 'Sleman', 'Depok', 'Jl. Ringroad Timur No. 11 Maguwoharjo', '55281', '2022-06-27 05:18:55'),
(3, 'Noni Rauda', 'nonirauda@gmail.com', 'DIY', 'Sleman', 'Godean', 'Jl. Hajaran No. 3', '55264', '2022-06-27 05:18:55'),
(4, 'Tatik Alita', 'tatikalita@gmail.com', 'Jambi', 'Batanghari', 'Maro Sebu Ulu', 'Jl. Gajahmada No. 19', '36652', '2022-07-14 03:59:35'),
(5, 'Rani Rudiani', 'ranirudiani@gmail.com', 'Gorontalo', 'Pahuwato', 'Lemito', 'Jl. Nuri N0.1', '96365', '2022-06-27 06:37:41'),
(6, 'Rudi Ananda', 'rudiananda@gmail.com', 'Kalimantan Selatan', 'Kotabaru', 'Pamukan', 'Jl. Poros Kalimantan Km. 20 Sengayam', '72169', '2022-06-27 06:39:38'),
(7, 'Rifa Fahriani', 'rifafahriani@gmail.com', 'Kalimantan Selatan', 'Kotabaru', 'Kelumpang Hilir', 'Jl. Merah Delima No. 20 Pelajau Baru', '72162', '2022-06-27 06:41:01'),
(8, 'Arina Handayani', 'arinahandayani@gmail.com', 'DKI Jakarta', 'Jakarta Utara', 'Cilincing', 'Jl. Nuri Km. 2', '14120', '2022-07-04 08:00:56'),
(9, 'Reefa Annisa', 'reefannisa@gmail.com', 'DKI Jakarta', 'Jakarta Selatan', 'Kebayoran Lama', 'Perum Ayodya 2 Blok D', '12240', '2022-07-04 08:00:56'),
(10, 'Ratri Wilujeng', 'ratriwi@gmail.com', 'DKI Jakarta', 'Jakarta Barat', 'Kebon Jeruk', 'Jl. Kasturi No. 34', '11530', '2022-07-04 08:00:56'),
(11, 'Shaliha Hasanah', 'salihasan@gmail.com', 'Jawa Tengah', 'Banjarnegara', 'Banjarnegara', 'Cendana RT 2 RW 10', '53418', '2022-07-04 08:53:54'),
(12, 'Novi Gavi', 'novigavi@gmail.com', 'DIY', 'Sleman', 'Wedomartani', 'Jl. Kayen Raya No. 20', '55584', '2022-07-04 08:53:54');

-- --------------------------------------------------------

--
-- Struktur dari tabel `products`
--

CREATE TABLE `products` (
  `product_id` char(10) NOT NULL,
  `name` char(50) NOT NULL,
  `size` int(11) DEFAULT NULL,
  `unit` char(5) DEFAULT NULL,
  `weight` varchar(20) DEFAULT NULL,
  `price` int(11) NOT NULL,
  `stock` int(10) NOT NULL,
  `discount_percentage` int(11) DEFAULT NULL,
  `halal_mui` char(20) DEFAULT NULL,
  `cruelty_free_status` char(3) DEFAULT NULL,
  `age_usage_from` int(11) DEFAULT NULL,
  `main_ingredient` varchar(100) DEFAULT NULL,
  `how_to_use` text DEFAULT NULL,
  `concern_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `products`
--

INSERT INTO `products` (`product_id`, `name`, `size`, `unit`, `weight`, `price`, `stock`, `discount_percentage`, `halal_mui`, `cruelty_free_status`, `age_usage_from`, `main_ingredient`, `how_to_use`, `concern_id`) VALUES
('', 'Avoskin Retinol Toner', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('AV002002', 'Avoskin Retinol Toner', 100, 'ml', '200gr', 195000, 20, 0, 'NA18181207654', 'YES', 16, 'AHA-BHA-PHA + Nicinamide + 2% Tea Tree + Witch Hazel and Aloe Vera', '\r\n\r\nFollow the steps of use and the following tips to get the benefits of the Miraculous Refining Toner product more optimally:\r\n- Pour Miraculous Refining Toner product on cotton or palms after cleansing facial skin.\r\n- Wipe from the center of the face outwards in an upward motion and let it absorb.\r\n- Rinse the next day, and don\'t forget to use your favorite sunscreen.\r\n\r\nTips:\r\n- Trying to use the product first on certain parts of the face is recommended for sensitive skin.\r\n- At the beginning of use, it is recommended to use it at night with a maximum frequency of use 3 times a week.\r\n- Keep out of eyes. If irritation occurs, discontinue use temporarily and it is recommended to immediately consult an expert.\r\n', 4),
('AV002102', 'Avoskin Retinol Toner', 100, 'ml', '350gr', 179000, 35, 0, 'NA18211205744', 'YES', 20, 'Water, Propylene Glycol, Niacinamide, Glycerin, Polysorbate 20, Phenoxyethanol, PEG-40 Hydrogenated ', '\r\nFollow these steps and tips to get the benefits of using Avoskin Miraculous Retinol Toner more optimally:\r\n- Pour an adequate amount of Miraculous Retinol Toner into your palms after cleansing your facial skin.\r\n- Apply from the center of the face outwards in an upward motion and let it absorb completely.\r\n- Rinse the next day, and don\'t forget to use your favorite sunscreen.\r\n\r\nTips:\r\n- Reduce the frequency of use if redness or irritation occurs.\r\n', 3),
('AV002201', 'Avoskin Retinol Toner', 30, 'ml', '150gr', 139000, 200, 0, 'NA18202000279', 'YES', 15, 'Aqua, Alpha-Arbutin, Butylene Glycol, Glycerin, Hydroxyethyl Cellulose, Phenoxyethanol, Chlorphenesi', 'Apply a few drops to the face in the morning and evening. Massage the skin gently. For optimal results always use The Great Shield Sunscreen the next day.', 1),
('AV002202', 'Avoskin Retinol Toner', 45, 'ml', '150gr', 259000, 160, 0, 'NA182101019804', 'YES', 0, 'Water, Glycerin, Propanediol, 1,2-Hexanediol, Pentylene Glycol, Dicaprylyl Carbonate, Butylene Glyco', 'Pagi: Oleskan ke seluruh wajah hingga leher setelah penggunaan essence/serum. Lanjutkan dengan penggunaan sunscreen favoritmu.\r\nMalam: Oleskan ke seluruh wajah hingga leher pada step terakhir skincare routine sebelum tidur.', 5),
('AV002203', 'Avoskin Retinol Toner', 30, 'ml', '250gr', 139000, 70, 0, 'NA18202000278', 'YES', 15, 'Water, Niacinamide, Glycerin, Butylene Glycol, Biosaccharide gum-1, Hydroxyethyl Cellulose, Centella', 'Apply a few drops to the face in the morning and evening. Massage the skin gently.', 2),
('AV002301', 'Avoskin Retinol Toner', 100, 'ml', '200gr', 119000, 2300, 0, 'NA18211200915', 'YES', 15, 'Hyaluronic Acid, Marula Oil, Kale Extract, cactus Extract, Niacinamide, Pentavitin', 'Follow these usage steps to get the benefits of using Natural Sublime Facial Cleanser more optimally:\r\n- Wipe the soap on your hands and washing with water.\r\n- Apply it on your face with a circular massage.\r\n- Rinse with water until clean and now your skin is ready to use the next skincare.', 1);

--
-- Trigger `products`
--
DELIMITER $$
CREATE TRIGGER `after_insert_product` AFTER INSERT ON `products` FOR EACH ROW BEGIN
INSERT INTO product_log (product_id, activity,
date_created, by_who)
VALUES (NEW.product_id, 'INSERT', NOW(), USER());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `product_log`
--

CREATE TABLE `product_log` (
  `activity` varchar(20) DEFAULT NULL,
  `date_created` date DEFAULT NULL,
  `by_who` varchar(50) DEFAULT NULL,
  `product_id` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `product_log`
--

INSERT INTO `product_log` (`activity`, `date_created`, `by_who`, `product_id`) VALUES
('INSERT', '2024-07-08', 'root@localhost', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `province`
--

CREATE TABLE `province` (
  `id` int(11) NOT NULL,
  `name` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `province`
--

INSERT INTO `province` (`id`, `name`) VALUES
(1, 'DIY'),
(2, 'Jambi'),
(3, 'Gorontalo');

-- --------------------------------------------------------

--
-- Struktur dari tabel `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `star` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `product_id` char(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `reviews`
--

INSERT INTO `reviews` (`review_id`, `content`, `star`, `customer_id`, `product_id`) VALUES
(1, 'Mantep banget sih di kulit aku', 5, 1, 'AV002002'),
(2, 'Abis cuci muka langseng keset dong', 5, 2, 'AV002301'),
(3, 'Cekit-cekit diawal pemakaian tapi setelah seminggu udah engga, hasil exfoliate-nya langsung berasa sih, kulitku jadi lebih halus dan cerah', 5, 4, 'AV002002'),
(4, 'Kalo kamu baru di dunia skincare dan pengen cobain produk yang ada retinolnya, produk ini recommended banget sih', 5, 4, 'AV002102');

-- --------------------------------------------------------

--
-- Struktur dari tabel `skin_type`
--

CREATE TABLE `skin_type` (
  `skin_type_id` int(11) NOT NULL,
  `name` char(30) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `skin_type`
--

INSERT INTO `skin_type` (`skin_type_id`, `name`, `date_created`) VALUES
(1, 'Dry', '2022-06-22 14:19:21'),
(2, 'Oily', '2022-06-22 14:19:21'),
(3, 'Combination', '2022-06-22 14:19:21'),
(4, 'Normal', '2022-06-27 07:00:35');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `v_customer_all`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `v_customer_all` (
`customer_id` int(11)
,`full_name` varchar(50)
,`address` varchar(50)
,`postal_code` char(6)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `v_customer_all`
--
DROP TABLE IF EXISTS `v_customer_all`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_customer_all`  AS SELECT `customers`.`customer_id` AS `customer_id`, `customers`.`full_name` AS `full_name`, `customers`.`address` AS `address`, `customers`.`postal_code` AS `postal_code` FROM `customers` WHERE `customers`.`postal_code` = 55264 ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `concerns`
--
ALTER TABLE `concerns`
  ADD PRIMARY KEY (`concern_id`);

--
-- Indeks untuk tabel `concern_log`
--
ALTER TABLE `concern_log`
  ADD PRIMARY KEY (`concern_id`);

--
-- Indeks untuk tabel `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`),
  ADD KEY `idx_cust_join_date` (`join_date`);

--
-- Indeks untuk tabel `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `concern_id` (`concern_id`);

--
-- Indeks untuk tabel `province`
--
ALTER TABLE `province`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indeks untuk tabel `skin_type`
--
ALTER TABLE `skin_type`
  ADD PRIMARY KEY (`skin_type_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `concerns`
--
ALTER TABLE `concerns`
  MODIFY `concern_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `province`
--
ALTER TABLE `province`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `skin_type`
--
ALTER TABLE `skin_type`
  MODIFY `skin_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`concern_id`) REFERENCES `concerns` (`concern_id`);

--
-- Ketidakleluasaan untuk tabel `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);
--
-- Database: `projek_perpus`
--
CREATE DATABASE IF NOT EXISTS `projek_perpus` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `projek_perpus`;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_biaya_denda`
--

CREATE TABLE `tbl_biaya_denda` (
  `id_biaya_denda` int(11) NOT NULL,
  `harga_denda` varchar(255) NOT NULL,
  `stat` varchar(255) NOT NULL,
  `tgl_tetap` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tbl_biaya_denda`
--

INSERT INTO `tbl_biaya_denda` (`id_biaya_denda`, `harga_denda`, `stat`, `tgl_tetap`) VALUES
(1, '4000', 'Aktif', '2019-11-23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_buku`
--

CREATE TABLE `tbl_buku` (
  `id_buku` int(11) NOT NULL,
  `buku_id` varchar(255) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `id_rak` int(11) NOT NULL,
  `sampul` varchar(255) DEFAULT NULL,
  `isbn` varchar(255) DEFAULT NULL,
  `lampiran` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `penerbit` varchar(255) DEFAULT NULL,
  `pengarang` varchar(255) DEFAULT NULL,
  `thn_buku` varchar(255) DEFAULT NULL,
  `isi` text DEFAULT NULL,
  `jml` int(11) DEFAULT NULL,
  `tgl_masuk` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tbl_buku`
--

INSERT INTO `tbl_buku` (`id_buku`, `buku_id`, `id_kategori`, `id_rak`, `sampul`, `isbn`, `lampiran`, `title`, `penerbit`, `pengarang`, `thn_buku`, `isi`, `jml`, `tgl_masuk`) VALUES
(8, 'BK008', 2, 1, '0', '132-123-234-231', '0', 'CARA MUDAH BELAJAR PEMROGRAMAN C++', 'INFORMATIKA BANDUNG', 'BUDI RAHARJO ', '2012', '<table class=\"table table-bordered\" style=\"background-color: rgb(255, 255, 255); width: 653px; color: rgb(51, 51, 51);\"><tbody><tr><td style=\"padding: 8px; line-height: 1.42857; border-color: rgb(244, 244, 244);\">Tipe Buku</td><td style=\"padding: 8px; line-height: 1.42857; border-color: rgb(244, 244, 244);\">Kertas</td></tr><tr><td style=\"padding: 8px; line-height: 1.42857; border-color: rgb(244, 244, 244);\">Bahasa</td><td style=\"padding: 8px; line-height: 1.42857; border-color: rgb(244, 244, 244);\">Indonesia</td></tr></tbody></table>', 23, '2019-11-23 11:49:57');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_denda`
--

CREATE TABLE `tbl_denda` (
  `id_denda` int(11) NOT NULL,
  `pinjam_id` varchar(255) NOT NULL,
  `denda` varchar(255) NOT NULL,
  `lama_waktu` int(11) NOT NULL,
  `tgl_denda` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tbl_denda`
--

INSERT INTO `tbl_denda` (`id_denda`, `pinjam_id`, `denda`, `lama_waktu`, `tgl_denda`) VALUES
(3, 'PJ001', '0', 0, '2020-05-20'),
(5, 'PJ009', '0', 0, '2020-05-20');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_kategori`
--

CREATE TABLE `tbl_kategori` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tbl_kategori`
--

INSERT INTO `tbl_kategori` (`id_kategori`, `nama_kategori`) VALUES
(2, 'Pemrograman');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_login`
--

CREATE TABLE `tbl_login` (
  `id_login` int(11) NOT NULL,
  `anggota_id` varchar(255) NOT NULL,
  `user` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `level` varchar(255) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `tempat_lahir` varchar(255) NOT NULL,
  `tgl_lahir` varchar(255) NOT NULL,
  `jenkel` varchar(255) NOT NULL,
  `alamat` text NOT NULL,
  `telepon` varchar(25) NOT NULL,
  `email` varchar(255) NOT NULL,
  `tgl_bergabung` varchar(255) NOT NULL,
  `foto` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tbl_login`
--

INSERT INTO `tbl_login` (`id_login`, `anggota_id`, `user`, `pass`, `level`, `nama`, `tempat_lahir`, `tgl_lahir`, `jenkel`, `alamat`, `telepon`, `email`, `tgl_bergabung`, `foto`) VALUES
(1, 'AG001', 'rianto', '202cb962ac59075b964b07152d234b70', 'Petugas', 'Rianto', 'Solo', '2000-05-10', 'Laki-Laki', 'Yogyakarta', '081234567890', 'rianto@gmail.com', '2019-11-20', 'user_1630303496.png'),
(2, 'AG002', 'violita', '202cb962ac59075b964b07152d234b70', 'Anggota', 'Violita', 'Pati', '2002-06-22', 'Perempuan', 'Pati', '082123456789', 'silvaniviolita@gmail.com', '2021-08-30', 'user_1630303816.png');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_pinjam`
--

CREATE TABLE `tbl_pinjam` (
  `id_pinjam` int(11) NOT NULL,
  `pinjam_id` varchar(255) NOT NULL,
  `anggota_id` varchar(255) NOT NULL,
  `buku_id` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `tgl_pinjam` varchar(255) NOT NULL,
  `lama_pinjam` int(11) NOT NULL,
  `tgl_balik` varchar(255) NOT NULL,
  `tgl_kembali` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tbl_pinjam`
--

INSERT INTO `tbl_pinjam` (`id_pinjam`, `pinjam_id`, `anggota_id`, `buku_id`, `status`, `tgl_pinjam`, `lama_pinjam`, `tgl_balik`, `tgl_kembali`) VALUES
(8, 'PJ001', 'AG002', 'BK008', 'Di Kembalikan', '2020-05-19', 1, '2020-05-20', '2020-05-20'),
(10, 'PJ009', 'AG002', 'BK008', 'Di Kembalikan', '2020-05-20', 1, '2020-05-21', '2020-05-20');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_rak`
--

CREATE TABLE `tbl_rak` (
  `id_rak` int(11) NOT NULL,
  `nama_rak` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tbl_rak`
--

INSERT INTO `tbl_rak` (`id_rak`, `nama_rak`) VALUES
(1, 'Rak Buku 1');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `tbl_biaya_denda`
--
ALTER TABLE `tbl_biaya_denda`
  ADD PRIMARY KEY (`id_biaya_denda`);

--
-- Indeks untuk tabel `tbl_buku`
--
ALTER TABLE `tbl_buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indeks untuk tabel `tbl_denda`
--
ALTER TABLE `tbl_denda`
  ADD PRIMARY KEY (`id_denda`);

--
-- Indeks untuk tabel `tbl_kategori`
--
ALTER TABLE `tbl_kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indeks untuk tabel `tbl_login`
--
ALTER TABLE `tbl_login`
  ADD PRIMARY KEY (`id_login`);

--
-- Indeks untuk tabel `tbl_pinjam`
--
ALTER TABLE `tbl_pinjam`
  ADD PRIMARY KEY (`id_pinjam`);

--
-- Indeks untuk tabel `tbl_rak`
--
ALTER TABLE `tbl_rak`
  ADD PRIMARY KEY (`id_rak`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `tbl_biaya_denda`
--
ALTER TABLE `tbl_biaya_denda`
  MODIFY `id_biaya_denda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `tbl_buku`
--
ALTER TABLE `tbl_buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `tbl_denda`
--
ALTER TABLE `tbl_denda`
  MODIFY `id_denda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `tbl_kategori`
--
ALTER TABLE `tbl_kategori`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `tbl_login`
--
ALTER TABLE `tbl_login`
  MODIFY `id_login` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `tbl_pinjam`
--
ALTER TABLE `tbl_pinjam`
  MODIFY `id_pinjam` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `tbl_rak`
--
ALTER TABLE `tbl_rak`
  MODIFY `id_rak` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- Database: `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
