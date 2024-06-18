CREATE PROCEDURE proyecto1.PR5
    @codigo int,
    @nombre nvarchar(100),
    @creditos int
AS
BEGIN
    BEGIN TRANSACTION;

    IF EXISTS (
        SELECT 1
        FROM Course
        WHERE
            CodCourse = @codigo
    )
    BEGIN
    ROLLBACK TRANSACTION;

    PRINT 'Ya existe el codigo del curso';

    RETURN;

    END
    IF EXISTS (SELECT 1 FROM Course WHERE Name = @nombre)
    BEGIN 
        ROLLBACK TRANSACTION;
        PRINT 'Ya existe el nombre del curso';
        RETURN; 
    END

    IF (@creditos < 0) 
    BEGIN 
        ROLLBACK TRANSACTION;
        PRINT 'El curso no puede tener créditos negativos';
        RETURN; 
    END


    -- crea el curso
    INSERT INTO Course (CodCourse, Name, CreditsRequired) VALUES (@codigo, @nombre, @creditos);

    IF @@ERROR = 0
    BEGIN
        COMMIT TRANSACTION;
        PRINT 'Curso ingresado exitosamente';
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Error al ingresar el curso';
    END
END;