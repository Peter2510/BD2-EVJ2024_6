CREATE OR ALTER FUNCTION proyecto1.F2 ( @idtutor UNIQUEIDENTIFIER) 
RETURNS TABLE
AS 
RETURN
(
SELECT
	CourseCodCourse AS codigo,
	c.Name AS nombre,
	C.CreditsRequired AS creditos_requeridos
FROM
	proyecto1.CourseTutor ct
JOIN proyecto1.Course c ON
	c.CodCourse = ct.CourseCodCourse
WHERE
	ct.TutorId = @idtutor
);