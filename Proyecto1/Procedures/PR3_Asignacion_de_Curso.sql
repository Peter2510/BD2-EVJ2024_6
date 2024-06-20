CREATE OR ALTER PROCEDURE proyecto1.PR3
    @Email NVARCHAR(255),
    @CodCourse INT
AS 
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        IF (@Email = '')
        BEGIN 
            INSERT INTO BD2.proyecto1.HistoryLog(Description, Date) 
            VALUES ('Operación INSERT errónea en la tabla CourseAssignment, el email no puede estar vacío', GETDATE());
            THROW 50000, 'El email no puede estar vacío', 1;
        END

        IF (@CodCourse < 0)
        BEGIN
            INSERT INTO BD2.proyecto1.HistoryLog(Description, Date) 
            VALUES ('Operación INSERT errónea en la tabla CourseAssignment, el código de curso debe ser mayor a cero', GETDATE());
            THROW 50001, 'El código de curso debe ser mayor a cero', 1;
        END

        DECLARE @StudentId UNIQUEIDENTIFIER;
        SELECT @StudentId = Id FROM BD2.proyecto1.Usuarios WHERE Email = @Email;

        IF (@StudentId IS NULL)
        BEGIN
            INSERT INTO BD2.proyecto1.HistoryLog(Description, Date) 
            VALUES ('Operación INSERT errónea en la tabla CourseAssignment, el email no está registrado', GETDATE());
            THROW 50002, 'El email no está registrado', 1;
        END

        IF (SELECT COUNT(*) FROM BD2.proyecto1.Course WHERE CodCourse = @CodCourse) = 0
        BEGIN
            INSERT INTO BD2.proyecto1.HistoryLog(Description, Date) 
            VALUES ('Operación INSERT errónea en la tabla CourseAssignment, el código del curso ingresado no corresponde a ningún curso', GETDATE());
            THROW 50003, 'El código del curso ingresado no corresponde a ningún curso', 1;
        END

        DECLARE @StudentName NVARCHAR(MAX);
        SELECT @StudentName = FirstName + ' ' + LastName FROM BD2.proyecto1.Usuarios WHERE Id = @StudentId;
        DECLARE @CourseName NVARCHAR(MAX);
        SELECT @CourseName = Name FROM BD2.proyecto1.Course WHERE CodCourse = @CodCourse;

        IF (SELECT COUNT(*) FROM BD2.proyecto1.CourseAssignment WHERE StudentId = @StudentId AND CourseCodCourse = @CodCourse) > 0
        BEGIN
            INSERT INTO BD2.proyecto1.HistoryLog(Description, Date) 
            VALUES ('Operación INSERT errónea en la tabla CourseAssignment, el estudiante ' + @StudentName + ' ya se encuentra asignado al curso ' + @CourseName, GETDATE());
            THROW 50004, 'El estudiante ya se encuentra asignado al curso', 1;
        END    

        DECLARE @CodCredits INT;
        SELECT @CodCredits = CreditsRequired FROM BD2.proyecto1.Course WHERE CodCourse = @CodCourse;

        DECLARE @StudentCredits INT;
        SELECT @StudentCredits = Credits FROM BD2.proyecto1.ProfileStudent WHERE UserId = @StudentId;

        IF (@StudentCredits < @CodCredits)
        BEGIN
            INSERT INTO BD2.proyecto1.HistoryLog(Description, Date) 
            VALUES ('Operación INSERT errónea en la tabla CourseAssignment, el estudiante ' + @StudentName + ' no cuenta con los créditos necesarios para la asignación del curso ' + @CourseName, GETDATE());
            THROW 50005, 'El estudiante no cuenta con los créditos necesarios para la asignación del curso', 1;
        END

        INSERT INTO BD2.proyecto1.CourseAssignment (StudentId, CourseCodCourse) VALUES (@StudentId, @CodCourse);

        INSERT INTO BD2.proyecto1.Notification (UserId, Message, Date) 
        VALUES (@StudentId, 'El estudiante ' + @StudentName + ' se ha asignado al curso ' + @CourseName, GETDATE());
        INSERT INTO BD2.proyecto1.HistoryLog(Description, Date) 
        VALUES ('Operación INSERT exitosa en la tabla CourseAssignment, el estudiante ' + @StudentName + ' se ha asignado al curso ' + @CourseName, GETDATE());

        COMMIT TRANSACTION;

        PRINT 'Asignación exitosa';

    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH

END