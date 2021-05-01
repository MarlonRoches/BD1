--Cliente #4: Empresa de construcción Urban Cities


--19. El presupuesto 
--costo total de materiales, 
--cantidad de empleados y 
--número de máquinas
--promedios por tipo de proyecto (casa, edificio, bodegas, etc).
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

