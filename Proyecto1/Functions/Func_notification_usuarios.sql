-- FUNCION PARA EL TUTOR

CREATE FUNCTION proyecto1.F3 ( @idusuario UNIQUEIDENTIFIER) 
RETURNS TABLE
AS 
RETURN
(
    SELECT n.Message as Mensaje, 
    n.Date as Fecha, 
    CONCAT(u.Firstname, ' ', u.Lastname) as Nombre
    FROM proyecto1.Notification n
        join proyecto1.Usuarios u on u.Id = n.UserId
    WHERE
        n.UserId = @idusuario

);