-- 1

SELECT m.Moneda, COUNT(p.Id) AS cantidad
FROM Moneda m
LEFT JOIN Pais p ON m.Id = p.IdMoneda
GROUP BY m.Moneda
ORDER BY cantidad DESC, m.Moneda;

-- 2

SELECT moneda,max(Fecha) as "fecha del ultimo cambio"
From Moneda,CambioMoneda
WHERE moneda.Id = CambioMoneda.IdMoneda                                                   
GROUP BY Moneda

-- 3

SELECT moneda,Fecha,Cambio 
FROM moneda
JOIN cambiomoneda ON moneda.Id=IdMoneda
WHERE Fecha = (SELECT MAX(Fecha) from CambioMoneda WHERE moneda.Id = IdMoneda)

-- 4

SELECT 
    m.Id,
    m.Moneda,
    AVG(cm.Cambio) AS "Promedio Rango 30Dias",
    MAX(cm.Fecha) AS "Fecha Ultimo Cambio"
FROM Moneda m
INNER JOIN CambioMoneda cm ON m.Id = cm.IdMoneda
WHERE cm.Fecha >= (
        SELECT DATEADD(day, -30, MAX(sub.Fecha))
        FROM CambioMoneda sub
        WHERE sub.IdMoneda = m.Id
    )
GROUP BY m.Id, m.Moneda
ORDER BY m.Moneda;

-- 5

USE Monedas
GO

WITH Base AS (
    SELECT 
        m.Id, m.Moneda, m.Sigla,
        COUNT(p.Id) AS CantidadPais,
        (SELECT MAX(Fecha) FROM CambioMoneda WHERE IdMoneda = m.Id) AS FechaUltimoCambio,
        (SELECT TOP 1 sub_c.Cambio FROM CambioMoneda sub_c 
         WHERE sub_c.IdMoneda = m.Id ORDER BY sub_c.Fecha DESC) AS UltimoCambio,
        (SELECT AVG(sub.Cambio) FROM CambioMoneda sub 
         WHERE sub.IdMoneda = m.Id
           AND sub.Fecha >= DATEADD(day, -30, (SELECT MAX(Fecha) FROM CambioMoneda WHERE IdMoneda = m.Id))
        ) AS PromedioUltimos30Dias,
        (SELECT STDEV(sub.Cambio) FROM CambioMoneda sub 
         WHERE sub.IdMoneda = m.Id
           AND sub.Fecha >= DATEADD(day, -30, (SELECT MAX(Fecha) FROM CambioMoneda WHERE IdMoneda = m.Id))
        ) AS DesviacionEstandar
    FROM Moneda AS m
    LEFT JOIN Pais AS p ON m.Id = p.IdMoneda
    GROUP BY m.Id, m.Moneda, m.Sigla
)
SELECT Id, Moneda, Sigla, CantidadPais, FechaUltimoCambio, UltimoCambio,
       PromedioUltimos30Dias, DesviacionEstandar,
       CASE 
           WHEN DesviacionEstandar IS NULL THEN 'Sin datos'
           WHEN DesviacionEstandar < 0.05  THEN 'Baja'
           WHEN DesviacionEstandar < 0.15  THEN 'Media'
           ELSE 'Alta'
       END AS Volatilidad,
       RANK() OVER (ORDER BY CantidadPais DESC) AS RANKING
FROM Base
ORDER BY CantidadPais DESC, Moneda;
GO