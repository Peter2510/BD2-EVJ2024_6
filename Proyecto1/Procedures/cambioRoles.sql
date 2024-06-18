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

    BEGIN TRANSACTION;

    -- Verificar si el usuario existe y está activo
    SELECT @UserId = Id
    FROM proyecto1.Usuarios
    WHERE Email = @Email AND EmailConfirmed = 1;

    -- Si el usuario no existe o no está activo, imprimir mensaje y salir
    IF @UserId IS NULL
    BEGIN
        PRINT 'El usuario no existe o no está activo.';
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Obtener el RoleId para el rol de "Tutor"
    SELECT @RoleId = Id
    FROM proyecto1.Roles
    WHERE RoleName = 'Tutor';

    -- Si no se encontró el RoleId para "Tutor", imprimir mensaje y salir
    IF @RoleId IS NULL
    BEGIN
        PRINT 'El rol de "Tutor" no está definido en la tabla de Roles.';
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Verificar si el curso especificado existe
    IF NOT EXISTS (
        SELECT 1
        FROM proyecto1.Course
        WHERE CodCourse = @CodCourse
    )
    BEGIN
        PRINT 'El curso especificado no existe.';
        ROLLBACK TRANSACTION;
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
            INNER JOIN proyecto1.TutorProfile tp ON ct.TutorId = tp.UserId
            WHERE tp.UserId = @UserId AND ct.CourseCodCourse = @CodCourse
        )
        BEGIN
            PRINT 'El usuario ya es tutor para el curso especificado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        ELSE
        BEGIN
            -- Asignar al usuario como tutor del curso especificado
            INSERT INTO proyecto1.CourseTutor (TutorId, CourseCodCourse)
            VALUES (@UserId, @CodCourse);

            -- Registrar en el historial
            INSERT INTO proyecto1.HistoryLog (Date, Description)
            VALUES (GETDATE(), 'Asignación exitosa como tutor para el curso con email ' + @Email);

            -- Confirmar la transacción
            COMMIT TRANSACTION;

            -- Imprimir mensaje de éxito
            PRINT 'Asignación como tutor exitosa para el curso con email ' + @Email;

            -- Enviar correo de notificación
            SET @Message = 'Se le ha asignado el rol de Tutor para el curso especificado.';
            INSERT INTO proyecto1.Notification (UserId, Message, Date)
            VALUES (@UserId, @Message, GETDATE());

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

        -- Asignar al usuario como tutor del curso especificado
        INSERT INTO proyecto1.CourseTutor (TutorId, CourseCodCourse)
        VALUES ( @UserId, @CodCourse);

        -- Registrar en el historial
        INSERT INTO proyecto1.HistoryLog (Date, Description)
        VALUES (GETDATE(), 'Cambio de rol exitoso para usuario con email ' + @Email);

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Imprimir mensaje de éxito
        PRINT 'Cambio de rol a Tutor exitoso para el usuario con email ' + @Email;

        -- Enviar correo de notificación
        SET @Message = 'Se le ha asignado el rol de Tutor para el curso especificado.';
        INSERT INTO proyecto1.Notification (UserId, Message, Date)
        VALUES (@UserId, @Message, GETDATE());

        -- Imprimir mensaje de notificación enviada
        PRINT 'Notificación enviada al usuario con email ' + @Email;
    END;
END;




