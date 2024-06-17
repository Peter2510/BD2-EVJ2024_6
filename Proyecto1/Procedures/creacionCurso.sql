CREATE PROCEDURE proyecto1.PR5
    @nombre nvarchar(100),
    @creditos int
AS
BEGIN
    BEGIN TRANSACTION;

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
    DECLARE @codigo int 
    select @codigo =  count(*) from Course;
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




