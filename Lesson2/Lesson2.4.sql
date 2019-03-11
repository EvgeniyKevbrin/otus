-- Заказы поставщикам, которые были исполнены за 2014й год с доставкой Road Freight или Post
--,добавьте название поставщика, имя контактного лица принимавшего заказ

SELECT o.PurchaseOrderID
	  ,s.SupplierName
	  ,p.FullName    AS ContactName
FROM   [Purchasing].[PurchaseOrders] o
INNER JOIN  [Application].[DeliveryMethods] m ON m.DeliveryMethodID = o.DeliveryMethodID
INNER JOIN  [Purchasing].[Suppliers] s        ON s.SupplierID = o.SupplierID
INNER JOIN  [Application].[People] p          ON p.PersonID = o.ContactPersonID
WHERE  YEAR(OrderDate) = 2014
	   AND (m.DeliveryMethodName = 'Road Freight' OR m.DeliveryMethodName = 'Post')
