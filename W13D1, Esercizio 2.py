import duckdb  #importo duckdb

con = duckdb.connect("flusso.duckdb") #mi collego a duckdb
 
con.execute(""" 

    CREATE OR REPLACE TABLE clienti AS 

    SELECT * FROM read_csv('clienti.csv') 

""") 

con.execute(""" 

    CREATE OR REPLACE TABLE ordini AS 

    SELECT * FROM read_csv('ordini.csv') 

""") 

con.sql("SHOW TABLES").show() 

con.close() 