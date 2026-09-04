SELECT VERSION ();

 USE AdventureWorksDW; -- nome database
-- Esercizio 1 Over senza partizionamento

-- 1. CustomersKey, SalesAmount e il totale generale delle vendite ripetuto su ogni riga *\
SELECT 
    CustomerKey,
    SalesAmount,
    SUM(SalesAmount) OVER () AS TotaleGenerale
FROM factinternetsales;

-- 2. SalesAmount e la media generale delle vendite ripetuta su ogni riga *\
SELECT 
    SalesAmount,
    AVG(SalesAmount) OVER () AS MediaGenerale
FROM factinternetsales;

-- 3. OrderQuantity e la quantità massima ordinata in un'unica riga d'ordine , ripetuta su ogni riga *\
SELECT 
    OrderQuantity,
    MAX(OrderQuantity) OVER () AS QuantitaMassima
FROM factinternetsales;

-- 4. SalesAmount e l'importo minimo tra tutti gli ordini ripetuta su ogni riga *\
SELECT
	SalesAmount, 
    MIN(SalesAmount) OVER() AS ImportoMinimo
FROM factinternetsales;
    
-- Esercizio 2. Partition By. Quattro query con Partition By

-- 1. Customerkey, SalesAmount, e il totale speso da quel cliente, ripetuto su ogni riga

SELECT
	CustomerKey
    SalesAmount,
    SUM(SalesAmount) OVER(PARTITION BY CustomerKey) AS Totale_Spesa
FROM factinternetsales;

-- 2. La differenza tra SalesAmount di ogni riga, e il totale del punto 1 dello stesso cliente

SELECT 
    CustomerKey,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY CustomerKey) AS TotaleCliente,
    SalesAmount - SUM(SalesAmount) OVER (PARTITION BY CustomerKey) AS Differenza
FROM factinternetsales; -- fatta senza la CTE, ci ho pensato dopo mannaggia a me

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
FROM Vendite_totale; -- correttamente con la CTE intregata, ovvvero, Vendite_totale


-- 3. ProductKey, SalesAmount e il totale venduto per quel prodotto ripetuto su ogni riga

SELECT

	ProductKey,
    SalesAmount, 
SUM(SalesAmount) OVER(PARTITION BY ProductKey)
	FROM factinternetsales;

-- 4. La stessa somma per cliente del punto 1 ottenuta con Group By: si confronta il numero di righe ottenute

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

-- 2. Dal risultato del punto 1, il solo ultimo ordine di ogni cliente

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

-- 3. Numero di Clienti restituti dal punto 2, da confrontare con i numeri clienti in factinternetsales

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

-- Esercizio 4 RANK e DENSE_RANK

-- 1. Nome prodotto e totale venduto (SUM SalesAmount), classificati con RANK in ordine decrescente

WITH Totali_prodotto AS (
    SELECT 
        p.EnglishProductName AS NomeProdotto,
        SUM(f.SalesAmount) AS TotaleVenduto
    FROM factinternetsales AS f
    JOIN dimproduct AS p  -- mi serve il nome del prodotto che sta nella tabella dim
        ON f.ProductKey = p.ProductKey
    GROUP BY p.EnglishProductName -- perché così tengo una riga per prodotto con il totale, lo uso in una cte perché non va insieme a rank
)
SELECT 
    NomeProdotto,
    TotaleVenduto,
    RANK() OVER (ORDER BY TotaleVenduto DESC) AS Posizione
FROM Totali_prodotto; -- con rank e poi partition infine vado a classificare 


WITH Totali_prodotto AS (
    SELECT 
        p.EnglishProductName AS NomeProdotto,
        SUM(f.SalesAmount) AS TotaleVenduto
    FROM factinternetsales AS f
    JOIN dimproduct AS p 
        ON f.ProductKey = p.ProductKey
    GROUP BY p.EnglishProductName
)
SELECT 
    NomeProdotto,
    TotaleVenduto,
    DENSE_RANK() OVER (ORDER BY TotaleVenduto DESC) AS Posizione
FROM Totali_prodotto; -- uguale con dense

-- 3. Teniamo solo quelli differenti

WITH TotaliProdotto AS (
    SELECT 
        p.EnglishProductName AS NomeProdotto,
        SUM(f.SalesAmount) AS TotaleVenduto
    FROM factinternetsales AS f
    JOIN dimproduct AS p 
        ON f.ProductKey = p.ProductKey
    GROUP BY p.EnglishProductName -- stessa Cte di sopra mi serve 
),
Classifica AS (
    SELECT 
        NomeProdotto,
        TotaleVenduto,
        RANK() OVER (ORDER BY TotaleVenduto DESC) AS Posizione_Rank,
        DENSE_RANK() OVER (ORDER BY TotaleVenduto DESC) AS Posizione_DenseRank
    FROM TotaliProdotto -- seconda cte in cui vado a fare una classifica
)
SELECT *
FROM Classifica
WHERE Posizione_Rank <> Posizione_DenseRank; -- confronto
