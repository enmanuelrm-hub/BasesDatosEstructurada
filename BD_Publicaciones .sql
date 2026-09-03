CREATE DATABASE BD_Publicaciones
GO

USE BD_Publicaciones
GO

CREATE TABLE Pais(
    Id INT IDENTITY(1,1) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    CodigoAlfa VARCHAR(5)NOT NULL,
    CONSTRAINT pkPais PRIMARY KEY(Id)
)
GO

CREATE UNIQUE INDEX ixPais_Nombre
    ON Pais(Nombre)
GO

CREATE TABLE Region(
    Id INT IDENTITY(1,1) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Codigo VARCHAR(5)NOT NULL,
    IdPais INT NOT NULL,
    CONSTRAINT pkRegion PRIMARY KEY(Id),
    CONSTRAINT fkRegion_Pais FOREIGN KEY (IdPais) REFERENCES Pais(Id)
)
GO

CREATE UNIQUE INDEX ixRegion_Nombre
    ON Region(IdPais, Nombre)
GO

CREATE TABLE Ciudad(
    Id INT IDENTITY(1,1) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    IdRegion INT NOT NULL,
    CONSTRAINT pkCiudad PRIMARY KEY(Id),
    CONSTRAINT fkCiudad_Region FOREIGN KEY (IdRegion) REFERENCES Region(Id)
)
GO

CREATE UNIQUE INDEX ixCiudad_Nombre
    ON Ciudad(IdRegion, Nombre)
GO

CREATE TABLE Editorial(
    Id INT IDENTITY(1, 1) NOT NULL,
    Nombre VARCHAR(150) NOT NULL,
    IdCiudad INT NOT NULL,
    CONSTRAINT pkEditorial PRIMARY KEY(Id),
    CONSTRAINT fkEditorial_Ciudad FOREIGN KEY (IdCiudad) REFERENCES Ciudad(Id)
)
GO

CREATE UNIQUE INDEX ixEditorial_Nombre
    ON Editorial(Nombre)
GO

CREATE TABLE TipoPublicacion(
    Id INT IDENTITY(1, 1) NOT NULL,
    Nombre VARCHAR(50) NOT NULL
    CONSTRAINT pkTipoPublicacion PRIMARY KEY(Id)
)
GO

CREATE UNIQUE INDEX ixTipoPublicacion_Nombre
    ON TipoPublicacion(Nombre)
GO

CREATE TABLE Publicacion(
    Id INT IDENTITY(1,1) NOT NULL,
    Nombre VARCHAR(150) NOT NULL,
    Descripcion VARCHAR(MAX) NULL,
    AñoLanzamiento INT NOT NULL,
    IdTipoPublicacion INT NOT NULL,
    IdEditorial INT NOT NULL,
    CONSTRAINT pkPublicacion PRIMARY KEY(Id),
    CONSTRAINT fkPublicacion_TipoPublicacion FOREIGN KEY (IdTipoPublicacion) REFERENCES TipoPublicacion(Id),
    CONSTRAINT fkPublicacion_Editorial FOREIGN KEY (IdEditorial) REFERENCES Editorial(Id)
)
GO

CREATE UNIQUE INDEX ixPublicacion_NombreIdEditorial
    ON Publicacion(Nombre, IdEditorial)
GO

CREATE TABLE Volumen(
    Id INT IDENTITY(1,1) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    IdPublicacion INT NOT NULL,
    CONSTRAINT pkVolumen PRIMARY KEY(Id),
    CONSTRAINT fkVolumen_Publicacion FOREIGN KEY (IdPublicacion) REFERENCES Publicacion(Id)
)
GO

CREATE UNIQUE INDEX ixVolumen_NombreIdPublicacion
    ON Volumen(Nombre, idPublicacion)
GO

CREATE TABLE TipoAutor(
    Id INT IDENTITY(1, 1) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pkTipoAutor PRIMARY KEY(Id)
)
GO

CREATE UNIQUE INDEX ixTipoAutor_Nombre
    ON TipoAutor(Nombre)
GO

CREATE TABLE Autor(
    Id INT IDENTITY(1, 1) NOT NULL,
    Nombre VARCHAR(150) NOT NULL,
    IdTipoAutor INT NOT NULL,
    CONSTRAINT pkAutor PRIMARY KEY(Id),
    CONSTRAINT fkAutor_TipoAutor FOREIGN KEY (IdTipoAutor) REFERENCES TipoAutor(Id)
)
GO

CREATE UNIQUE INDEX ixAutor_Nombre
    ON Autor(Nombre)
GO

CREATE TABLE PublicacionAutor(
    IdAutor INT NOT NULL,
    IdPublicacion INT NOT NULL,
    CONSTRAINT pkPublicacionAutor PRIMARY KEY (IdAutor, IdPublicacion),
    CONSTRAINT fkPublicacionAutor_Autor FOREIGN KEY (IdAutor) REFERENCES Autor(Id),
    CONSTRAINT fkPublicacionAutor_Publicacion FOREIGN KEY (IdPublicacion) REFERENCES Publicacion(Id)
)
GO

CREATE TABLE Descriptor(
    Id INT IDENTITY(1, 1) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    CONSTRAINT pkDescriptor PRIMARY KEY(Id)
)
GO

CREATE UNIQUE INDEX ixDescriptor_Nombre
    ON Descriptor(Nombre)
GO

CREATE TABLE PublicacionDescriptor(
    IdDescriptor INT NOT NULL,
    IdPublicacion INT NOT NULL,
    CONSTRAINT pkPublicacionDescriptor PRIMARY KEY (IdDescriptor, IdPublicacion),
    CONSTRAINT fkPublicacionDescriptor_Descriptor FOREIGN KEY (IdDescriptor) REFERENCES Descriptor(Id),
    CONSTRAINT fkPublicacionDescriptor_Publicacion FOREIGN KEY (IdPublicacion) REFERENCES Publicacion(Id)
)
GO