CREATE PROCEDURE proyecto1.PR5
    @codigo int,
    @nombre nvarchar(100),
    @creditos int
AS
BEGIN

    BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @Description nvarchar(max);
    DECLARE @ErrorSeverity INT;
    DECLARE @valido BIT;
    EXEC proyecto1.PR6 'Course',NULL,NULL, @Name, @CreditsRequired, @valido OUTPUT ;

    IF @valido =0
        BEGIN
            SET @Description = 'Inserción fallida: error de nombre de curso o creditos ';
            SELECT @Description AS 'Error';
            SET @ErrorSeverity = 18; 
            RAISERROR(@Description, @ErrorSeverity, 1);
            RETURN;
        END

    -- Validaciones previas a la inserción
    IF EXISTS (SELECT 1 FROM proyecto1.Course WHERE CodCourse = @codigo)
    BEGIN
        SET @Description = 'Inserción fallida: código de curso ya existente';
        SELECT @Description AS 'Error';
        SET @ErrorSeverity = 18; 
        RAISERROR(@Description, @ErrorSeverity, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM proyecto1.Course WHERE Name = @nombre)
    BEGIN
        SET @Description = 'Inserción fallida: nombre de curso ya existente';
        SELECT @Description AS 'Error';
        SET @ErrorSeverity = 18; 
        RAISERROR(@Description, @ErrorSeverity, 1);
        RETURN;
    END

    IF (@creditos < 0) 
    BEGIN
        SET @Description = 'Inserción fallida: los créditos no pueden ser negativos';
        SELECT @Description AS 'Error';
        SET @ErrorSeverity = 18; 
        RAISERROR(@Description, @ErrorSeverity, 1);
        RETURN;
    END

    IF (@codigo < 0) 
    BEGIN
        SET @Description = 'Inserción fallida: el código de curso no puede ser negativo';
        SELECT @Description AS 'Error';
        SET @ErrorSeverity = 18; 
        RAISERROR(@Description, @ErrorSeverity, 1);
        RETURN;
    END


        INSERT INTO Course (CodCourse, Name, CreditsRequired)
        VALUES (@codigo, @nombre, @creditos);

        COMMIT TRANSACTION;
        PRINT 'Curso ingresado exitosamente';
    END TRY
    BEGIN CATCH
    	ROLLBACK TRANSACTION;
        SET @Description = ERROR_MESSAGE();
        INSERT INTO HistoryLog (Date, Description)
        VALUES (GETDATE(), @Description);
		PRINT 'ERROR';
		
	RAISERROR(@Description, 18, 1);
    END CATCH;
END;
