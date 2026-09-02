/* ============================================================
   BASE DE DATOS: Registro Bibliográfico de Publicaciones
   Institución Universitaria de Envigado - Bases de Datos
   Script de creación (1 sola ejecución) - SQL Server
   ============================================================ */

USE master;
GO

IF DB_ID('BD_Publicaciones') IS NOT NULL
BEGIN
    ALTER DATABASE BD_Publicaciones SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BD_Publicaciones;
END
GO

CREATE DATABASE BD_Publicaciones;
GO

USE BD_Publicaciones;
GO

/* ============================================================
   1. UBICACIÓN GEOGRÁFICA DE LAS EDITORIALES
   Pais -> Region -> Ciudad -> Editorial
   ============================================================ */

CREATE TABLE Pais (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Nombre      VARCHAR(100) NOT NULL,
    CodigoAlfa  CHAR(3)      NOT NULL,      -- ej. COL, MEX, ESP (ISO alpha-3)
    CONSTRAINT UQ_Pais_CodigoAlfa UNIQUE (CodigoAlfa)
);
GO

CREATE TABLE Region (
    Id      INT IDENTITY(1,1) PRIMARY KEY,
    Nombre  VARCHAR(100) NOT NULL,
    IdPais  INT NOT NULL,
    CONSTRAINT FK_Region_Pais FOREIGN KEY (IdPais)
        REFERENCES Pais(Id)
);
GO

CREATE TABLE Ciudad (
    Id        INT IDENTITY(1,1) PRIMARY KEY,
    Nombre    VARCHAR(100) NOT NULL,
    IdRegion  INT NOT NULL,
    CONSTRAINT FK_Ciudad_Region FOREIGN KEY (IdRegion)
        REFERENCES Region(Id)
);
GO

CREATE TABLE Editorial (
    Id        INT IDENTITY(1,1) PRIMARY KEY,
    Nombre    VARCHAR(150) NOT NULL,
    IdCiudad  INT NOT NULL,
    CONSTRAINT FK_Editorial_Ciudad FOREIGN KEY (IdCiudad)
        REFERENCES Ciudad(Id)
);
GO

/* ============================================================
   2. CATÁLOGOS: TipoPublicacion, TipoAutor
   ============================================================ */

CREATE TABLE TipoPublicacion (
    Id      INT IDENTITY(1,1) PRIMARY KEY,
    Nombre  VARCHAR(50) NOT NULL,   -- ej. Libro, Revista, Periodico, Tesis, Otro
    CONSTRAINT UQ_TipoPublicacion_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE TipoAutor (
    Id      INT IDENTITY(1,1) PRIMARY KEY,
    Nombre  VARCHAR(50) NOT NULL,   -- ej. Persona natural, Autor corporativo
    CONSTRAINT UQ_TipoAutor_Nombre UNIQUE (Nombre)
);
GO

/* ============================================================
   3. ENTIDADES PRINCIPALES: Publicacion, Volumen, Autor, Descriptor
   ============================================================ */

CREATE TABLE Publicacion (
    Id                 INT IDENTITY(1,1) PRIMARY KEY,
    Nombre             VARCHAR(200) NOT NULL,
    Descripcion        VARCHAR(500) NULL,
    AnioLanzamiento    SMALLINT NOT NULL,
    IdTipoPublicacion  INT NOT NULL,
    IdEditorial        INT NOT NULL,
    CONSTRAINT FK_Publicacion_TipoPublicacion FOREIGN KEY (IdTipoPublicacion)
        REFERENCES TipoPublicacion(Id),
    CONSTRAINT FK_Publicacion_Editorial FOREIGN KEY (IdEditorial)
        REFERENCES Editorial(Id),
    CONSTRAINT CK_Publicacion_Anio CHECK (
        AnioLanzamiento BETWEEN 1400 AND 2100
    )
);
GO

-- Volumen: solo aplica a publicaciones seriadas (ej. revistas)
CREATE TABLE Volumen (
    Id             INT IDENTITY(1,1) PRIMARY KEY,
    Nombre         VARCHAR(50) NOT NULL,   -- ej. "Vol. 3 No. 2"
    IdPublicacion  INT NOT NULL,
    CONSTRAINT FK_Volumen_Publicacion FOREIGN KEY (IdPublicacion)
        REFERENCES Publicacion(Id)
);
GO

-- Autor: incluye tanto personas naturales como autores corporativos
CREATE TABLE Autor (
    Id           INT IDENTITY(1,1) PRIMARY KEY,
    Nombre       VARCHAR(150) NOT NULL,
    IdTipoAutor  INT NOT NULL,
    CONSTRAINT FK_Autor_TipoAutor FOREIGN KEY (IdTipoAutor)
        REFERENCES TipoAutor(Id)
);
GO

CREATE TABLE Descriptor (
    Id      INT IDENTITY(1,1) PRIMARY KEY,
    Nombre  VARCHAR(100) NOT NULL,
    CONSTRAINT UQ_Descriptor_Nombre UNIQUE (Nombre)
);
GO

/* ============================================================
   4. TABLAS PUENTE (relaciones muchos a muchos)
   ============================================================ */

-- Una publicación puede tener uno o varios autores, y un autor
-- puede figurar en varias publicaciones
CREATE TABLE PublicacionAutor (
    IdAutor        INT NOT NULL,
    IdPublicacion  INT NOT NULL,
    CONSTRAINT PK_PublicacionAutor PRIMARY KEY (IdAutor, IdPublicacion),
    CONSTRAINT FK_PublicacionAutor_Autor FOREIGN KEY (IdAutor)
        REFERENCES Autor(Id),
    CONSTRAINT FK_PublicacionAutor_Publicacion FOREIGN KEY (IdPublicacion)
        REFERENCES Publicacion(Id)
);
GO

-- Una publicación puede clasificarse con uno o varios descriptores
CREATE TABLE PublicacionDescriptor (
    IdDescriptor   INT NOT NULL,
    IdPublicacion  INT NOT NULL,
    CONSTRAINT PK_PublicacionDescriptor PRIMARY KEY (IdDescriptor, IdPublicacion),
    CONSTRAINT FK_PublicacionDescriptor_Descriptor FOREIGN KEY (IdDescriptor)
        REFERENCES Descriptor(Id),
    CONSTRAINT FK_PublicacionDescriptor_Publicacion FOREIGN KEY (IdPublicacion)
        REFERENCES Publicacion(Id)
);
GO

/* ============================================================
   FIN DEL SCRIPT
   ============================================================ */
