-- INTEGRANTES
--Pablo Arreaga 1331818
--Walter Eduardo Ruiz Erazo / 1028916
--Marlon Roches / 1250918





--¿A cuánto asciende el total de ventas? (Copiar el número sin aproximar o colocar comas)
select SUM(TotalDue)  from SalesLT.SalesOrderHeader
--me equivoque y le quite los decimales Xd

--¿Cuánto pagó de flete el cliente con la compra más alta? (Copiar la cantidad exacta sin aproximar)

select Freight  from SalesLT.SalesOrderHeader
order  by TotalDue desc

--¿Cuál es el ID del cliente que pagó menos impuesto por su compra?
select CustomerID from SalesLT.SalesOrderHeader
order  by TaxAmt 

-- ¿Cuántos modelos de producto tienen un promedio de peso mayor a 0?  
select count(*) as [Producto peso mayor a 0] from 
(
select AVG(Weight) as [Promedio] from SalesLT.Product
group by ProductModelID
having AVG(Weight) > 0 ) B

--¿Cuánto pagó de impuesto el cliente con la compra más alta? (Copiar la cantidad exacta sin aproximar)
select * from SalesLT.SalesOrderHeader
order by SubTotal desc
--8684.9465


--¿En cuántas órdenes de venta se despacharon menos de 5 productos?
select count(*) as [Ventas con menos de 5 items ]from
(
select sum(So.OrderQty) as [Cantidad] from SalesLT.SalesOrderHeader SH
join SalesLT.SalesOrderDetail SO on SO.SalesOrderID = sh.SalesOrderID
group by SO.SalesOrderID 
having sum(So.OrderQty) < 5 
) C


--¿Cuál es el producto con el costo estándar más alto? (Copiar el nombre del producto EXACTO)
select top 1 Name from SalesLT.Product
order by StandardCost desc



--¿Cual es el ID de la venta más alta?
select top 1 SalesOrderID from SalesLT.SalesOrderHeader
order by TotalDue desc


--¿cuántos códigos postales empiezan con M?
select count(*) as [códigos postales empiezan con M] from SalesLT.Address
where PostalCode like 'M%'

--¿Cuántas direcciones de usuario de tipo Main Office existen?
select count(*)as [direcciones 'Main Office'] from SalesLT.CustomerAddress
where AddressType = 'Main Office'



--¿Cuál es el ID de cliente que pagó más flete por su compra?
select top 1 CustomerID as [cliente que pagó más flete]from SalesLT.SalesOrderHeader
order  by Freight desc	 

--¿Cuántas provincias de estado tienen menos de 5 direcciones registradas?
select count(*) as [Provincias con menos de 5 direcciones] from (
select StateProvince,count(*) as [direcciones] from SalesLT.Address
group by StateProvince
having count(*) < 5) D


--¿Cuántas direcciones están listadas para las empresas "Future Bikes" y “Futuristic Bikes”?
select CompanyName,count(AddressLine1) as [Direcciones Registradas]from SalesLT.Customer CU
join SalesLT.CustomerAddress CA on CU.CustomerID = CA.CustomerID
join SalesLT.Address AD on AD.AddressID = CA.AddressID
where /*CU.CompanyName ='Future Bikes' and*/  CU.CompanyName ='Futuristic Bikes' 
group by CU.CompanyName
select CompanyName,count(AddressLine1) as [Direcciones Registradas]from SalesLT.Customer CU
join SalesLT.CustomerAddress CA on CU.CustomerID = CA.CustomerID
join SalesLT.Address AD on AD.AddressID = CA.AddressID
where CU.CompanyName ='Future Bikes'-- and CU.CompanyName ='Futuristic Bikes' 
group by CU.CompanyName


--¿Cuántos clientes tuvieron un total de compras acumuladas menor a $35,000?
select count(*) as [clientes con un total de compras acumuladas menor a $35,000] from (select  CustomerID,sum(TotalDue)as [Compras Acumuladas] from SalesLT.SalesOrderHeader
group by CustomerID
having sum(TotalDue) < 35000 ) H

--¿Cuántos productos compró el señor Mr. Jon Grande?
select sum(R.OrderQty) as [Productos Comprados por Mr. Jon Grande] from (select SD.OrderQty from SalesLT.Customer CU
join SalesLT.SalesOrderHeader SH on CU.CustomerID = SH.CustomerID
join SalesLT.SalesOrderDetail SD on SD.SalesOrderID = SH.SalesOrderID 
where CU.FirstName = 'Jon' and CU.LastName = 'Grande') R


--¿Cuántas camisas de manga larga talla XL ('Long-Sleeve Logo Jersey, XL') ha comprado la empresa 'Action Bicycle Specialists'? 
select OrderQty as [ Camisas compradas por 'Action Bicycle Specialists' ] from SalesLT.Customer CU
join SalesLT.SalesOrderHeader SH on CU.CustomerID = SH.CustomerID
join SalesLT.SalesOrderDetail SD on SD.SalesOrderID = SH.SalesOrderID 
join SalesLT.Product PR on Pr.ProductID = SD.ProductID
where PR.Name ='Long-Sleeve Logo Jersey, XL' AND  CU.CompanyName = 'Action Bicycle Specialists'


--¿Cuántos productos tienen la palabra "Mountain" en su nombre?
select count(*) as [productos que tienen 'Mountain' en el nombre] from SalesLT.Product
where name like '%Mountain%'

--¿Cuántos artículos con precio de lista menor a $1,200 se han vendido?

select sum(SD.OrderQty)as [artículos vendidos  con precio de lista menor a $1,200] from SalesLT.Product PR
join SalesLT.SalesOrderDetail SD on SD.ProductID = PR.ProductID
where PR.ListPrice < 1200

-- Inge, se me pasó un 0 en 1,200 y puse que eran 2087 productos vendidos
-- pero ya está coprregido el Query XD

