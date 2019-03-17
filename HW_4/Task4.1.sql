-- 1. Выберите сотрудников, которые являются продажниками, и еще не сделали ни одной продажи.
;WITH SalesPersons AS
(
	SELECT p.PersonID, p.FullName
	FROM   [Application].[People] p
	WHERE  IsSalesperson = 1
)
SELECT DISTINCT FullName
FROM   SalesPersons sp
	   INNER JOIN [Sales].[Orders] o ON o.SalespersonPersonID = sp.PersonID
