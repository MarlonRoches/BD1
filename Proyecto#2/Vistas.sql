-- Vamos a Almacenar los materiales y a que proyecto activo pertenecen
create view [Materiales por Proyecto activo] as (
select FK_IDContratoConProveedor , [Costo Unitario] , [Tipo De Material] ,Cantidad , CodigoProyecto from FACTURA Fac
join CONTRATO_PROVEEDOR ConProv on ConProv.[ID ContratoConProveedor] = Fac.FK_IDContratoConProveedor
join PROYECTOS Proy on Proy.CodigoProyecto = ConProv.FK_CodigoProyecto)

--drop view [Materiales por Proyecto activo]
--select * from [Materiales por Proyecto activo] 

-- Vista para saber cuanto tiene gastado cada uno de los proyectos activos 
create view [Gasto en Materiales] as
select FK_CodigoProyecto ,  [total Gastado]
from (
select FK_CodigoProyecto, sum(src.[Costo x cantidad]) as [total Gastado]  from 
	(
		select FK_CodigoProyecto, [Costo Unitario], [Tipo De Material], Cantidad, 
		([Costo Unitario] * Cantidad) as [Costo x cantidad]
		from factura
	) src	
group by FK_CodigoProyecto
) Src



--Presupuesto Real
-- Saber el presupuesto real de un proyecto activo
create view [Presupuesto Real] as
(
select Pry.CodigoProyecto, (ConPry.Presupuesto_Total *1000) as [Presupuesto] from CONTRATO_PROYECTO ConPry
	join PROYECTOS Pry on Pry.FK_IDContrato = ConPry.IDContrato 
)

select * from [Presupuesto Real]


--VISTA DE CALCULO de las hortas extras
--
create view [Calculo de Horas Extras] as 
(

select [Id Albañil] , Mes , [Horas trabajadas x mes], SalarioBase , 
(
case 
when [Horas trabajadas x mes] > 180 then ([Horas trabajadas x mes]-180)
else 0
end
) as HorasExtras,
(
case 
when [Horas trabajadas x mes] > 180 then ([Horas trabajadas x mes]-180) * 15
else 0
end
) as [Q. PagoHorasExtras]
from
(
select FK_IDAlbañil as [Id Albañil], DATEPART(MONTH, Fecha) as Mes, sum(HorasTrabajadas) as [Horas trabajadas x mes] 
,CONEMP.SalarioBase from NOMINA_ALBAÑIL
join CONTRATO_EMPLEADO CONEMP on CONEMP.FK_IDEmpleado = FK_IDAlbañil
group by CONEMP.SalarioBase, FK_IDAlbañil, DATEPART(MONTH, Fecha)
) 
Resultado
)


--obtenemos el numero de maquinas asignadas para cada uno de los proyectos
create view NumMaquinas as
(
select FK_CodigoProyecto, COUNT(distinct MAQUINARIA.PLACA) as [Num Maquinas Asignadas] from MAQUINARIA
	group by FK_CodigoProyecto
)


--obtenemos el numero de los empleados asignados para cada uno de los proyectos
create view NumEmpleados as
(
select FK_CodigoProyecto, COUNT(FK_IDAlbañil) as [Num Empleados] from [MANO DE OBRA]
	group by FK_CodigoProyecto
)



--Obtenemos los datos mas generales de las principales areas para los proyectos
create view GatosGenerales as
(
	select PR.CodigoProyecto,
	[Num Empleados],
	[Num Maquinas Asignadas],
	[total Gastado],
	Presupuesto
	from [NumEmpleados] Emp
	join NumMaquinas Maq on Maq.FK_CodigoProyecto = Emp.FK_CodigoProyecto
	join [Gasto en Materiales] GM on GM.FK_CodigoProyecto = Maq.FK_CodigoProyecto 
	join [Presupuesto Real] PR on PR.CodigoProyecto =GM.FK_CodigoProyecto

)



--Obtenemos los promedios mas generales de las principales areas para los proyectos
create view DatosProm as
(
select Tipo, 
COUNT(CodigoProyecto) as [# Proyectos en Categorias] ,
STRING_AGG(CodigoProyecto,',') as [IDs Proyectos en Categorias] ,
(sum([Num Empleados] ) /COUNT(CodigoProyecto)) as [Prom # De Empleados],--/COUNT(CodigoProyecto)),
(sum([Num Maquinas Asignadas])/COUNT(CodigoProyecto)) as [Prom # De Maquinas],--/COUNT(CodigoProyecto)),
(sum(Presupuesto)/COUNT(CodigoProyecto)) as [Prom De Presupuesto]--/COUNT(CodigoProyecto))
--group_concat()
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
)
