ALTER TRIGGER  proyecto1.Trigger9  
ON proyecto1.Notification
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Operacion VARCHAR(20);
    DECLARE @Descripcion VARCHAR(100);

    -- Determinar el tipo de operación
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';
    ELSE
        RETURN; -- No debería llegar aquí, pero por seguridad

    -- Lógica para manejar las operaciones en las tablas
    SET @Descripcion = 'Operación ' + @Operacion + ' exitosa en la tabla Notification';

    -- Insertar el registro en la tabla HistoryLog
    INSERT INTO proyecto1.HistoryLog ([Date], Description)
    VALUES (GETDATE(), @Descripcion);
END;
