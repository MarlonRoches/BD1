--declaramos el cursor
declare Cursor1 Cursor
	for select * from SalesLT.Customer

--aborimos el cursor
open Cursor1
	--ya navegar
	Fetch Next from Cursor1
--cerramos el acceso
close cursor1
--sacamos de la Ram
deallocate Cursor1

-- While
declare @ID varchar(100), @NombreCliente varchar(100), @Compania varchar(100), @Email varchar(100)

declare CursorClientes Cursor
	for select CustomerID, concat(FirstName,' ' ,LastName ), 
	CompanyName, EmailAddress
		from SalesLT.Customer

		open CursorClientes
	fetch CursorClientes into @ID,@NombreCliente,@Compania ,@Email
	
	while(@@FETCH_STATUS =0)
	begin
	print @ID+' | '+@NombreCliente +' | '+@Compania +' | '+@Email
	fetch CursorClientes into @ID,@NombreCliente,@Compania ,@Email
	end

	close CursorClientes
	deallocate CursorClientes
	



	-- FOR
declare @Contador int =0;
declare @ID varchar(100), @NombreCliente varchar(100), @Compania varchar(100), @Email varchar(100)

declare CursorClientes Cursor
	for select CustomerID, concat(FirstName,' ' ,LastName ), 
	CompanyName, EmailAddress
		from SalesLT.Customer

		open CursorClientes
	fetch CursorClientes into @ID,@NombreCliente,@Compania ,@Email
	
	while(@Contador =<50)
	begin
	   SET @Contador = @Contador + 1;
	print @ID+' | '+@NombreCliente +' | '+@Compania +' | '+@Email
	fetch CursorClientes into @ID,@NombreCliente,@Compania ,@Email

	end

	close CursorClientes
	deallocate CursorClientes