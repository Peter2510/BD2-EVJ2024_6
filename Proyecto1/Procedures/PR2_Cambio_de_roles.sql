CREATE OR ALTER PROCEDURE proyecto1.PR2
    @Email NVARCHAR(MAX),
    @CodCourse INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Variables
    DECLARE @UserId UNIQUEIDENTIFIER;
    DECLARE @RoleId UNIQUEIDENTIFIER;
    DECLARE @TutorProfileId UNIQUEIDENTIFIER;
    DECLARE @Message NVARCHAR(MAX);
    DECLARE @FirstName NVARCHAR(50);
    DECLARE @LastName NVARCHAR(50);
    DECLARE @TutorCode NVARCHAR(50);
    DECLARE @HistoryMessage NVARCHAR(MAX);

    -- Verificar si el usuario existe y está activo
    SELECT @UserId = Id, @FirstName = FirstName, @LastName = LastName
    FROM proyecto1.Usuarios
    WHERE Email = @Email AND EmailConfirmed = 1;

    -- Si el usuario no existe o no está activo, registrar en HistoryLog y salir
    IF @UserId IS NULL
    BEGIN
        SET @HistoryMessage = 'El usuario con email ' + @Email + ' no existe o no está activo.';
        PRINT @HistoryMessage;

        -- Registrar en HistoryLog
        INSERT INTO proyecto1.HistoryLog (Date, Description)
        VALUES (GETDATE(), @HistoryMessage);

        RETURN;
    END;

    -- Obtener el RoleId para el rol de "Tutor"
    SELECT @RoleId = Id
    FROM proyecto1.Roles
    WHERE RoleName = 'Tutor';

    -- Si no se encontró el RoleId para "Tutor", registrar en HistoryLog y salir
    IF @RoleId IS NULL
    BEGIN
        SET @HistoryMessage = 'El rol de "Tutor" no está definido en la tabla de Roles.';
        PRINT @HistoryMessage;

        -- Registrar en HistoryLog
        INSERT INTO proyecto1.HistoryLog (Date, Description)
        VALUES (GETDATE(), @HistoryMessage);

        RETURN;
    END;

    -- Verificar si el curso especificado existe
    IF NOT EXISTS (
        SELECT 1
        FROM proyecto1.Course
        WHERE CodCourse = @CodCourse
    )
    BEGIN
        SET @HistoryMessage = 'El curso especificado con código ' + CAST(@CodCourse AS NVARCHAR) + ' no existe.';
        PRINT @HistoryMessage;

        -- Registrar en HistoryLog
        INSERT INTO proyecto1.HistoryLog (Date, Description)
        VALUES (GETDATE(), @HistoryMessage);

        RETURN;
    END;

    -- Verificar si el usuario ya tiene el rol de Tutor
    IF EXISTS (
        SELECT 1
        FROM proyecto1.UsuarioRole ur
        WHERE ur.UserId = @UserId AND ur.RoleId = @RoleId
    )
    BEGIN
        -- Verificar si el usuario ya es tutor para el curso especificado
        IF EXISTS (
            SELECT 1
            FROM proyecto1.CourseTutor ct
            WHERE ct.TutorId = @UserId AND ct.CourseCodCourse = @CodCourse
        )
        BEGIN
            SET @HistoryMessage = 'El usuario con email ' + @Email + ' ya es tutor para el curso especificado con código ' + CAST(@CodCourse AS NVARCHAR) + '.';
            PRINT @HistoryMessage;

            -- Registrar en HistoryLog
            INSERT INTO proyecto1.HistoryLog (Date, Description)
            VALUES (GETDATE(), @HistoryMessage);

            RETURN;
        END
        ELSE
        BEGIN
            -- Asignar al usuario como tutor del curso especificado
            INSERT INTO proyecto1.CourseTutor (TutorId, CourseCodCourse)
            VALUES (@UserId, @CodCourse);

            -- Registrar en el historial
            SET @HistoryMessage = 'Asignación exitosa como tutor para el curso con código ' + CAST(@CodCourse AS NVARCHAR) + ' para el usuario con email ' + @Email + '.';
            PRINT @HistoryMessage;

            -- Registrar en HistoryLog
            INSERT INTO proyecto1.HistoryLog (Date, Description)
            VALUES (GETDATE(), @HistoryMessage);

            -- Enviar correo de notificación
            SET @Message = 'Se le ha asignado el rol de Tutor para el curso con código ' + CAST(@CodCourse AS NVARCHAR) + '.';
            INSERT INTO proyecto1.Notification (UserId, Message, Date)
            VALUES (@UserId, @Message, GETDATE());

            -- Registrar la notificación enviada en el historial
            SET @HistoryMessage = 'Notificación enviada: ' + @Message;
            INSERT INTO proyecto1.HistoryLog (Date, Description)
            VALUES (GETDATE(), @HistoryMessage);

            -- Imprimir mensaje de notificación enviada
            PRINT 'Notificación enviada al usuario con email ' + @Email;

            RETURN;
        END
    END
    ELSE
    BEGIN
        -- Insertar en UsuarioRole el rol de Tutor
        INSERT INTO proyecto1.UsuarioRole (RoleId, UserId, IsLatestVersion)
        VALUES (@RoleId, @UserId, 1);

        -- Crear el código de tutor
        SET @TutorCode = 'tut' + LEFT(@FirstName, 3) + LEFT(@LastName, 3);

        -- Crear registro en TutorProfile
        INSERT INTO proyecto1.TutorProfile (UserId, TutorCode)
        VALUES (@UserId, @TutorCode);

        -- Asignar al usuario como tutor del curso especificado
        INSERT INTO proyecto1.CourseTutor (TutorId, CourseCodCourse)
        VALUES (@UserId, @CodCourse);

        -- Registrar en el historial
        SET @HistoryMessage = 'Cambio de rol a Tutor exitoso para el usuario con email ' + @Email + ' para el curso con código ' + CAST(@CodCourse AS NVARCHAR) + '.';
        PRINT @HistoryMessage;

        -- Registrar en HistoryLog
        INSERT INTO proyecto1.HistoryLog (Date, Description)
        VALUES (GETDATE(), @HistoryMessage);

        -- Enviar correo de notificación
        SET @Message = 'Se le ha asignado el rol de Tutor para el curso con código ' + CAST(@CodCourse AS NVARCHAR) + '.';
        INSERT INTO proyecto1.Notification (UserId, Message, Date)
        VALUES (@UserId, @Message, GETDATE());

        -- Registrar la notificación enviada en el historial
        SET @HistoryMessage = 'Notificación enviada: ' + @Message;
        INSERT INTO proyecto1.HistoryLog (Date, Description)
        VALUES (GETDATE(), @HistoryMessage);

        -- Imprimir mensaje de notificación enviada
        PRINT 'Notificación enviada al usuario con email ' + @Email;

        RETURN;
    END;
END;

