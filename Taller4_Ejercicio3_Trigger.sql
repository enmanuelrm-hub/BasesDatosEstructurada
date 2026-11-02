USE CampeonatosFIFA
GO

/* Ejercicio 3: en un mismo campeonato y fase, un encuentro entre dos paises
   no puede repetirse (ni en el mismo orden ni invertido).
   Ej: Brasil vs Alemania y Alemania vs Brasil se consideran el mismo partido. */

CREATE TRIGGER tValidarEncuentroRepetido
ON Encuentro
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Al ser un trigger AFTER, la tabla Encuentro ya contiene las filas nuevas,
    -- por eso comparamos cada fila de Inserted contra OTRAS filas (E.Id <> I.Id).
    -- Esto tambien detecta duplicados dentro de un mismo INSERT masivo.
    IF EXISTS(
        SELECT 1
        FROM Inserted I
            JOIN Encuentro E
                ON  E.IdCampeonato = I.IdCampeonato
                AND E.IdFase       = I.IdFase
                AND E.Id          <> I.Id
                AND (   (E.IdPais1 = I.IdPais1 AND E.IdPais2 = I.IdPais2)   -- mismo orden
                     OR (E.IdPais1 = I.IdPais2 AND E.IdPais2 = I.IdPais1))  -- orden invertido
    )
    BEGIN
        RAISERROR('Un encuentro entre dos paises no puede repetirse en la misma fase de un campeonato.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO

/* ---------- Pruebas ----------
-- Debe fallar (ya existe Rusia vs Arabia Saudita en Grupos, Mundial 2018, mismo orden):
INSERT INTO Encuentro (IdPais1, IdPais2, IdFase, IdCampeonato, IdEstadio, Fecha)
    SELECT P1.Id, P2.Id, 1, C.Id, E.Id, '2018-06-30'
    FROM Pais P1, Pais P2, Campeonato C, Estadio E
    WHERE P1.Pais='Rusia' AND P2.Pais='Arabia Saudita'
      AND C.Campeonato='FIFA World Cup 2018' AND E.Estadio='Luzhniki Stadium'

-- Debe fallar tambien (invertido: Arabia Saudita vs Rusia):
INSERT INTO Encuentro (IdPais1, IdPais2, IdFase, IdCampeonato, IdEstadio, Fecha)
    SELECT P2.Id, P1.Id, 1, C.Id, E.Id, '2018-06-30'
    FROM Pais P1, Pais P2, Campeonato C, Estadio E
    WHERE P1.Pais='Rusia' AND P2.Pais='Arabia Saudita'
      AND C.Campeonato='FIFA World Cup 2018' AND E.Estadio='Luzhniki Stadium'
*/
