;WITH DirectReports(EmployeeID, Name, Title, EmployeeLevel) AS   
(  
    SELECT EmployeeID, CONCAT(FirstName, LastName), Title, 0 AS EmployeeLevel  
    FROM dbo.MyEmployees   
    WHERE ManagerID IS NULL  
    UNION ALL  
    SELECT e.EmployeeID, CONCAT(FirstName, LastName) AS Name, e.Title, EmployeeLevel + 1  
    FROM dbo.MyEmployees AS e  
        INNER JOIN DirectReports AS d  
        ON e.ManagerID = d.EmployeeID   
)  
SELECT EmployeeID, Name, Title, EmployeeLevel
INTO #DirectReports   
FROM DirectReports  
ORDER BY EmployeeID;  
GO  

SELECT EmployeeID, CONCAT( REPLICATE(' | ', EmployeeLevel), Name) AS Name, Title, EmployeeLevel
FROM  #DirectReports

