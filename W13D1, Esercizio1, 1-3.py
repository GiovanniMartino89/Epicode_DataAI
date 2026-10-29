# Prima parte dell'esercizio: creazione del database e della tabella orders

import duckdb
con = duckdb.connect("vendite.duckdb")
print("Connessione riuscita")
con.close()

# Seconda parte dell'esercizio: creazione della tabella orders

import duckdb 
con = duckdb.connect("vendite.duckdb")
con.execute("""
   CREATE OR REPLACE TABLE orders (
       order_id   INTEGER,
       customer_id INTEGER,
       order_date DATE,
       product    VARCHAR,
       quantity   INTEGER,
       unit_price DECIMAL(10, 2)
   )
""")
con.sql("DESCRIBE orders").show()
con.close()

# Terza parte dell'esercizio: inserimento dei dati nella tabella orders

import duckdb

con = duckdb.connect("vendite.duckdb")

con.execute("""
   CREATE OR REPLACE TABLE orders (
       order_id   INTEGER,
       customer_id INTEGER,
       order_date DATE,
       product    VARCHAR,
       quantity   INTEGER,
       unit_price DECIMAL(10, 2)
   )
""")

con.execute("""
   INSERT INTO orders VALUES
       (1, 101, '2026-01-05', 'Laptop',  1, 899.00),
       (2, 102, '2026-01-07', 'Mouse',   2, 19.90),
       (3, 101, '2026-01-10', 'Tastiera', 1, 49.50),
       (4, 103, '2026-01-12', 'Monitor', 2, 189.00),
       (5, 104, '2026-01-15', 'Mouse',   3, 19.90),
       (6, 102, '2026-01-18', 'Laptop',  1, 899.00),
       (7, 103, '2026-01-20', 'Tastiera', 2, 49.50),
       (8, 101, '2026-01-22', 'Monitor', 1, 189.00),
       (9, 104, '2026-01-25', 'Mouse',   1, 19.90),
       (10, 102, '2026-01-28', 'Monitor', 1, 189.00)
""")

con.sql("SELECT COUNT(*) AS righe FROM orders").show()

con.close()

