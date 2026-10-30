import duckdb 

con = duckdb.connect("flusso.duckdb") 

# Punto 3: numero di record e campi disponibili 

# 1. Rimuove le parentesi contabili per i numeri negativi (es. (120.50) -> -120.50) questa è Claude dopo che non funzionava mai
# Usiamo un blocco TRY/CATCH di DuckDB per evitare crash se la colonna è già numerica
try:
    con.sql("""
        UPDATE ordini 
        SET amount = CASE 
            WHEN TRIM(CAST(amount AS VARCHAR)) LIKE '(%)' 
            THEN '-' || REPLACE(REPLACE(TRIM(CAST(amount AS VARCHAR)), '(', ''), ')', '')
            ELSE TRIM(CAST(amount AS VARCHAR))
        END 
        WHERE TYPEOF(amount) = 'VARCHAR';
    """)
    
    # 2. Converte in DECIMAL solo se la colonna è ancora di tipo testo
    con.sql("""
        ALTER TABLE ordini ALTER amount TYPE DECIMAL 
        USING CAST(TRIM(CAST(amount AS VARCHAR)) AS DECIMAL);
    """)
except Exception:
    # Se la colonna è già DECIMAL, ignora l'errore e va avanti
    pass

## fine blocco aggiuntivo, così ho risolto ma non ho capito il problema sinceramente

print("Punto 3 - Numero di record:") 

con.sql(""" 

    SELECT 'clienti' AS tabella, COUNT(*) AS record FROM clienti 

    UNION ALL 

    SELECT 'ordini', COUNT(*) FROM ordini 

""").show() 

print("Punto 3 - Campi della tabella clienti:") 

con.sql("DESCRIBE clienti").show() 
 
print("Punto 3 - Campi della tabella ordini:") 

con.sql("DESCRIBE ordini").show() 

#con.close() 

# Punto 4: join tra ordini e clienti 


print("Punto 4 - Join ordini e clienti:") 

con.sql(""" 

    SELECT o.order_id, 
           o.order_date, 
           o.amount, 
           c.customer_id, 
           c.customer_name, 
           c.city 
    FROM ordini AS o 
    JOIN clienti AS c 
      ON o.customer_id = c.customer_id 
    ORDER BY o.order_id 
""").show() 

con.sql("""
    SELECT column_name, data_type 
    FROM information_schema.columns 
    WHERE table_name = 'ordini';
""").show()

# Punto 5: fatturato e numero di ordini per città 

print("Punto 5 - Fatturato e ordini per città:") 

con.sql(""" 

    SELECT c.city, 

           ROUND(SUM(o.amount), 2) AS fatturato, 

           COUNT(*) AS numero_ordini 

    FROM ordini AS o 

    JOIN clienti AS c 

      ON o.customer_id = c.customer_id 

    GROUP BY c.city 

    ORDER BY fatturato DESC 

""").show() 

# Punto 6: ordini senza corrispondenza nella tabella clienti 

print("Punto 6 - Ordini senza cliente:") 

con.sql(""" 

    SELECT o.order_id, 

           o.customer_id, 

           o.order_date, 

           o.amount 

    FROM ordini AS o 

    LEFT JOIN clienti AS c 

      ON o.customer_id = c.customer_id 

    WHERE c.customer_id IS NULL 

    ORDER BY o.order_id 

""").show() 