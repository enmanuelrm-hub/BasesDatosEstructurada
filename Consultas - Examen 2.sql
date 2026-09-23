-- ¿Cuántas canciones ha compuesto “JUANES”? 

SELECT COUNT(*) AS TotalCanciones
FROM Compositor c
JOIN CancionCompositor cc ON c.Id = cc.IdCompositor
WHERE CHARINDEX('JUANES', c.Nombre) > 0;

-- ¿Qué interpretaciones se tienen de la canción “Lluvia” y en qué ritmos?

SELECT c.Titulo AS Cancion, i.Nombre AS Interprete, intp.Duracion, r.Ritmo
FROM Cancion c
JOIN Interpretacion intp ON c.Id = intp.IdCancion
JOIN Interprete i ON intp.IdInterprete = i.Id
JOIN Ritmo r ON intp.IdRitmo = r.Id
WHERE c.Titulo = 'Lluvia';

-- ¿Qué canciones hay con el mismo Intérprete y Compositor del ritmo “Balada”?

SELECT c.Titulo AS Cancion, i.Nombre AS Interprete, comp.Nombre AS Compositor, r.Ritmo
FROM Cancion c
JOIN Interpretacion intp ON c.Id = intp.IdCancion
JOIN Interprete i ON intp.IdInterprete = i.Id
JOIN Tipo t ON i.IdTipo = t.Id
JOIN Ritmo r ON intp.IdRitmo = r.Id
JOIN CancionCompositor cc ON c.Id = cc.IdCancion
JOIN Compositor comp ON cc.IdCompositor = comp.Id
WHERE r.Ritmo = 'Balada' 
  AND t.Tipo = 'Solista'
  AND CHARINDEX(i.Nombre, comp.Nombre) > 0;

-- ¿Listar los países que tienen grupos del ritmo “Salsa”?

SELECT DISTINCT p.Nombre AS Pais
FROM Pais p
JOIN Interprete i ON p.Id = i.IdPais
JOIN Tipo t ON i.IdTipo = t.Id
JOIN Interpretacion intp ON i.Id = intp.IdInterprete
JOIN Ritmo r ON intp.IdRitmo = r.Id
WHERE t.Tipo = 'Grupo' 
  AND r.Ritmo = 'Salsa';

-- ¿Quiénes interpretan las canciones “Candilejas” y “Malaguena”?

SELECT DISTINCT i.Nombre AS Interprete, c.Titulo AS Cancion
FROM Interprete i
JOIN Interpretacion intp ON i.Id = intp.IdInterprete
JOIN Cancion c ON intp.IdCancion = c.Id
WHERE c.Titulo IN ('Candilejas', 'Malaguena');

-- Listar artistas que son intérpretes y compositores a la vez y con cuantas canciones compuestas e interpretadas

SELECT i.Nombre AS Artista, COUNT(DISTINCT c.Id) AS CancionesCompuestasEInterpretadas
FROM Interprete i
JOIN Compositor comp ON CHARINDEX(i.Nombre, comp.Nombre) > 0
JOIN Interpretacion intp ON i.Id = intp.IdInterprete
JOIN Cancion c ON intp.IdCancion = c.Id
JOIN CancionCompositor cc ON c.Id = cc.IdCancion AND cc.IdCompositor = comp.Id
GROUP BY i.Nombre;