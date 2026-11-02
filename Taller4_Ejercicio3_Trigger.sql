USE CampeonatosFIFA
GO


CREATE TRIGGER tValidarEncuentroRepetido
ON Encuentro
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS(
        SELECT 1
        FROM Inserted I
            JOIN Encuentro E
                ON  E.IdCampeonato = I.IdCampeonato
                AND E.IdFase       = I.IdFase
                AND E.Id          <> I.Id
                AND (   (E.IdPais1 = I.IdPais1 AND E.IdPais2 = I.IdPais2)
                     OR (E.IdPais1 = I.IdPais2 AND E.IdPais2 = I.IdPais1))
    )
    BEGIN
        RAISERROR('Un encuentro entre dos paises no puede repetirse en la misma fase de un campeonato.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO


-- PRUEBAS

INSERT INTO Encuentro (IdPais1, IdPais2, IdFase, IdCampeonato, IdEstadio, Fecha)
    SELECT P1.Id, P2.Id, 1, C.Id, E.Id, '20180630'
    FROM Pais P1, Pais P2, Campeonato C, Estadio E
    WHERE P1.Pais='Rusia' AND P2.Pais='Arabia Saudita'
      AND C.Campeonato='FIFA World Cup 2018' AND E.Estadio='Luzhniki Stadium'

INSERT INTO Encuentro (IdPais1, IdPais2, IdFase, IdCampeonato, IdEstadio, Fecha)
    SELECT P2.Id, P1.Id, 1, C.Id, E.Id, '20180630'
    FROM Pais P1, Pais P2, Campeonato C, Estadio E
    WHERE P1.Pais='Rusia' AND P2.Pais='Arabia Saudita'
      AND C.Campeonato='FIFA World Cup 2018' AND E.Estadio='Luzhniki Stadium'

