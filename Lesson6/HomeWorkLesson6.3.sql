	  --Посчитайте по таблице товаров, в вывод также должен попасть ид товара, название, брэнд и цена
	SELECT  s.StockItemID
		   ,s.StockItemName
		   ,s.Brand
		   ,s.UnitPrice
		   --пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
		   ,ROW_NUMBER() OVER (PARTITION BY SUBSTRING(s.StockItemName,1,1) ORDER BY  s.StockItemName  ) AS ItemsRowNumberByLetters
		   --посчитайте общее количество товаров и выведете полем в этом же запросе
		   ,COUNT(StockItemName) OVER () AS TotalQuantityOfGoods
		   --посчитайте общее количество товаров в зависимости от первой буквы названия товара
		   ,COUNT(StockItemName) OVER ( PARTITION BY SUBSTRING(s.StockItemName,1,1) ) AS TotalQuantityOfGoodsByFirstLetter
		   --отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
		   ,LEAD (s.StockItemID) OVER (ORDER BY StockItemName ) NextItem
		   --предыдущий ид товара с тем же порядком отображения (по имени)
		   ,LAG (s.StockItemID) OVER (ORDER BY StockItemName ) PreviousItem
		   --названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
		   ,LAG (s.StockItemName,2, 'No Items') OVER (ORDER BY StockItemName) TwoRowsBack
		   --сформируйте 30 групп товаров по полю вес товара на 1 шт
		   ,NTILE(30) OVER (ORDER BY s.TypicalWeightPerUnit) AS ItemGroups
	FROM   [Warehouse].[StockItems] s


