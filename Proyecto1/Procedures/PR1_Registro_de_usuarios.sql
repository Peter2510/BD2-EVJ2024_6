CREATE PROCEDURE proyecto1.PR1
    @FirstName nvarchar(100),
    @LastName nvarchar (100),
    @Email nvarchar (100), 
    @DateOfBirth datetime2,
    @Password nvarchar (100),
    @credits int
AS
BEGIN
    Begin try
        BEGIN TRANSACTION;
        --declaraciones
        DECLARE @Description NVARCHAR(max);
        DECLARE @ErrorSeverity INT; 
        -- Buscar el rol estudiante
        DECLARE @idRol nvarchar(150); 
        DECLARE @valido BIT;
        -- mira el rol estudiante
        SELECT @idRol = id FROM Roles WHERE RoleName = 'Student';
        IF (@idRol is NULL)
        BEGIN
            SET @Description = 'Inserción fallida: el Rol no existe';
            SELECT @Description AS 'Error';
            SET @ErrorSeverity = 18; 
            RAISERROR(@Description, @ErrorSeverity, 1);
            RETURN;
        END
        -- Validaciones QUE NO SEA ''
        IF (@FirstName = '' OR @LastName = '' OR @Email = '' OR @Password = '')
        BEGIN
            SET @Description = 'Inserción fallida: No se permite que algún valor este vacio';
            SELECT @Description AS 'Error';
            SET @ErrorSeverity = 18; 
            RAISERROR(@Description, @ErrorSeverity, 1);
            RETURN;
        END
        -- QUE NO SEA NULO
	       IF (@FirstName IS NULL  OR
	        @LastName IS NULL OR
	        @Email IS NULL OR 
	        @Password IS NULL or @DateOfBirth IS NULL OR
            @credits IS NULL)
        BEGIN
            SET @Description = 'Inserción fallida: No se permite que algún valor sea nulo';
            SELECT @Description AS 'Error';
            SET @ErrorSeverity = 18; 
            RAISERROR(@Description, @ErrorSeverity, 1);
            RETURN;
        END

        -- Verificar que no exista el correo en otro usuario
        IF EXISTS (SELECT 1 FROM Usuarios WHERE Email = @Email)
        BEGIN
            SET @Description = 'Inserción fallida: ya existe el usuario con este correo registrado';
            SELECT @Description AS 'Error';
            SET @ErrorSeverity = 18; 
            RAISERROR(@Description, @ErrorSeverity, 1);
            RETURN;
        END

             -- Verificación de créditos del estudiante
        IF (@credits < 0)
        BEGIN
            SET @Description = 'Inserción fallida: Los creditos no deben ser negativos';
            SELECT @Description AS 'Error';
            SET @ErrorSeverity = 18; 
            RAISERROR(@Description, @ErrorSeverity, 1);
            RETURN;
        END

        EXEC proyecto1.PR6 'Usuarios', @Firstname, @Lastname, NULL, NULL, @valido OUTPUT;
        IF(@valido = 0)
        BEGIN
            SET @Description = 'Algun campo es incorrecto, los campos solo deben contener letras';
            SELECT @Description AS 'Error';
            SET @ErrorSeverity = 18; 
            RAISERROR(@Description, @ErrorSeverity, 1);
            RETURN;
        END

        -- Generar un nuevo ID para el usuario
        DECLARE @idUsuario UNIQUEIDENTIFIER;
        SET @idUsuario = NEWID();

        -- Insertar en la tabla Usuarios
        INSERT INTO proyecto1.Usuarios (Id, Firstname, Lastname, Email, DateOfBirth, Password, LastChanges, EmailConfirmed)
        VALUES (@idUsuario, @FirstName, @LastName, @Email, @DateOfBirth, @Password, GETDATE(), 1);

        -- Insertar en la tabla UsuarioRole
        INSERT INTO proyecto1.UsuarioRole (RoleId, UserId, IsLatestVersion)
        VALUES ( @idRol, @idUsuario, 1);

        -- Insertar en la tabla ProfileStudent
        INSERT INTO proyecto1.ProfileStudent ( UserId, Credits)
        VALUES ( @idUsuario, @credits);


        -- Insertar en la tabla TFA
        INSERT INTO proyecto1.TFA (UserId, Status, LastUpdate)
        VALUES (@idUsuario, 1, GETDATE());

        -- Enviar notificación
        DECLARE @mensaje nvarchar(200);
        SET @mensaje = N'El usuario ha sido registrado correctamente, puede ver su perfil';

        INSERT INTO proyecto1.Notification (UserId, Message, Date)
        VALUES (@idUsuario, @mensaje, GETDATE());

        -- HACER EL TRY
        COMMIT TRANSACTION;
        PRINT 'EL INGRESO HA SIDO EXITOSO';
    END TRY 
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Description = ERROR_MESSAGE();
        INSERT INTO proyecto1.HistoryLog (Date, Description)
        VALUES (GETDATE(), @Description);
        PRINT 'HUBO ERRORES EN LA TRANSACCION, ABORTANDOLA';
        RAISERROR(@Description, 18, 1);
    END CATCH
END;
