CREATE FUNCTION proyecto1.F4()
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        Id,
        Date,
        Description
    FROM 
        BD2.proyecto1.HistoryLog 
);

