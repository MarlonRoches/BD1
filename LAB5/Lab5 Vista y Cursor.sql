--1.Crear una vista con el número de orden, el nombre completo del cliente, la dirección de
--envío (concatenar AddressLine1, City, StateProvince, CountryRegion y PostalCode)
--junto con la cantidad total de productos que compró y el total a pagar.
create view [Compras] as
(
	select SalesOrderID, SUM(OrderQty)as [#Productos], SUM(LineTotal) as [Total a PAgar]from SalesLT.SalesOrderDetail 
	group by SalesOrderID
)

create view [Cliente y Compras] as
(
	select SOH.SalesOrderID, 
	(FirstName +' '+ LastName) as [Nombre Completo],
	 (AD.AddressLine1 +' '+ AD.City +' '+AD.StateProvince +' '+ AD.CountryRegion +' '+ AD.PostalCode ) as [Direccion De Envio],
	 IPA.[#Productos],
	 IPA.[Total a PAgar]
	 from SalesLT.SalesOrderHeader SOH
	join SalesLT.Customer CU on CU.CustomerID = SOH.CustomerID
	join SalesLT.CustomerAddress CUA on CUA.CustomerID = CU.CustomerID
	join SalesLT.Address AD on AD.AddressID = CUA.AddressID
	join [Compras] IPA on IPA.SalesOrderID = SOH.SalesOrderID
)

select [Cliente y Compras].SalesOrderID, 
[Cliente y Compras].[Nombre Completo],
[Cliente y Compras].[Direccion De Envio], 
[Cliente y Compras].#Productos,
[Cliente y Compras].[Total a PAgar]
from [Cliente y Compras]


--2. Implementando un cursor y utilizando tablas temporales, calcular la suma total de cada
--orden de compra, sumando las columnas 
--SubTotal, TaxAmt y Freight. 
--Luego, actualizar
--la columna TotalDue aplicando un descuento según el siguiente criterio:
--a. 0 < TotalDue < 5000 - 5%
--b. 5001 < TotalDue < 10000 - 10%
--c. 10001 < TotalDue < 25000 - 15%
--d. Totaldue > 25000 - 20%

select SalesOrderID,TaxAmt,SubTotal, Freight, TotalDue into #Temp from
(
	select SalesOrderID,TaxAmt,SubTotal, Freight, TotalDue from SalesLT.SalesOrderHeader
)Src
-- While
declare 
@ID float =0, 
@TaxAmt float=0, 
@SubTotal float=0, 
@Freight float=0,
@TempTotalDue float =0

declare Cur_TotaldeCompra Cursor
	for 
		select SalesOrderID,TaxAmt,SubTotal, Freight from #Temp

	open Cur_TotaldeCompra
	fetch Cur_TotaldeCompra into @ID,@TaxAmt,@SubTotal ,@Freight
	
	while(@@FETCH_STATUS =0)
		begin

			-- AREA DE SUMA
			set @TempTotalDue =@TempTotalDue +@TaxAmt+@SubTotal+@Freight
			-- AREA DE SUMA /

			-- AREA DE IF
		--a. 0 < TotalDue < 5000 - 5%
			if (@TempTotalDue between 0  and 5000) set @TempTotalDue= @TempTotalDue - (@TempTotalDue*0.05)
		--b. 5001 < TotalDue < 10000 - 10%
			else if (@TempTotalDue between 5001  and 10000) set @TempTotalDue= @TempTotalDue - (@TempTotalDue*0.1) 
		--c. 10001 < TotalDue < 25000 - 15%
			else if (@TempTotalDue between 10001  and 25000) set @TempTotalDue= @TempTotalDue - (@TempTotalDue*0.15)
		--d. Totaldue > 25000 - 20%
			else if (@TempTotalDue>25000) set @TempTotalDue= @TempTotalDue - (@TempTotalDue*0.2)
			
			-- AREA DE IF/

			print cast( @ID as varchar)+' | '
			+cast(@TaxAmt as varchar) +' | '
			+cast(@SubTotal as varchar) +' | '
			+cast(@Freight as varchar) +' | '
			+cast(@TempTotalDue as varchar)
			
			update #Temp
			set TotalDue = @TempTotalDue
			where SalesOrderID = cast (@ID as int)

			set @TempTotalDue =0
			fetch Cur_TotaldeCompra into @ID,@TaxAmt,@SubTotal ,@Freight
		end

	close Cur_TotaldeCompra
deallocate Cur_TotaldeCompra
select SalesOrderID,TaxAmt,SubTotal, Freight, TotalDue from #Temp
drop table #Temp