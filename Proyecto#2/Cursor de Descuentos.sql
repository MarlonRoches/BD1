select src.CodigoProyecto, ConPry.Nombre,
ConPry.Tipo,
ConPry.Presupuesto_Total
,[# de proveedores],
[#Tipos de Material]
into #ProvyMats from 
(
	select CodigoProyecto, count(distinct FK_IDContratoConProveedor) as [# de proveedores]
	,  COUNT(distinct [Tipo De Material]) as [#Tipos de Material] from [Materiales por Proyecto activo]
	group by CodigoProyecto
) Src
join PROYECTOS pry on pry.CodigoProyecto = src.CodigoProyecto
join CONTRATO_PROYECTO ConPry on ConPry.IDContrato = pry.FK_IDContrato
	--select * from #ProvyMats
	
------------------------------------------

declare @ID int, 
@NumProveedores float, 
@NumTipMats float,
@Descuento float, 
@Presupuesto float ,
@NuevoPresupuesto float,
@nombre varchar(500),
@Tipo	varchar(500)

declare CursorClientes Cursor for 
	select CodigoProyecto, [# de proveedores],[#Tipos de Material] , Presupuesto_Total, Nombre,Tipo
	from  #ProvyMats

		open CursorClientes
	fetch CursorClientes into @ID,@NumProveedores,@NumTipMats, @Presupuesto, @Nombre, @Tipo --,@Descuento

	while(@@FETCH_STATUS = 0)
	begin
	--
	set @Descuento = 0
	set @NuevoPresupuesto= 0
	
	IF (@NumProveedores between 0 and 5)
      set @NuevoPresupuesto = (@Presupuesto - (@Presupuesto * 0.02))  
	--

	IF (@NumTipMats between 1 and 8)			
		set @NuevoPresupuesto = (@Presupuesto - (@Presupuesto * 0.20)) 
		--set @Descuento = @Descuento + @Descuento 0.04
	ELSE  IF (@NumTipMats between 8 and 15)		
		set @NuevoPresupuesto = (@Presupuesto - (@Presupuesto * 0.15))  
	ELSE  IF (@NumTipMats between 15 and 24)	
		set @NuevoPresupuesto = (@Presupuesto - (@Presupuesto * 0.09))
	ELSe
		set @NuevoPresupuesto = (@Presupuesto - (@Presupuesto * 0.04))



	    --nuevo presuppuesto  => (pres - (desc * pres))
	    set @Descuento =( (@Presupuesto- @NuevoPresupuesto) / @Presupuesto) *100
		declare @TotalDecuento float  
		set @TotalDecuento   =@Presupuesto- @NuevoPresupuesto

		print 'ID:'+
		cast(@ID as varchar) + 
		' Nombre:'+ 
		cast(@Nombre as varchar) + 
		' Tipo'+ 
		cast(@Tipo as varchar) + 
		' #Proveedores:'+ 
		cast(@NumProveedores as varchar) 
		+ ' #Tipos:'+ 
		cast(@NumTipMats as varchar)
		+ ' Descuento:'+ 
		cast(@Descuento as varchar) 
		+ '% Total Dwscuento:'+ 
		cast(@TotalDecuento as varchar) 
		+ ' Presupuesto Anterior:'+ 
		cast(@Presupuesto as varchar)
		+ ' Nuevo Presupuesto: '+ 
		cast( @NuevoPresupuesto as varchar)  
	
	fetch CursorClientes into @ID,@NumProveedores,@NumTipMats, @Presupuesto, @Nombre, @Tipo --,@Descuento
	end

-- Clean
close CursorClientes
deallocate CursorClientes
Drop table #ProvyMats

------------------------------------------


