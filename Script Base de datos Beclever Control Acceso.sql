--1° creamos la BD----

Create database BecleverApi

Use BecleverApi

 --2° Creamos las tablas
create table Pais(
IdPais int not null identity(1,1) primary key,
Descripcion varchar(200)null
)

create table Sucursal(
IdSucursal  int not null identity(1,1) primary key,
IdPais int not null,
Descripcion varchar(100) null
)

--Crer La llave foránea o FOREIGN KEY, es una columna o varias columnas, que sirven para señalar
--cual es la llave primaria de otra tabla.
--La columna o columnas señaladas como FOREIGN KEY, solo podrán tener valores 
--que ya existan en la llave primaria PRIMARY KEY de la otra tabla.
--La integridad referencial asegura que se mantengan las referencias entre las claves 
--primarias y las externas. También controla que no pueda eliminarse un registro de una tabla ni modificar 
--la llave primaria si una llave foránea o externa hace referencia al registro.


ALTER TABLE Sucursal
ADD CONSTRAINT FK_Sucursal_Pais
FOREIGN KEY (IdPais) REFERENCES Pais(IdPais);

create table Empleado(
IdEmpleado int not null identity(1,1) primary key,
Nombre varchar(100) not null,
Apellido varchar(100) not null,
Sexo varchar(1) not null
)

create table ControlAcceso (
IdAcceso int not null identity(1,1) primary key,
IdEmpleado int not null,
TipoAcceso varchar(20) not null,
IdSucursal int not null,
Fecha datetime not null
)
ALTER TABLE ControlAcceso
ADD CONSTRAINT FK_ControlAcceso_Empleado
FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado);

ALTER TABLE ControlAcceso
ADD CONSTRAINT FK_ControlAcceso_Sucursal
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal);


---3° Insertamos los datos--

insert into Pais (Descripcion)values('Argentina')
insert into Pais (Descripcion)values('Brasil')
insert into Pais (Descripcion)values('España')

INSERT INTO  Sucursal (IdPais,Descripcion) values (1,'BsAs')
INSERT INTO  Sucursal (IdPais,Descripcion) values (1,'Rosario')
INSERT INTO  Sucursal (IdPais,Descripcion) values (1,'Cordoba')
INSERT INTO  Sucursal (IdPais,Descripcion) values (2,'San Paulo')
INSERT INTO  Sucursal (IdPais,Descripcion) values (2,'Manaos')
INSERT INTO  Sucursal (IdPais,Descripcion) values (3,'Barcelona')

INSERT INTO Empleado (nOMBRE,APELLIDO,SEXO)VALUES('Sebastian','Lopez','M')
INSERT INTO Empleado (nOMBRE,APELLIDO,SEXO)VALUES('Rodrigo','Martinez','M')
INSERT INTO Empleado (nOMBRE,APELLIDO,SEXO)VALUES('Osvaldo','Manticorrea','M')
INSERT INTO Empleado (nOMBRE,APELLIDO,SEXO)VALUES('Valeria','Villalba','F')
INSERT INTO Empleado (nOMBRE,APELLIDO,SEXO)VALUES('Estrella','Torres','F')
INSERT INTO Empleado (nOMBRE,APELLIDO,SEXO)VALUES('Laura','Baldocci','F')
INSERT INTO Empleado (nOMBRE,APELLIDO,SEXO)VALUES('Jorgelina','Mamon','F')

insert into ControlAcceso (IdEmpleado,TipoAcceso,IdSucursal,Fecha)values(1,'INGRESO',1,GETDATE())
insert into ControlAcceso (IdEmpleado,TipoAcceso,IdSucursal,Fecha)values(1,'EGRESO',1,GETDATE())
insert into ControlAcceso (IdEmpleado,TipoAcceso,IdSucursal,Fecha)values(2,'INGRESO',2,GETDATE())
insert into ControlAcceso (IdEmpleado,TipoAcceso,IdSucursal,Fecha)values(2,'EGRESO',2,GETDATE())
insert into ControlAcceso (IdEmpleado,TipoAcceso,IdSucursal,Fecha)values(4,'INGRESO',3,GETDATE())
insert into ControlAcceso (IdEmpleado,TipoAcceso,IdSucursal,Fecha)values(4,'INGRESO',3,GETDATE())
insert into ControlAcceso (IdEmpleado,TipoAcceso,IdSucursal,Fecha)values(8,'INGRESO',1,GETDATE())
insert into ControlAcceso (IdEmpleado,TipoAcceso,IdSucursal,Fecha)values(8,'EGRESO',1,GETDATE())
insert into ControlAcceso (IdEmpleado,TipoAcceso,IdSucursal,Fecha)values(5,'INGRESO',2,GETDATE())
insert into ControlAcceso (IdEmpleado,TipoAcceso,IdSucursal,Fecha)values(5,'EGRESO',2,GETDATE())

----4ro Creamos el Store Procedure-----------------

CREATE PROCEDURE ObtenerAccesosSP
(
-- con estos datos traeme de la BD ----
	@DateFrom Datetime,
	@DateTo   Datetime,
	@Descripcion varchar(200),
	@IdSucursal int
)
AS
BEGIN
	
	SELECT CA.IdEmpleado,
		   EM.Apellido + ',' +EM.Nombre as 'Nombre',
		   CA.fecha,
		   CA.TipoAcceso,
		   SU.Descripcion

	FROM ControlAcceso CA
	INNER JOIN Sucursal SU ON su.IdSucursal=CA.IdSucursal
	INNER JOIN Empleado EM ON em.IdEmpleado=CA.IdEmpleado
	WHERE (CA.fecha>=@DateFrom OR @DateFrom IS NULL)
	AND	(CA.fecha<=@DateTo OR @DateTo IS NULL)
	AND (EM.Nombre like '%' + @Descripcion + '%' OR EM.Apellido like '%' + @Descripcion + '%' OR @Descripcion IS NULL)
	AND (CA.IdSucursal =@IdSucursal OR @IdSucursal IS NULL)
	
END



USE [BecleverApi]


exec ObtenerAccesosSP NULL,NULL,NULL,NULL

