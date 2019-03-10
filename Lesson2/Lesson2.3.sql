/*
Продажи с названием месяца, в котором была продажа, номером квартала, к которому относится продажа,
включите также к какой трети года относится дата - каждая треть по 4 месяца, дата забора заказа должна быть задана,
с ценой товара более 100$ либо количество единиц товара более 20.
Добавьте вариант этого запроса с постраничной выборкой пропустив первую 1000 и отобразив следующие 100 записей.
Соритровка должна быть по номеру квартала, трети года, дате продажи. 
*/

SELECT i.InvoiceId, InvoiceDate
	  ,DATENAME(month, InvoiceDate)                                  AS    MonthOfName
	  ,DATEPART(qq, InvoiceDate)                                     AS    Quater
	  ,CASE
	  		WHEN DATEPART(mm, InvoiceDate) IN (1,2,3,4) THEN 1     
	  		WHEN DATEPART(mm, InvoiceDate) IN (5,6,7,8) THEN 2
	  		ELSE 3 
	   END                                                           AS    Third
FROM   [Sales].[Invoices] i
	   INNER JOIN [Sales].[InvoiceLines] l ON l.InvoiceId = i.InvoiceId
WHERE  l.UnitPrice  > 100 OR l.Quantity > 20
ORDER  BY Quater, Third, i.InvoiceDate
OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY;



