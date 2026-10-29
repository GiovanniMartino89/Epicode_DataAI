import duckdb
 
con = duckdb.connect("vendite.duckdb")
 
print("Punto 4 - Prime 5 righe:")
con.sql("SELECT * FROM orders LIMIT 5").show()
 
print("Punto 4 - Numero totale di record:")
con.sql("SELECT COUNT() AS totale_record FROM orders").show()
 
print("Punto 5 - Fatturato complessivo:")
con.sql("""
   SELECT SUM(quantity * unit_price) AS fatturato_totale
   FROM orders
""").show()
 
print("Punto 6 - Fatturato per prodotto:")
con.sql("""
   SELECT product,
          SUM(quantity * unit_price) AS fatturato
   FROM orders
   GROUP BY product
   ORDER BY fatturato DESC
""").show()
 
print("Punto 7 - Ordini per cliente:")
con.sql("""
   SELECT customer_id,
          COUNT() AS numero_ordini
   FROM orders
   GROUP BY customer_id
   ORDER BY customer_id
""").show()
 
con.close()