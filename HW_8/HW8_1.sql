/*
	1. ��������� �������� ������, ������� � ���������� ������ ���������� ��������� ������� ���������� ����:
	�������� �������
	�������� ���������� �������

	�������� ����� � ID 2-6, ��� ��� ������������� Tailspin Toys
	��� ������� ����� �������� ��� ����� �������� ������ ��������� 
	�������� �������� Tailspin Toys (Gasport, NY) - �� �������� � ����� ������ Gasport,NY
	���� ������ ����� ������ dd.mm.yyyy �������� 25.12.2019


	��������, ��� ������ ��������� ����������:
	InvoiceMonth	Peeples Valley, AZ	Medicine Lodge, KS	Gasport, NY	Sylvanite, MT	Jessie, ND
	01.01.2013	3	1	4	2	2
	01.02.2013	7	3	4	2	1
*/

SELECT InvoiceMonthYear
      ,[Gasport, NY]
      ,[Jessie, ND]
      ,[Medicine Lodge, KS]
      ,[Peeples Valley, AZ]
      ,[Sylvanite, MT]
FROM (
      SELECT ci.CustomerName
            ,ci.InvoiceMonthYear
      FROM   [Sales].[Customers] c
             INNER JOIN [Sales].[Invoices] i ON  i.CustomerID = c.CustomerID
             CROSS APPLY
             (
                 SELECT SUBSTRING(c.CustomerName, CHARINDEX('(', c.CustomerName) + 1, CHARINDEX(')', c.CustomerName) - CHARINDEX('(', c.CustomerName) -1 ) AS CustomerName
                       ,CONVERT(nvarchar, DATEADD(mm, DATEDIFF(mm, 0, i.InvoiceDate) , 0), 104)  AS InvoiceMonthYear
                 WHERE  c.CustomerID BETWEEN 2 AND 6
             ) AS ci
     ) AS tbl
PIVOT 
(
      COUNT (CustomerName) FOR CustomerName IN ( [Gasport, NY]
                                                ,[Jessie, ND]
                                                ,[Medicine Lodge, KS]
                                                ,[Peeples Valley, AZ]
                                                ,[Sylvanite, MT])
) piv
ORDER BY CONVERT(DATE, InvoiceMonthYear)