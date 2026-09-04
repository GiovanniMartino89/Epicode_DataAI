SELECT VERSION ();

 USE AdventureWorksDW; -- nome database
-- Esercizio 1 Over senza partizionamento

-- CustomersKey, SalesAmount e il totale generale delle vendite ripetuto su ogni riga *\
SELECT 
    CustomerKey,
    SalesAmount,
    SUM(SalesAmount) OVER () AS TotaleGenerale
FROM factinternetsales;

-- SalesAmount e la media generale delle vendite ripetuta su ogni riga *\
SELECT 
    SalesAmount,
    AVG(SalesAmount) OVER () AS MediaGenerale
FROM factinternetsales;

-- OrderQuantity e la quantità massima ordinata in un'unica riga d'ordine , ripetuta su ogni riga *\
SELECT 
    OrderQuantity,
    MAX(OrderQuantity) OVER () AS QuantitaMassima
FROM factinternetsales;

-- SalesAmount e l'importo minimo tra tutti gli ordini ripetuta su ogni riga *\
SELECT
	SalesAmount, 
    MIN(SalesAmount) OVER() AS ImportoMinimo
FROM factinternetsales;
    
-- Esercizio 2. Partition By. Quattro query con Partition By

-- Customerkay, SalesAmount, e il totale speso da quel cliente, ripetuto su ogni riga

SELECT
	CustomerKey
    SalesAmount,
    SUM(SalesAmount) OVER(PARTITION BY CustomerKey) AS Totale_Spesa
FROM factinternetsales;

-- La differenza tra SalesAmount di ogni riga, e il totale del punto 1 dello stesso cliente

SELECT 
    CustomerKey,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY CustomerKey) AS TotaleCliente,
    SalesAmount - SUM(SalesAmount) OVER (PARTITION BY CustomerKey) AS Differenza
FROM factinternetsales;

WITH Vendite_totale AS (
    SELECT 
        CustomerKey,
        SalesAmount,
        SUM(SalesAmount) OVER (PARTITION BY CustomerKey) AS Totale_cliente
    FROM factinternetsales
)
SELECT 
    CustomerKey,
    SalesAmount,
    TotaleCliente,
    SalesAmount - Totale_cliente AS Differenza
FROM Vendite_totale;


-- ProductKey, SalesAmount e il totale venduto per quel prodotto ripetuto su ogni riga

SELECT

	ProductKey,
    SalesAmount, 
SUM(SalesAmount) OVER(PARTITION BY ProductKey)
	FROM factinternetsales;

-- La stessa somma per cliente del punto 1 ottenuta con Group By: si confronta il numero di righe ottenute

SELECT 
    CustomerKey,
    SUM(SalesAmount) AS Totale_Cliente
FROM factinternetsales
GROUP BY CustomerKey;

-- Esercizio 3. Row Number

-- 1. CustomerKey, OrderData e un numero progressivo che parte da 1, per ciauscun cliente, ordinato per data

SELECT 
    CustomerKey,
    OrderDate,
    ROW_NUMBER() OVER (PARTITION BY CustomerKey ORDER BY OrderDate) AS Progressivo
FROM factinternetsales;

-- Dal risultato del punto 1, il solo ultimo ultimo ordine di ogni cliente

WITH Num_Ordine AS (
SELECT 
    CustomerKey,
    OrderDate,
    ROW_NUMBER() OVER (PARTITION BY CustomerKey ORDER BY OrderDate DESC) AS Num_progressivo
FROM factinternetsales
)

SELECT 
	CustomerKey, 
    OrderDate
FROM Num_Ordine
WHERE Num_progressivo=1;

-- Numero di Clienti restituti dal punto 2, da confrontare con i numeri clienti in factinternetsales

WITH Num_Ordine AS (
SELECT 
    CustomerKey,
    OrderDate,
    ROW_NUMBER() OVER (PARTITION BY CustomerKey ORDER BY OrderDate DESC) AS Num_progressivo
FROM factinternetsales
)
SELECT COUNT(*) AS Clienti_2
FROM Num_Ordine
WHERE Num_Progressivo=1; 

SELECT COUNT(DISTINCT CustomerKey) AS Clienti_distinti
FROM factinternetsales;