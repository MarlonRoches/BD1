-- INTEGRANTES
--Pablo Arreaga 1331818
--Walter Eduardo Ruiz Erazo / 1028916
--Marlon Roches / 1250918





--�A cu�nto asciende el total de ventas? (Copiar el n�mero sin aproximar o colocar comas)
select SUM(TotalDue)  from SalesLT.SalesOrderHeader
--me equivoque y le quite los decimales Xd

--�Cu�nto pag� de flete el cliente con la compra m�s alta? (Copiar la cantidad exacta sin aproximar)

select Freight  from SalesLT.SalesOrderHeader
order  by TotalDue desc

--�Cu�l es el ID del cliente que pag� menos impuesto por su compra?
select CustomerID from SalesLT.SalesOrderHeader
order  by TaxAmt 

-- �Cu�ntos modelos de producto tienen un promedio de peso mayor a 0?  
select count(*) as [Producto peso mayor a 0] from 
(
select AVG(Weight) as [Promedio] from SalesLT.Product
group by ProductModelID
having AVG(Weight) > 0 ) B

--�Cu�nto pag� de impuesto el cliente con la compra m�s alta? (Copiar la cantidad exacta sin aproximar)
select * from SalesLT.SalesOrderHeader
order by SubTotal desc
--8684.9465


--�En cu�ntas �rdenes de venta se despacharon menos de 5 productos?
select count(*) as [Ventas con menos de 5 items ]from
(
select sum(So.OrderQty) as [Cantidad] from SalesLT.SalesOrderHeader SH
join SalesLT.SalesOrderDetail SO on SO.SalesOrderID = sh.SalesOrderID
group by SO.SalesOrderID 
having sum(So.OrderQty) < 5 
) C


--�Cu�l es el producto con el costo est�ndar m�s alto? (Copiar el nombre del producto EXACTO)
select top 1 Name from SalesLT.Product
order by StandardCost desc



--�Cual es el ID de la venta m�s alta?
select top 1 SalesOrderID from SalesLT.SalesOrderHeader
order by TotalDue desc


--�cu�ntos c�digos postales empiezan con M?
select count(*) as [c�digos postales empiezan con M] from SalesLT.Address
where PostalCode like 'M%'

--�Cu�ntas direcciones de usuario de tipo Main Office existen?
select count(*)as [direcciones 'Main Office'] from SalesLT.CustomerAddress
where AddressType = 'Main Office'



--�Cu�l es el ID de cliente que pag� m�s flete por su compra?
select top 1 CustomerID as [cliente que pag� m�s flete]from SalesLT.SalesOrderHeader
order  by Freight desc	 

--�Cu�ntas provincias de estado tienen menos de 5 direcciones registradas?
select count(*) as [Provincias con menos de 5 direcciones] from (
select StateProvince,count(*) as [direcciones] from SalesLT.Address
group by StateProvince
having count(*) < 5) D


--�Cu�ntas direcciones est�n listadas para las empresas "Future Bikes" y �Futuristic Bikes�?
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


--�Cu�ntos clientes tuvieron un total de compras acumuladas menor a $35,000?
select count(*) as [clientes con un total de compras acumuladas menor a $35,000] from (select  CustomerID,sum(TotalDue)as [Compras Acumuladas] from SalesLT.SalesOrderHeader
group by CustomerID
having sum(TotalDue) < 35000 ) H

--�Cu�ntos productos compr� el se�or Mr. Jon Grande?
select sum(R.OrderQty) as [Productos Comprados por Mr. Jon Grande] from (select SD.OrderQty from SalesLT.Customer CU
join SalesLT.SalesOrderHeader SH on CU.CustomerID = SH.CustomerID
join SalesLT.SalesOrderDetail SD on SD.SalesOrderID = SH.SalesOrderID 
where CU.FirstName = 'Jon' and CU.LastName = 'Grande') R


--�Cu�ntas camisas de manga larga talla XL ('Long-Sleeve Logo Jersey, XL') ha comprado la empresa 'Action Bicycle Specialists'? 
select OrderQty as [ Camisas compradas por 'Action Bicycle Specialists' ] from SalesLT.Customer CU
join SalesLT.SalesOrderHeader SH on CU.CustomerID = SH.CustomerID
join SalesLT.SalesOrderDetail SD on SD.SalesOrderID = SH.SalesOrderID 
join SalesLT.Product PR on Pr.ProductID = SD.ProductID
where PR.Name ='Long-Sleeve Logo Jersey, XL' AND  CU.CompanyName = 'Action Bicycle Specialists'


--�Cu�ntos productos tienen la palabra "Mountain" en su nombre?
select count(*) as [productos que tienen 'Mountain' en el nombre] from SalesLT.Product
where name like '%Mountain%'

--�Cu�ntos art�culos con precio de lista menor a $1,200 se han vendido?

select sum(SD.OrderQty)as [art�culos vendidos  con precio de lista menor a $1,200] from SalesLT.Product PR
join SalesLT.SalesOrderDetail SD on SD.ProductID = PR.ProductID
where PR.ListPrice < 1200

-- Inge, se me pas� un 0 en 1,200 y puse que eran 2087 productos vendidos
-- pero ya est� coprregido el Query XD

