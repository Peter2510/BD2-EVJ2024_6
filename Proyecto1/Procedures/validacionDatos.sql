CREATE OR ALTER PROCEDURE proyecto1.PR6
    @EntityName NVARCHAR(50),
    @FirstName NVARCHAR(MAX) = NULL,
    @LastName NVARCHAR(MAX) = NULL,
    @Name NVARCHAR(MAX) = NULL,
    @CreditsRequired INT = NULL,
    @IsValid BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de Usuario
    IF @EntityName = 'Usuarios'
    BEGIN
        IF ISNULL(@FirstName, '') NOT LIKE '%[^a-zA-Z ]%' AND ISNULL(@LastName, '') NOT LIKE '%[^a-zA-Z ]%'
            SET @IsValid = 1;
        ELSE
            SET @IsValid = 0;
    END
    -- Validación de Curso
    ELSE IF @EntityName = 'Course'
    BEGIN
        -- Validar que el nombre solo contenga letras, espacios y opcionalmente termine en un número
        IF ISNULL(@Name, '') NOT LIKE '%[^a-zA-Z0-9 ]%' -- Solo permite letras, números y espacios
           AND @Name NOT LIKE '[0-9]%' -- No debe comenzar con un número
           AND @Name LIKE '%[a-zA-Z]%[a-zA-Z ]%' -- Debe contener al menos dos palabras
           AND (
               @Name NOT LIKE '%[0-9]%[a-zA-Z]%' -- No debe tener números mezclados con letras dentro de las palabras
               OR @Name LIKE '% [0-9]' -- Puede terminar con un número precedido de un espacio
           )
        BEGIN
            SET @IsValid = 1;
        END
        ELSE
        BEGIN
            SET @IsValid = 0;
        END
    END
    ELSE
    BEGIN
        -- No valida
        SET @IsValid = 0;
    END;
END;


