/*==================  MASTER TABLES  ==================*/

CREATE TABLE restoran (
    id_restoran   NUMBER PRIMARY KEY,
    nama          VARCHAR2(100) NOT NULL,
    alamat        VARCHAR2(255) NOT NULL,
    no_telepon    VARCHAR2(20) CONSTRAINT ck_restoran_telp
                  CHECK (REGEXP_LIKE(no_telepon, '^\+?\d{10,15}$')),
    kapasitas     NUMBER CONSTRAINT ck_restoran_kapasitas CHECK (kapasitas > 0)
);

CREATE TABLE kasir (
    id_kasir     NUMBER PRIMARY KEY,
    nama         VARCHAR2(100) NOT NULL,
    shift        VARCHAR2(20) CONSTRAINT ck_kasir_shift
                 CHECK (shift IN ('Pagi', 'Siang', 'Malam')),
    email        VARCHAR2(255) UNIQUE,
    no_telepon   VARCHAR2(20) CONSTRAINT ck_kasir_telp
                 CHECK (REGEXP_LIKE(no_telepon, '^\+?\d{10,15}$'))
);

CREATE TABLE waiters (
    id_waiters   NUMBER PRIMARY KEY,
    nama         VARCHAR2(100) NOT NULL,
    shift        VARCHAR2(20) CONSTRAINT ck_waiters_shift
                 CHECK (shift IN ('Pagi', 'Siang', 'Malam')),
    email        VARCHAR2(255) UNIQUE,
    no_telepon   VARCHAR2(20) CONSTRAINT ck_waiters_telp
                 CHECK (REGEXP_LIKE(no_telepon, '^\+?\d{10,15}$'))
);

CREATE TABLE manager (
    id_manager   NUMBER PRIMARY KEY,
    nama         VARCHAR2(100) NOT NULL,
    shift        VARCHAR2(20) CONSTRAINT ck_manager_shift
                 CHECK (shift IN ('Pagi', 'Siang', 'Malam')),
    email        VARCHAR2(255) UNIQUE,
    no_telepon   VARCHAR2(20) CONSTRAINT ck_manager_telp
                 CHECK (REGEXP_LIKE(no_telepon, '^\+?\d{10,15}$')),
    id_restoran  NUMBER CONSTRAINT fk_manager_restoran
                 REFERENCES restoran(id_restoran)
);

CREATE TABLE chef (
    id_chef      NUMBER PRIMARY KEY,
    nama         VARCHAR2(100) NOT NULL,
    spesialis    VARCHAR2(100) NOT NULL,
    shift        VARCHAR2(20) CONSTRAINT ck_chef_shift
                 CHECK (shift IN ('Pagi', 'Siang', 'Malam')),
    no_telepon   VARCHAR2(20) CONSTRAINT ck_chef_telp
                 CHECK (REGEXP_LIKE(no_telepon, '^\+?\d{10,15}$'))
);

CREATE TABLE customer (
    id_customer  NUMBER PRIMARY KEY,
    nama         VARCHAR2(100) NOT NULL
);

CREATE TABLE makanan (
    id_makanan      NUMBER PRIMARY KEY,
    nama            VARCHAR2(100) NOT NULL,
    harga           NUMBER CONSTRAINT ck_makanan_harga CHECK (harga > 0),
    kategori        VARCHAR2(50) CONSTRAINT ck_makanan_kategori
                    CHECK (kategori IN ('Makanan Utama', 'Minuman', 'Camilan', 'Penutup')),
    bahan           VARCHAR2(255),
    status_makanan  VARCHAR2(20) CONSTRAINT ck_makanan_status
                    CHECK (status_makanan IN ('Tersedia', 'Habis'))
);

CREATE TABLE suplier (
    id_suplier   NUMBER PRIMARY KEY,
    nama         VARCHAR2(100) NOT NULL,
    alamat       VARCHAR2(255) NOT NULL,
    no_telepon   VARCHAR2(20) CONSTRAINT ck_suplier_telp
                 CHECK (REGEXP_LIKE(no_telepon, '^\+?\d{10,15}$')),
    jenis_barang VARCHAR2(100) NOT NULL
);

CREATE TABLE orders (
    id_order      NUMBER PRIMARY KEY,
    id_customer   NUMBER NOT NULL
                  REFERENCES customer(id_customer),
    id_waiters    NUMBER NOT NULL
                  REFERENCES waiters(id_waiters),
    tanggal_order DATE NOT NULL,
    total_harga   NUMBER CONSTRAINT ck_orders_total CHECK (total_harga >= 0),
    status_order  VARCHAR2(20) CONSTRAINT ck_orders_status
                  CHECK (status_order IN ('Diproses', 'Selesai', 'Dibatalkan'))
);

CREATE TABLE bill (
    id_bill           NUMBER PRIMARY KEY,
    id_order          NUMBER NOT NULL
                      REFERENCES orders(id_order),
    jumlah_total      NUMBER CONSTRAINT ck_bill_total CHECK (jumlah_total >= 0),
    status_pembayaran VARCHAR2(20) CONSTRAINT ck_bill_status
                      CHECK (status_pembayaran IN ('Belum Dibayar', 'Lunas')),
    metode_pembayaran VARCHAR2(20) CONSTRAINT ck_bill_metode
                      CHECK (metode_pembayaran IN ('Tunai', 'Kartu', 'QRIS', 'Transfer')),
    tanggal           DATE NOT NULL
);

/* Laporan transaksi harian */
CREATE OR REPLACE VIEW v_laporan_transaksi_harian AS
SELECT b.id_bill,
       b.tanggal,
       c.nama       AS nama_customer,
       o.total_harga,
       b.jumlah_total,
       b.status_pembayaran,
       b.metode_pembayaran
FROM   bill b
JOIN   orders  o ON b.id_order   = o.id_order
JOIN   customer c ON o.id_customer = c.id_customer;

/* Menu tersedia */
CREATE OR REPLACE VIEW v_menu_tersedia AS
SELECT id_makanan, nama, harga, kategori, bahan
FROM   makanan
WHERE  status_makanan = 'Tersedia';

/* Jadwal shift pegawai */
CREATE OR REPLACE VIEW v_jadwal_shift_pegawai AS
SELECT id_kasir   AS id, nama, shift, 'Kasir'   AS jabatan FROM kasir
UNION ALL
SELECT id_waiters AS id, nama, shift, 'Waiters' AS jabatan FROM waiters
UNION ALL
SELECT id_manager AS id, nama, shift, 'Manager' AS jabatan FROM manager
UNION ALL
SELECT id_chef    AS id, nama, shift, 'Chef'    AS jabatan FROM chef;

/* Riwayat pesanan pelanggan */
CREATE OR REPLACE VIEW v_riwayat_pesanan AS
SELECT o.id_order,
       o.tanggal_order,
       c.nama AS nama_customer,
       w.nama AS nama_waiters,
       o.total_harga,
       o.status_order
FROM   orders  o
JOIN   customer c ON o.id_customer = c.id_customer
JOIN   waiters  w ON o.id_waiters  = w.id_waiters;

/* Info restoran + manager */
CREATE OR REPLACE VIEW v_info_restoran AS
SELECT r.id_restoran,
       r.nama     AS nama_restoran,
       r.alamat,
       r.kapasitas,
       m.nama     AS nama_manager,
       m.email    AS email_manager
FROM   restoran r
LEFT   JOIN manager m ON r.id_restoran = m.id_restoran;

/* Supplier */
CREATE OR REPLACE VIEW v_supplier_barang AS
SELECT id_suplier, nama, alamat, jenis_barang
FROM   suplier;


CREATE SEQUENCE seq_restoran START WITH 701  INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_kasir    START WITH 101  INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_waiters  START WITH 301  INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_manager  START WITH 401  INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_chef     START WITH 501  INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_customer START WITH 201  INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_makanan  START WITH 601  INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_suplier  START WITH 801  INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_order    START WITH 901  INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_bill     START WITH 1001 INCREMENT BY 1 NOCACHE NOCYCLE;


CREATE INDEX idx_kasir_shift          ON kasir   (shift);
CREATE INDEX idx_kasir_email          ON kasir   (email);

CREATE INDEX idx_waiters_shift        ON waiters (shift);
CREATE INDEX idx_waiters_email        ON waiters (email);

CREATE INDEX idx_manager_shift        ON manager (shift);
CREATE INDEX idx_manager_email        ON manager (email);
CREATE INDEX idx_manager_restoran     ON manager (id_restoran);

CREATE INDEX idx_chef_shift           ON chef    (shift);
CREATE INDEX idx_chef_spesialis       ON chef    (spesialis);

CREATE INDEX idx_customer_nama        ON customer(nama);

CREATE INDEX idx_makanan_status       ON makanan (status_makanan);
CREATE INDEX idx_makanan_kategori     ON makanan (kategori);

CREATE INDEX idx_orders_customer      ON orders  (id_customer);
CREATE INDEX idx_orders_waiters       ON orders  (id_waiters);
CREATE INDEX idx_orders_status        ON orders  (status_order);
CREATE INDEX idx_orders_tanggal       ON orders  (tanggal_order);

CREATE INDEX idx_bill_order           ON bill    (id_order);
CREATE INDEX idx_bill_status          ON bill    (status_pembayaran);
CREATE INDEX idx_bill_metode          ON bill    (metode_pembayaran);
CREATE INDEX idx_bill_tanggal         ON bill    (tanggal);