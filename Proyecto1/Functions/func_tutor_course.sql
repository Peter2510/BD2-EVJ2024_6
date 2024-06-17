-- FUNCION PARA EL TUTOR

CREATE FUNCTION proyecto1.F2 ( @idtutor int) 
RETURNS TABLE
AS 
RETURN
(
        SELECT
            CourseCodCourse as codigo,
            c.Name as nombre,
            C.CreditsRequired as creditos_requeridos
        FROM proyecto1.CourseTutor ct
        join proyecto1.Course c on c.CodCourse = ct.CourseCodCourse
        WHERE
            ct.TutorId = '43B83BB4-7330-45D1-B90C-C1DBAF8D08AA'
        order by c.CodCourse asc;

);