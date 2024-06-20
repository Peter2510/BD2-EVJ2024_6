CREATE OR ALTER PROCEDURE proyecto1.PR4
    @RolName NVARCHAR(30)
AS
BEGIN
    
    BEGIN TRANSACTION;

    IF (SELECT COUNT(*) FROM BD2.proyecto1.Roles WHERE RoleName = @RolName) > 0
    BEGIN
        PRINT 'Ya existe el Rol';
        INSERT INTO BD2.proyecto1.HistoryLog(Description, Date) VALUES ('Operación INSERT errónea en la tabla Roles, ya existe un Rol con el nombre ' + @RolName, GETDATE());
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    IF (@RolName = '')
    BEGIN
        PRINT 'El nombre del Rol no puede estar vacio';
        INSERT INTO BD2.proyecto1.HistoryLog(Description, Date) VALUES ('Operación INSERT errónea en la tabla Roles, el nombre del Rol no puede estar vacio', GETDATE());
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DECLARE @NewID UNIQUEIDENTIFIER;
    DECLARE @Description NVARCHAR(MAX);
    SET @NewID = NEWID();
    
    INSERT INTO BD2.proyecto1.Roles (id, RoleName) 
    VALUES (@NewID, @RolName);
    SET @Description = 'Operación INSERT exitosa, se ha insertado un nuevo Rol en la tabla Roles, con el nombre ' + @RolName;
    INSERT INTO BD2.proyecto1.HistoryLog(Description, Date) VALUES (@Description, GETDATE());

    COMMIT TRANSACTION;
    
END