DECLARE @DirectReports TABLE  
(  
EmployeeID smallint NOT NULL,  
[Name] nvarchar(70)  NOT NULL,  
Title nvarchar(50) NOT NULL,   
EmployeeLevel int NULL
); 

;WITH DirectReportsTableVariable(EmployeeID, Name, Title, EmployeeLevel) AS   
(  
    SELECT EmployeeID, CONCAT(FirstName, LastName), Title, 0 AS EmployeeLevel  
    FROM dbo.MyEmployees   
    WHERE ManagerID IS NULL  
    UNION ALL  
    SELECT e.EmployeeID, CONCAT(FirstName, LastName) AS Name, e.Title, EmployeeLevel + 1  
    FROM dbo.MyEmployees AS e  
        INNER JOIN DirectReportsTableVariable AS d  
        ON e.ManagerID = d.EmployeeID   
)
INSERT INTO @DirectReports
SELECT EmployeeID, Name, Title, EmployeeLevel
FROM DirectReportsTableVariable  
ORDER BY EmployeeID;  

-- план выполнения запроса одинаковый и в случае с временной таблицей и в случае с табличной переменной
SELECT EmployeeID, CONCAT( REPLICATE(' | ', EmployeeLevel), Name) AS Name, Title, EmployeeLevel
FROM  @DirectReports

GO;

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

SELECT EmployeeID, CONCAT( REPLICATE(' | ', EmployeeLevel), Name) AS Name, Title, EmployeeLevel
FROM  #DirectReports

