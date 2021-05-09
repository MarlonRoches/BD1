--1  Obtener el nombre y dirección de la tienda con más inventario en bodega (más unidades de producto)

WITH TiendaConMasVentas (store_id, [Stock General]) AS 
	( 
		select store_id,sum(quantity)  as [Stock General] from production.stocks
		group by store_id  
	)

select  top 1 St.store_name , St.street , [Stock General] from TiendaConMasVentas
join sales.stores St on St.store_id = TiendaConMasVentas.store_id
order by [Stock General] desc

-- 2 Obtener el detalle de los clientes que han realizado más de una compra.

WITH ClientesConMasDe1Compra (customer_id, [Num de Pedidos]) AS 
	( 
		select customer_id, count(order_id) as [Num de Pedidos] from sales.orders
		group by customer_id  
	)

select ClientesConMasDe1Compra.customer_id, ( CU.first_name+' '+CU.last_name) as [Nombre Completo],
CU.email, (CU.state+', '+CU.city +', '+CU.street) as [Address] from ClientesConMasDe1Compra
join sales.customers CU on CU.customer_id = ClientesConMasDe1Compra.customer_id
where ClientesConMasDe1Compra.[Num de Pedidos] > 1


-- 3 Obtener el listado de marcas que hayan realizado alguna venta de bicicletas eléctricas en California (CA)

select store_id as [Tiendas que han vendido Electricas en CA ] from sales.order_items OI
join production.products PR on PR.product_id = OI.product_id
join sales.orders SR on SR. order_id = OI.order_id
join sales.customers CU on CU.customer_id = SR.customer_id
where PR.category_id =5  and CU.state = 'CA'
group by store_id 



--4 Obtener el nombre y dirección de las tienda con menos personal y realizó más ventas.

-- Mas Ventas
	WITH TiendaConMASVentas (store_id, [Total Ventas]) AS 
	( 
		select store_id, COUNT(order_id) as [Total Ventas] from sales.orders
		group by store_id
	)

	select top 1 TiendaConMASVentas.store_id,st.store_name , (st.state+', '+st.city +', '+st.street) as [Address], [Total Ventas] from TiendaConMasVentas 
		join sales.stores st on st.store_id = TiendaConMASVentas.store_id
		order by [Total Ventas] desc

-- Menos Staff
	
	WITH TiendaConMENOSpersonal (store_id, [Total Empleados]) AS 
	( 
		select store_id , count(staff_id) as [Total Empleados]from sales.staffs
	group by store_id
	)

	select top 1 st.store_name , (st.state+', '+st.city +', '+st.street) as [Address], [Total Empleados] from TiendaConMENOSpersonal 
	join sales.stores st on st.store_id = TiendaConMENOSpersonal.store_id
	order by [Total Empleados] asc
