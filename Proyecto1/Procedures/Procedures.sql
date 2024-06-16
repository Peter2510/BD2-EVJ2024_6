/* 2 */
CREATE PROCEDURE PR4 
    @RolName NVARCHAR(30)
AS
BEGIN
    
    BEGIN TRANSACTION;

    BEGIN TRY
    
        DECLARE @NewID UNIQUEIDENTIFIER;
    
        SET @NewID = NEWID();
    
        INSERT INTO BD2.proyecto1.Roles (id, RoleName) 
        VALUES (@NewID, @RolName);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END

