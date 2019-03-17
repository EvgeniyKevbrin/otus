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







SELECT *
FROM   [Application].[People] p

SELECT      c.name  AS 'ColumnName'
            ,t.name AS 'TableName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%SalespersonPersonID%'
ORDER BY    TableName
            ,ColumnName;