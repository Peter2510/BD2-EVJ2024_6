CREATE FUNCTION proyecto1.F1 (@CodCourse INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        Course.CodCourse,
        Course.Name AS CourseName,
        Student.FirstName + ' ' + Student.LastName AS StudentName
    FROM 
        BD2.proyecto1.CourseAssignment AS Assignment
        INNER JOIN BD2.proyecto1.Usuarios AS Student ON Assignment.StudentId = Student.Id
        INNER JOIN BD2.proyecto1.Course AS Course ON Assignment.CourseCodCourse = Course.CodCourse 
    WHERE 
        Course.CodCourse = @CodCourse
);





