CREATE PROCEDURE proyecto1.PR1
    @FirstName nvarchar(100),
    @LastName nvarchar (100),
    @Email nvarchar (100), 
    @DateOfBirth datetime2,
    @Password nvarchar (100),
    @credits int
AS
BEGIN
    BEGIN TRANSACTION;

    -- Buscar el rol estudiante
    DECLARE @idRol nvarchar(150); 
    SELECT @idRol = id FROM Roles WHERE RoleName = 'Student';

    -- Validaciones
    IF (@FirstName = '' OR @LastName = '' OR @Email = '' OR @Password = '')
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'NO HAY INFORMACION ASOCIADA';
        RETURN;
    END

    -- Verificar que no exista el correo en otro usuario
    IF EXISTS (SELECT 1 FROM Usuarios WHERE Email = @Email)
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'YA EXISTE EL CORREO EN OTRO USUARIO';
        RETURN;
    END

    -- Generar un nuevo ID para el usuario
    DECLARE @idUsuario UNIQUEIDENTIFIER;
    SET @idUsuario = NEWID();

    -- Insertar en la tabla Usuarios
    INSERT INTO Usuarios (Id, Firstname, Lastname, Email, DateOfBirth, Password, LastChanges, EmailConfirmed)
    VALUES (@idUsuario, @FirstName, @LastName, @Email, @DateOfBirth, @Password, GETDATE(), 0);

    -- Insertar en la tabla UsuarioRole
    INSERT INTO UsuarioRole (RoleId, UserId, IsLatestVersion)
    VALUES ( @idRol, @idUsuario, 1);

    -- Verificación de créditos del estudiante
    IF (@credits < 0)
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'UN ESTUDIANTE NO PUEDE TENER CREDITOS NEGATIVOS';
        RETURN;
    END

    -- Insertar en la tabla ProfileStudent
    INSERT INTO ProfileStudent ( UserId, Credits)
    VALUES ( @idUsuario, @credits);


    -- Insertar en la tabla TFA
    INSERT INTO TFA (UserId, Status, LastUpdate)
    VALUES (@idUsuario, 1, GETDATE());

    -- Enviar notificación
    DECLARE @mensaje nvarchar(200);
    SET @mensaje = N'El usuario ha sido registrado correctamente, puede ver su perfil';

    INSERT INTO Notification (UserId, Message, Date)
    VALUES (@idUsuario, @mensaje, GETDATE());

    -- Confirmar o revertir la transacción
    IF @@ERROR = 0
    BEGIN 
        COMMIT TRANSACTION;
        PRINT 'EL INGRESO HA SIDO EXITOSO';
    END
    ELSE 
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'HUBO ERRORES EN LA TRANSACCION, ABORTANDOLA';
    END
END;