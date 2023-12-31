CREATE TABLE penjualan (
	id_invoice VARCHAR(255),
	tanggal DATE,
	id_customer VARCHAR(255),
	id_barang VARCHAR(255),
	jumlah_barang INT,
	unit VARCHAR(255),
	harga INT,
	mata_uang VARCHAR(255)
);	

CREATE TABLE pelanggan (
	id_customer VARCHAR(255),
	level VARCHAR(255),
	nama VARCHAR(255),
	id_cabang_sales VARCHAR(255),
	cabang_sales VARCHAR(255),
	id_distributor VARCHAR(255),
	grup VARCHAR(255)
);

CREATE TABLE barang (
	kode_barang VARCHAR(255),
	nama_barang VARCHAR(255),
	kemasan VARCHAR(255),
	harga INT,
	nama_tipe VARCHAR(255),
	kode_brand INT,
	brand VARCHAR(255)
);

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/penjualan.csv'
INTO TABLE penjualan
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_invoice, @tanggal, id_customer, id_barang, jumlah_barang, unit, harga, mata_uang)
SET tanggal = STR_TO_DATE(@tanggal, '%d/%m/%y');

SELECT * FROM penjualan;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pelanggan.csv'
INTO TABLE pelanggan
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS; 

SELECT * FROM pelanggan;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/barang.csv'
INTO TABLE barang
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM barang;

CREATE TABLE base_table AS
SELECT
    CONCAT(CAST(pjl.id_invoice AS CHAR), pjl.id_barang) AS id_penjualan,
    pjl.id_invoice,
    pjl.tanggal,
    pjl.id_customer,
    pjl.id_barang,
    pjl.jumlah_barang,
    pjl.unit,
    pjl.harga,
    pjl.mata_uang,
    plg.level,
    plg.nama,
    plg.id_cabang_sales,
    plg.cabang_sales,
    plg.id_distributor,
    plg.grup,
    brg.kode_barang,
    brg.nama_barang,
    brg.kemasan,
    brg.nama_tipe,
    brg.kode_brand,
    brg.brand
FROM penjualan AS pjl
LEFT JOIN pelanggan AS plg ON plg.id_customer = pjl.id_customer
LEFT JOIN barang AS brg ON brg.kode_barang = pjl.id_barang;

SELECT * FROM base_table;

ALTER TABLE base_table ADD PRIMARY KEY(id_penjualan);

CREATE TABLE aggregate_table AS(SELECT
							   	id_penjualan,
							   	id_invoice,
							   	tanggal,
							   	id_customer,
						   		id_barang,
						   		jumlah_barang,
						   		harga,
							   	nama AS customer,
							   	id_cabang_sales,
						   		cabang_sales,
						   		id_distributor,
						   		grup,
						   		nama_barang AS barang,
						   		kemasan,
						   		nama_tipe,
						   		kode_brand,
						   		brand,
							   	SUM(jumlah_barang * harga) AS total_sales
							   FROM base_table
							   GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17
							  );

SELECT * FROM aggregate_table;



