USE Traduccion
GO

CREATE OR ALTER FUNCTION fTraducir(@Frase nvarchar(max), @Idioma varchar(50))
RETURNS TABLE
AS
RETURN
(
    WITH Partes AS (
        SELECT 1 AS Orden,
               CAST(CASE WHEN CHARINDEX(',', @Frase) > 0
                         THEN LEFT(@Frase, CHARINDEX(',', @Frase) - 1)
                         ELSE @Frase END AS nvarchar(max)) AS Fragmento,
               CAST(CASE WHEN CHARINDEX(',', @Frase) > 0
                         THEN SUBSTRING(@Frase, CHARINDEX(',', @Frase) + 1, LEN(@Frase))
                         ELSE NULL END AS nvarchar(max)) AS Resto
        UNION ALL
        SELECT Orden + 1,
               CAST(CASE WHEN CHARINDEX(',', Resto) > 0
                         THEN LEFT(Resto, CHARINDEX(',', Resto) - 1)
                         ELSE Resto END AS nvarchar(max)),
               CAST(CASE WHEN CHARINDEX(',', Resto) > 0
                         THEN SUBSTRING(Resto, CHARINDEX(',', Resto) + 1, LEN(Resto))
                         ELSE NULL END AS nvarchar(max))
        FROM Partes
        WHERE Resto IS NOT NULL
    )
    SELECT TOP (1000) T.Texto AS [Frases Traducidas]
    FROM Partes P
        JOIN Frase F      ON F.Texto = LTRIM(RTRIM(P.Fragmento))
        JOIN Idioma I     ON I.Idioma = @Idioma
        JOIN Traduccion T ON T.IdFrase = F.Id AND T.IdIdioma = I.Id
    ORDER BY P.Orden
)
GO

SELECT * FROM fTraducir('Hola, Buenas Tardes, Cómo te llamas?', 'Inglés')