/* 2 */
CREATE PROCEDURE proyecto1.PR4
    @RolName NVARCHAR(30)
AS
BEGIN
    
    BEGIN TRANSACTION;

    IF (SELECT COUNT(*) FROM BD2.proyecto1.Roles WHERE RoleName = @RolName) > 0
    BEGIN
        PRINT 'Ya existe el Rol';
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    IF (@RolName = '')
    BEGIN
        PRINT 'El nombre del Rol no puede estar vacio';
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DECLARE @NewID UNIQUEIDENTIFIER;
    SET @NewID = NEWID();
    
    INSERT INTO BD2.proyecto1.Roles (id, RoleName) 
    VALUES (@NewID, @RolName);

    COMMIT TRANSACTION;
    
END