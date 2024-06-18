CREATE FUNCTION proyecto1.F5
(
    @UserId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        u.FirstName,
        u.LastName,
        u.Email,
        u.DateOfBirth,
        ps.Credits,
        r.RoleName
    FROM
        proyecto1.Usuarios u
    JOIN
        proyecto1.UsuarioRole ur ON u.Id = ur.UserId
    JOIN
        proyecto1.Roles r ON ur.RoleId = r.Id
    LEFT JOIN
        proyecto1.ProfileStudent ps ON u.Id = ps.UserId
    WHERE
        u.Id = @UserId
);



SELECT * FROM proyecto1.F5('7E09E5FD-1701-451A-A714-001A32D5844F');