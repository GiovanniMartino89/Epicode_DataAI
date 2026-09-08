USE AdventureWorksDW; -- nome database

-- Esercizio 1. misure, chiavi e granularità

-- 1. OrderQuantity e Sales Amount, mostrare perchè sono misure e non sono attributi descrittivi

SELECT SUM(SalesAmount) AS TotaleVendite FROM factinternetsales;
SELECT SUM(OrderQuantity) AS TotalePezzi FROM factinternetsales;

-- Sono misure in quanto sono valori numerici aggregabili: 
-- se ne faccio la somma il primo mi da il fatturato totale e il secondo i pezzi venduti totali

-- 2. CustomerKey e SalesAmount: indicare a quali tabelle delle dimensioni si collegano. 

 -- È una chiave esterna (foreign key): 
 -- vive nella tabella dei fatti (factinternetsales), con scopo di collegarsi a una tabella dimensione con i dettsgli (dim.customer)
 -- SalesAmount invece è una misura che vive nella tabella dei fatti 
 
 -- 3. OrderDate. Stabilire se è una misura, una chiave esterna o un attributo motivando la scelta
 
 SELECT SUM(OrderDate) FROM factinternetsales; -- il risultato è insensato, non è una misura, 
 -- Non è una chiave esterna in quanto l'order date è collegato a un numero, magari che sarebbe la chiave. 
 -- È un attributo, quindi, contenuto nella tabella dei fatti (di tipo descrittivo)
 
 -- 4. Definizione di Granularità:
 
 -- La Granularità di Factinernersale è la singola riga di dettaglio di un ordine, 
 -- cioè un prodotto specifico venduto a un cliente specifico in un ordine specifico.
 
 -- Esercizio 2. Attrivuti e chiave surrogata
 
 -- 1. Elencare gli attributi di DimCustomoer che si possono usare per filtrare o raggrupare un report
 
 DESCRIBE dimcustomer;
 
 -- Gender, per ragguppare in base al sesso;
 -- Marital Status, per indagini demografiche;
 -- Education, per l'istruzione;
 -- Occupation, per la professione;
 -- Total Children, YearlyIncome, NuumberChildren, 
 -- CUstomerKay, FirstName, MiddleName, LastName, Birtjdata, attributi che non si usano per raggruppare (Group BY)

-- 2. Spiegare perché CustomerKey e non un dato come EmailAdrees è una chiave primaria;

-- CustomerKey è l'identificativo dato a quel cliente, in cui troviamo esattamente lui, è utile se vogliamo fare una JOIN. 
-- EmailAddress invece potrebbe non essere univoco (più perosne della stessa famiglia hanno dato lo stesso indirizzo)
-- Oppure semplicmente cambia l'indirizzo email col tempo

-- 3. Indicare cosa succede se il valore di FirstName cambia: quale si aggiorna e quale resta invariata

-- Si aggiorna DimCustomer, non FactInternetSales
-- FirstName è un attributo descrittivo del cliente, e vive solo in DimCustomer — non è mai duplicato dentro FactInternetSales. 
-- La tabella dei fatti contiene solo CustomerKey (il numero), non FirstName: aggiornando queste, poi in fact tutto si aggiorna di seguito (JOIN)

-- Definizione. 
-- Identificativo numerico generato  dal sistema, senza alcun significato nel mondo reale, usato come chiave primaria di una tabella — 
-- tipicamente in sostituzione di una chiave "naturale"


-- Esercizio 3. Star Schema

-- 1. 

SHOWTABLE factinterntsales;
--                                             FactInternetSales

