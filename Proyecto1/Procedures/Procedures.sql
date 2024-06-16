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

/*6*/

CREATE PROCEDURE proyecto1.PR3
    @Email NVARCHAR(255),
    @CodCourse INT
AS 

BEGIN

    IF (@Email = '')
    BEGIN 
        PRINT 'El email no puede estar vacio';
        RETURN;
    END

    IF (@CodCourse < 0)
    BEGIN
        PRINT 'El codigo de curso debe ser mayor a cero';
        RETURN;
    END

    DECLARE @StudentId UNIQUEIDENTIFIER;
        
    SELECT @StudentId =  Id FROM BD2.proyecto1.Usuarios WHERE Email = @Email;

    IF (@StudentId IS NULL)
    BEGIN
        PRINT 'El email no esta registrado';
        RETURN;
    END

    IF (SELECT COUNT (*) FROM BD2.proyecto1.Course WHERE CodCourse = @CodCourse) = 0
    BEGIN
        PRINT 'El codigo del curso ingresado no corresponde a ningun curso';
        RETURN;
    END

    DECLARE @StudentName  NVARCHAR(MAX);
    SELECT @StudentName = FirstName + ' ' + LastName FROM BD2.proyecto1.Usuarios WHERE Id = @StudentId;
    DECLARE @CourseName  NVARCHAR(MAX);
    SELECT @CourseName = Name FROM BD2.proyecto1.Course WHERE CodCourse = @CodCourse;
    

    IF (SELECT COUNT(*) FROM BD2.proyecto1.CourseAssigment WHERE StudentId = @StudentId AND CourseCodCode = @CodCourse) >0
    BEGIN
        PRINT 'El estudiante' + @StudentName +' ya se encuentra asignado al curso ' + @CourseName;
        RETURN;
    END


    DECLARE @CodCredits INT;
    SELECT @CodCredits = CreditsRequired FROM BD2.proyecto1.Course WHERE CodCourse = @CodCourse;
   
    DECLARE @StudentCredits INT;
   	SELECT @StudentCredits = Credits FROM BD2.proyecto1.ProfileStudent WHERE UserId = @StudentId;

    IF (@StudentCredits < @CodCredits)
    BEGIN
        PRINT 'El estudiante no cuenta con los creditos necesarios para la asignación del curso';
        RETURN;
    END

    INSERT INTO BD2.proyecto1.CourseAssigment (StudentId, CourseCodCode) VALUES (@StudentId, @CodCourse);
    
    INSERT INTO BD2.proyecto1.Notification (UserId, Message, Date) 
    VALUES (@StudentId, 'El estudiante ' + @StudentName + ' se ha asignado al curso ' + @CourseName, GETDATE());
    

    IF @@ERROR = 0
    BEGIN
        PRINT 'Asignación exitosa';
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        PRINT 'Error al asignar el curso';
        ROLLBACK TRANSACTION;
    END


END    
    
    