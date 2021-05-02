

--1.
/*****	Check	*****/	
select [Id Albañil], Mes, [Horas trabajadas x mes], SalarioBase, HorasExtras, [Q. PagoHorasExtras] from [calculo de horas extras]
where [Q. PagoHorasExtras] >0
order by [Q. PagoHorasExtras] desc

--2.
	
/*****	Check	*****/	
select distinct PR.CodigoProyecto,  
count (DATEPART(HOUR,HoraDeEntrada))as [Cantidad], 
DATEPART(HOUR,HoraDeEntrada) as[Hora De Entrada (24h)] 
from PROYECTOS PR
join [MANO DE OBRA] MO on MO.FK_CodigoProyecto= PR.CodigoProyecto
join ALBAÑIL AL on AL.IDAlbañil= MO.FK_IDAlbañil
join NOMINA_ALBAÑIL NAL on NAL.FK_IDAlbañil = AL.IDAlbañil
group by PR.CodigoProyecto , (DATEPART(HOUR,HoraDeEntrada))
order by  PR.CodigoProyecto, count (DATEPART(HOUR,HoraDeEntrada))desc		
--HORAS DE SALIDA MAS COMUNES 
select distinct CodigoProyecto,count([Hora De Salida]) as [Iteraciones] , [Hora De Salida] from
(
select PR.CodigoProyecto,
(
case 
when (DATEPART(HOUR,HoraDeEntrada) + HorasTrabajadas) > 24 then (DATEPART(HOUR,HoraDeEntrada) + HorasTrabajadas)-24 
else (DATEPART(HOUR,HoraDeEntrada) + HorasTrabajadas) end 
)
as [Hora De Salida] 
from NOMINA_ALBAÑIL NA
join ALBAÑIL AL on NA.FK_IDAlbañil = AL.IDAlbañil
join [MANO DE OBRA] MO on AL.IDAlbañil = MO.FK_IDAlbañil
join PROYECTOS PR on MO.FK_CodigoProyecto = pr.CodigoProyecto
) Resultado
group by CodigoProyecto , [Hora De Salida]
order by  CodigoProyecto, count([Hora De Salida]) desc

--3.
/*****	Check	*****/	
	
select CONEMP.IDContrato, SalarioBase, FechaFinal, FechaFinal , CONEMP.FK_IDEmpleado  from PROYECTOS PR
join ALBAÑIL AL on AL.IDAlbañil = PR.FK_IDCapataz
join CONTRATO_EMPLEADO CONEMP on CONEMP.FK_IDEmpleado = AL.IDAlbañil

--4.
/*****	Check	*****/	
select top 1 Arq.[ID Arquitecto] ,count(Pry.CodigoProyecto) as[Proyectos Realizados]
from PROVEEDORES Prov   
join CONTRATO_PROVEEDOR ConProv on ConProv.FK_CodigoProveedor = Prov.IDProveedor
join PROYECTOS Pry on Pry.CodigoProyecto = ConProv.FK_CodigoProyecto
join ARQUITECTO Arq on Arq.[ID Arquitecto] = Pry.FK_IDArquitecto
group by Arq.[ID Arquitecto]
order by [Proyectos Realizados] desc


--5.
	/*****	Check	*****/	
select Rot.IDRotacion , FK_IDVendedor, Src.CodigoProyecto, Src.Presupuesto_Total as [Presupuesto x 1000] from
(
select top 1 Rot.IDRotacion,ConPry.Presupuesto_Total,Pry.CodigoProyecto, ven.IDVendedor from CONTRATO_PROYECTO ConPry
join VENDEDOR Ven on ven.IDVendedor = ConPry.FK_ID_Vendedor
join ROTACIONES Rot on rot.FK_IDVendedor = ven.IDVendedor
join PROYECTOS Pry on Pry.FK_IDContrato = ConPry.IDContrato
order by ConPry.Presupuesto_Total desc
) Src
join ROTACIONES Rot on Rot.FK_CodigoProyecto = Src.CodigoProyecto

--6.
	/*****	Check	*****/	
select * into #AlbañilesPorObra from 
(
select top 2 FK_CodigoProyecto , COUNT(FK_IDAlbañil) as [Obreros Asignados] from [MANO DE OBRA]
group by FK_CodigoProyecto 
order by COUNT(FK_IDAlbañil)asc
) Src 
select * from #AlbañilesPorObra
select ConProv.FK_CodigoProyecto as [Codigo Proyecto], Fac.[Tipo De Material] from FACTURA Fac
join CONTRATO_PROVEEDOR ConProv on ConProv.[ID ContratoConProveedor] = Fac.FK_IDContratoConProveedor
join PROYECTOS Proy on Proy.CodigoProyecto = ConProv.FK_CodigoProyecto
join #AlbañilesPorObra on #AlbañilesPorObra.FK_CodigoProyecto = Proy.CodigoProyecto
order by [Codigo Proyecto] asc
drop table #AlbañilesPorObra

--7
/*****	Check	*****/	
select FK_IDContratoConProveedor, [Tipo De Material],
(SUM(PrecioxCantidad)/sum(Cantidad) ) as [Precio Promedio del material] 
from 
(
	select FK_IDContratoConProveedor, cantidad,[Tipo De Material], (Cantidad * [Costo Unitario]) as [PrecioxCantidad]from [Materiales por Proyecto activo]
) src
group by FK_IDContratoConProveedor, [Tipo De Material]
order by FK_IDContratoConProveedor

--8.
/*****	Check	*****/	

Select Prov.Nombre as [Nombre Proveedor] ,  [Q. Total de Venta]
from 
(
	select FK_IDContratoConProveedor,
	SUM(PrecioxCantidad) as [Q. Total de Venta]
	from 
	(
		select FK_IDContratoConProveedor, cantidad,[Tipo De Material], (Cantidad * [Costo Unitario]) as [PrecioxCantidad]from [Materiales por Proyecto activo]
	) src
	group by FK_IDContratoConProveedor
)
Src2
join CONTRATO_PROVEEDOR ConProv on ConProv.[ID ContratoConProveedor] = Src2.FK_IDContratoConProveedor
join PROVEEDORES Prov on Prov.IDProveedor = ConProv.FK_CodigoProveedor
where [Q. Total de Venta] > 1000000 -- CAMBIAR A 100 000


-- 9. El historial del proyecto con menos maquinaria asignada y la planilla más grande. 
/*****	Check	*****/	
/*Proyecto con las La mayor Gente asignada*/
select B.CodigoProyecto as [Proyecto con mas Gente Asignada], H.IDHistorial, H.FechaDeRegistro
from
(
	select top 1 FK_CodigoProyecto as CodigoProyecto ,count(FK_IDAlbañil) as [Gente Asignada]  from [MANO DE OBRA]
	group by FK_CodigoProyecto
	order by [Gente Asignada] desc
)  B
join HISTORIAL H on H.FK_CodigoProyecto = B.CodigoProyecto

/*Proyecto con las La menor cantidad de  Maquinaria asignada*/
select B.CodigoProyecto as [Proyecto con mas Maquinaria Asignada], H.IDHistorial, H.FechaDeRegistro
from
(
	select top 1 FK_CodigoProyecto as CodigoProyecto ,count(PLACA) as [Maquinaria Asignada]  from MAQUINARIA
	group by FK_CodigoProyecto
	order by [Maquinaria Asignada] asc
)  B
join HISTORIAL H on H.FK_CodigoProyecto = B.CodigoProyecto



--10.
/*****	Check	*****/	
select Prov.IDProveedor, Prov.Nombre as [Nombre del Proveedor] , [Materiales Otorgados Distintos]from
(
	select FK_IDContratoConProveedor, sum([Materiales Otorgados]) as [Materiales Otorgados Distintos] from 
	(
		select FK_IDContratoConProveedor , COUNT([Tipo De Material]) as [Materiales Otorgados] from [Materiales por Proyecto activo]
		group by FK_IDContratoConProveedor,[Tipo De Material]
	) a
	group by FK_IDContratoConProveedor
) src
join CONTRATO_PROVEEDOR ConProv on ConProv.[ID ContratoConProveedor] = src.FK_IDContratoConProveedor
join PROVEEDORES Prov on Prov.IDProveedor = ConProv.FK_CodigoProveedor
where [Materiales Otorgados Distintos] > 5



--11. 
/*****	Check	*****/	
select ConEmp.FK_IDEmpleado as[Id Arquitecto],
SalarioBase as [Q. Salario],
CONCAT(ConEmp.FechaFinal ,' -> ', ConEmp.FechaFinal) as [Rango de Empleo]
from (
	select CodigoProyecto, sum([Cantidad x Costo]) as [Total Gastado]from 
	(
		select CodigoProyecto,FK_IDContratoConProveedor,[Tipo De Material], sum(Cantidad)as [Num Unidades], (Cantidad*[Costo Unitario]) as [Cantidad x Costo]
		from [Materiales por Proyecto activo]
		group by CodigoProyecto,FK_IDContratoConProveedor , [Tipo De Material], Cantidad, [Costo Unitario]
	) SRC
	group by CodigoProyecto
	)  src2
join [Presupuesto Real] Pr on Pr.CodigoProyecto = src2.CodigoProyecto
join PROYECTOS Pry on Pry.CodigoProyecto = src2.CodigoProyecto
join ARQUITECTO Arq on Arq.[ID Arquitecto] = Pry.FK_IDArquitecto
join CONTRATO_EMPLEADO ConEmp on ConEmp.FK_IDEmpleado = Arq.[ID Arquitecto]
where pr.Presupuesto< src2.[Total Gastado]


--12.
/*****	Check	*****/	
select Cl.NIT,
Cl.Nombre,
Cl.Direccion,
Cl.Telefono
from
(
	select FK_NIT_Cliente , COUNT(DPIVisita) as [visitas Diferentes] from VISITA
	group by FK_NIT_Cliente
) src
join CLIENTE Cl on Cl.NIT = src.FK_NIT_Cliente
where src.[visitas Diferentes] > 6


--13.
/*****	Check	*****/	

select Cl.NIT,
Cl.Nombre,
Cl.Direccion,
Cl.Telefono
from
(
	select top 1 CodigoProyecto, [Costo Unitario] from [Materiales por Proyecto activo]
	order by [Costo Unitario] desc
) src
join PROYECTOS Pry on Pry.CodigoProyecto = src.CodigoProyecto
join CONTRATO_PROYECTO conPry on conPry.IDContrato = pry.FK_IDContrato
join CLIENTE cl on cl.NIT = conPry.FK_NIT_Cliente



--14.
	/*****	Check	*****/	

select src.CodigoProyecto,
Maq.*,
[# Materiales Distintos] as [Tipos de material de construcción diferentes]
from
(
	select top 1 CodigoProyecto, count(distinct [Tipo De Material]) as [# Materiales Distintos] from [Materiales por Proyecto activo]
	group by CodigoProyecto 
	order by [# Materiales Distintos] desc
) src
join MAQUINARIA Maq on Maq.FK_CodigoProyecto = src.CodigoProyecto


--15.
	/*****	Check	*****/	

select ConEmp.FK_IDEmpleado as[Id Capataz],
SalarioBase as [Q. Salario],
CONCAT(ConEmp.FechaFinal ,' -> ', ConEmp.FechaFinal) as [Rango de Empleo],
[Total Gastado],
Pr.Presupuesto
from (
	select CodigoProyecto, sum([Cantidad x Costo]) as [Total Gastado]from 
	(
		select CodigoProyecto,FK_IDContratoConProveedor,[Tipo De Material], sum(Cantidad)as [Num Unidades], (Cantidad*[Costo Unitario]) as [Cantidad x Costo]
		from [Materiales por Proyecto activo]
		group by CodigoProyecto,FK_IDContratoConProveedor , [Tipo De Material], Cantidad, [Costo Unitario]
	) SRC
	group by CodigoProyecto
	)  src2
join [Presupuesto Real] Pr on Pr.CodigoProyecto = src2.CodigoProyecto
join PROYECTOS Pry on Pry.CodigoProyecto = src2.CodigoProyecto
join ALBAÑIL Alb on Alb.IDAlbañil = Pry.FK_IDCapataz
join CONTRATO_EMPLEADO ConEmp on ConEmp.FK_IDEmpleado = Alb.IDAlbañil
where pr.Presupuesto> src2.[Total Gastado]



--16.
	/*****	Check	*****/	

select * into #MenorPresupuesto from
( /*menos presupuesto */
select top 1 CodigoProyecto , Presupuesto from [Presupuesto Real]
order by Presupuesto asc	
) Src

select CodigoProyecto, [# Materiales Vendidos] into #MenosCantidadVendida 
from
( /*más cantidad de material aprovisionado.*/
	select top 1 CodigoProyecto , sum(Cantidad) as [# Materiales Vendidos] from [Materiales por Proyecto activo]
	group by CodigoProyecto
	order by [# Materiales Vendidos] desc
) src

select Mo.FK_IDAlbañil as [ID Albañiles en el proyecto con menos presupuesto]from #MenorPresupuesto
join [MANO DE OBRA] MO on MO.FK_CodigoProyecto = #MenorPresupuesto.CodigoProyecto
join [calculo de horas extras] HE on HE.[id Albañil] = Mo.FK_IDAlbañil
where HE.HorasExtras >0

select FK_IDAlbañil as [ID Albañiles en el proyecto con mayor cantidad material] from #MenosCantidadVendida
join [MANO DE OBRA] MO on MO.FK_CodigoProyecto = #MenosCantidadVendida.CodigoProyecto
join [calculo de horas extras] HE on HE.[id Albañil] = Mo.FK_IDAlbañil
where HE.HorasExtras >0
drop table #MenosCantidadVendida
drop table #MenorPresupuesto


--17.
	/*****	Check	*****/	


select FK_CodigoProyecto , [Visitas De Vendedores] into #MenosVisitasDeVendedores from
(
	select top 1 FK_CodigoProyecto, count(FK_IDVendedor) as [Visitas De Vendedores] from ROTACIONES
	group by FK_CodigoProyecto
	order by [Visitas De Vendedores] asc
) Src
select [id albañil],[Total de horas Trabajado]  into #HorasPorTrabajador  from
(
select [id albañil], sum([horas trabajadas x mes]) as [Total de horas Trabajado] from [calculo de horas extras]
 group by [id albañil]
 ) src
/*menos visitas de los vendedores*/
 select 
 ConProy.FK_NIT_Cliente as [Nit Del Cliente], 
ConProy.Presupuesto_Total, 
ConProy.Direccion, 
ConProy.FechaRealDeEntrega, 
 proy.FK_IDArquitecto,
 proy.FK_IDCapataz,
 proy.CodigoProyecto,
 MvV.[Visitas De Vendedores]
 from #MenosVisitasDeVendedores MvV
 join PROYECTOS proy on proy.CodigoProyecto = MvV.FK_CodigoProyecto
join CONTRATO_PROYECTO ConProy on ConProy.IDContrato = proy.FK_IDContrato
/*con menos horas-hombre trabajadas por albañiles*/
select 
ConProy.FK_NIT_Cliente as [Nit Del Cliente], 
ConProy.Presupuesto_Total, 
ConProy.Direccion, 
ConProy.FechaRealDeEntrega, 
 proy.FK_IDArquitecto,
 proy.FK_IDCapataz,
Src.FK_CodigoProyecto as [CodigoProyecto],
src.[Horas x Trabajador] 
from
(
	select  top 1 FK_CodigoProyecto, count([id albañil]) as [Albañiles Asignados], sum([Total de horas Trabajado])as [horas trabajadas],
	(sum([Total de horas Trabajado])/count([id albañil])) as [Horas x Trabajador]
	from #HorasPorTrabajador
	join [MANO DE OBRA] MO on MO.FK_IDAlbañil = #HorasPorTrabajador.[id albañil]
	group by FK_CodigoProyecto
	order by [Horas x Trabajador] asc
) Src
join PROYECTOS proy on proy.CodigoProyecto = src.FK_CodigoProyecto
join CONTRATO_PROYECTO ConProy on ConProy.IDContrato = proy.FK_IDContrato

DROP TABLE #MenosVisitasDeVendedores
DROP TABLE #HorasPorTrabajador



--18.
/*****	Check	*****/	
select SRC.FK_IDEmpleado , SRC.FechaInicial ,Mo.FK_CodigoProyecto from 
(
select top 1 FechaInicial ,FK_IDEmpleado  from CONTRATO_EMPLEADO ConEmp
join ALBAÑIL Al on Al.IDAlbañil = ConEmp.FK_IDEmpleado
order by FechaInicial asc
) SRC
join [MANO DE OBRA] MO on MO.FK_IDAlbañil = SRC.FK_IDEmpleado



--19.
/*****	Check	*****/	

select Tipo, 
COUNT(CodigoProyecto) as [# Proyectos en Categorias] ,
(sum([Num Empleados] ) /COUNT(CodigoProyecto)) as [Prom # De Empleados],--/COUNT(CodigoProyecto)),
(sum([Num Maquinas Asignadas])/COUNT(CodigoProyecto)) as [Prom # De Maquinas],--/COUNT(CodigoProyecto)),
(sum(Presupuesto)/COUNT(CodigoProyecto)) as [Prom De Presupuesto]--/COUNT(CodigoProyecto))
from
(
select DT.CodigoProyecto, 
DT.[Num Empleados],
DT.[Num Maquinas Asignadas],
DT.Presupuesto,
ConPry.Tipo  from GatosGenerales DT
join PROYECTOS Pry on Pry.CodigoProyecto = DT.CodigoProyecto
join CONTRATO_PROYECTO ConPry on ConPry.IDContrato = Pry.FK_IDContrato
) src
group by Tipo



--20. El tipo de máquina que se usó más en los proyectos ya terminados.
/*****	Check	*****/	
select Top 1 Mqn.Nombre as [Tipo de Maquinaria],count(*) as [Usos en Proyecto] ,
STRING_AGG(Pry.CodigoProyecto,',') as [Proyectos en los que se usa] from MAQUINARIA Mqn
join PROYECTOS Pry on Pry.CodigoProyecto = Mqn.FK_CodigoProyecto
group by Nombre