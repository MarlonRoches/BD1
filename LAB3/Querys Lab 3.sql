use AdventureWorks2017

--1. ¿Cuáles son las 3 ciudades con más direcciones registradas?
select top 3 count(*) as Cantidad, city from SalesLT.Address
group by City
order by Cantidad desc

--2. ¿cuántos códigos postales terminan con 0?
select count (*) as [Codigos Terminados En 0] from SalesLT.Address
where PostalCode like '%0'

--3. ¿Cuál es el nombre de la empresa que tiene más clientes y cuántos clientes tiene?
select top 1 count (*) as Cantidad ,CompanyName as Empresa from SalesLT.Customer	
group by CompanyName
order by Cantidad desc

--4. ¿Cuántas direcciones de usuario de tipo shipping existen?
select count(*) as [TotalDirecciones De Shipping] from SalesLT.CustomerAddress
where AddressType = 'Shipping'

--5. ¿Cuál es el producto con el precio más bajo?
select top 1 Name as [Producto mas Barato], ListPrice as Precio from SalesLT.Product
order by ListPrice asc

--6. ¿Cuales son los promedios de peso de los productos por modelo?
select ProductModelID, (sum(Weight)/count(*)) as Peso_promedio 
from SalesLT.Product
group by ProductModelID
order by Peso_promedio desc

--7. ¿Cuántos modelos tienen un promedio de peso mayor a 0?
select ProductModelID , (sum(Weight)/count(*)) as Peso_promedio 
from SalesLT.Product
where Weight>0
group by ProductModelID
order by Peso_promedio desc

--8. ¿Cuántos productos tienen la palabra "Road" en su nombre?
	select COUNT(*)  as [Contienen "Road"] from SalesLT.Product
	where name like'%Road%'

--9. ¿A cuánto asciende la diferencia total entre costos y precio de los productos?
	select  sum (ListPrice-StandardCost) as [Diferencia Total Entre todos los productos]from SalesLT.Product
	

--10. ¿De qué color hay más productos en existencias y cuántas existencias hay?
select count (*) as Total , Color from SalesLT.Product
group by Color
order by Total desc

--11. ¿De cuánto fue el promedio de las ventas?
select (SUM(LineTotal)/ COUNT(*)) as PromedioDeVentas 
from SalesLT.SalesOrderDetail

--12. ¿Cuál es el ID de cliente que pagó más impuesto por su compra?
select top 1 CustomerID as Usuario ,sum (TaxAmt) as Impuesto from SalesLT.SalesOrderHeader
group by CustomerID
order by Impuesto desc

--13. ¿Cuál es el ID de cliente que pagó menos flete por su compra?
	select top 1 CustomerID as [Usuario], Freight as [Pago Por Flete]from  SalesLT.SalesOrderHeader
	order by Freight asc

--14. ¿Cuál es el ID de la venta más baja?
select top 1 SalesOrderID as [Id de Venta] , LineTotal as [Total Pagadp] from SalesLT.SalesOrderDetail
order by LineTotal asc

--15. ¿Cuál fue el total de ventas por cliente?
select CustomerID , sum(OrderQty) as [Total Elementos Comprados] , sum(LineTotal ) as [Total Gastado]/*,SUM(LineTotal) as Total*/ from SalesLT.SalesOrderHeader Hd
inner join SalesLT.SalesOrderDetail Ord  on Hd.SalesOrderID = Ord.SalesOrderID
group by CustomerID


--16. ¿Cuántos clientes tuvieron un total de ventas mayor a 50,000?
select SalesOrderID, CustomerID, TotalDue from SalesLT.SalesOrderHeader
where TotalDue> 50000
order by TotalDue desc

--17. ¿Cuál es el producto que más se vendió?
select top 1 prod.name , SUM(OrderQty) as Vendidos from SalesLT.SalesOrderDetail A
inner join SalesLT.Product Prod on A.ProductID = Prod.ProductID
group by prod.Name
order by Vendidos desc

--18. ¿Cuántas unidades se vendieron del producto más vendido? (tome en cuenta la
--cantidad que despacha en cada venta)
select top 1 ProductID, sum (OrderQty) as TotalVendidos from SalesLT.SalesOrderDetail 
group by ProductID 
order by TotalVendidos desc


--19. ¿Cuántos productos por venta se despacharon?
select SalesOrderID,SUM(OrderQty) as ItemsPorOrden from SalesLT.SalesOrderDetail
group by SalesOrderID
order by ItemsPorOrden

--20. ¿En cuántas ventas se despacharon más de 8 productos?
--ARREGLAR
select SalesOrderID as IDS, sum(OrderQty) as NumItems from SalesLT.SalesOrderDetail 
group by SalesOrderID
having SUM(OrderQty) > 8
