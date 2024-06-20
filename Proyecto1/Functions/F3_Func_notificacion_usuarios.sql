CREATE FUNCTION proyecto1.F3 ( @idusuario UNIQUEIDENTIFIER) 
RETURNS TABLE
AS 
RETURN
(
    SELECT n.Message AS Mensaje, 
    n.Date AS Fecha, 
    CONCAT(u.Firstname, ' ', u.Lastname) AS Nombre
    FROM proyecto1.Notification n
        join proyecto1.Usuarios u ON u.Id = n.UserId
    WHERE
        n.UserId = @idusuario

);