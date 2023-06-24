USE GD1C2023
GO

-- CREACION DEL SCHEMA --

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'BI_MODEL')
EXEC('CREATE SCHEMA BI_MODEL');


-- LIMPIAR CACHE --
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'limpiar_cache')
DROP PROCEDURE limpiar_cache
GO
CREATE PROCEDURE limpiar_cache
AS
BEGIN
DBCC FREEPROCCACHE WITH NO_INFOMSGS
DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS
END
GO

-- ELIMINACION PREVENTIVA

IF OBJECT_ID('BI_MODEL.HECHO_PEDIDO', 'U') IS NOT NULL DROP TABLE BI_MODEL.HECHO_PEDIDO
IF OBJECT_ID('BI_MODEL.ESTADO_RECLAMO', 'U') IS NOT NULL DROP TABLE BI_MODEL.ESTADO_RECLAMO
IF OBJECT_ID('BI_MODEL.MENSAJERIA_ESTADO', 'U') IS NOT NULL DROP TABLE BI_MODEL.MENSAJERIA_ESTADO
IF OBJECT_ID('BI_MODEL.PEDIDO_ESTADO', 'U') IS NOT NULL DROP TABLE BI_MODEL.PEDIDO_ESTADO
IF OBJECT_ID('BI_MODEL.TIPO_PAQUETE', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIPO_PAQUETE
IF OBJECT_ID('BI_MODEL.TIPO_MOVILIDAD', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIPO_MOVILIDAD
IF OBJECT_ID('BI_MODEL.TIPO_LOCAL', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIPO_LOCAL
IF OBJECT_ID('BI_MODEL.CATEGORIA', 'U') IS NOT NULL DROP TABLE BI_MODEL.CATEGORIA
IF OBJECT_ID('BI_MODEL.LOCAL', 'U') IS NOT NULL DROP TABLE BI_MODEL.LOCAL
IF OBJECT_ID('BI_MODEL.TIPO_MEDIO_PAGO', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIPO_MEDIO_PAGO
IF OBJECT_ID('BI_MODEL.RANGO_ETARIO', 'U') IS NOT NULL DROP TABLE BI_MODEL.RANGO_ETARIO
IF OBJECT_ID('BI_MODEL.LOCALIDAD', 'U') IS NOT NULL DROP TABLE BI_MODEL.LOCALIDAD
IF OBJECT_ID('BI_MODEL.PROVINCIA', 'U') IS NOT NULL DROP TABLE BI_MODEL.PROVINCIA
IF OBJECT_ID('BI_MODEL.RANGO_HORARIO', 'U') IS NOT NULL DROP TABLE BI_MODEL.RANGO_HORARIO
IF OBJECT_ID('BI_MODEL.DIA', 'U') IS NOT NULL DROP TABLE BI_MODEL.DIA
IF OBJECT_ID('BI_MODEL.TIEMPO', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIEMPO

-- CREACION TABLAS - DIMENSIONES --
CREATE TABLE BI_MODEL.TIEMPO(
	FECHA NVARCHAR(7) PRIMARY KEY,
	ANIO int,
	MES int,
);

CREATE TABLE BI_MODEL.DIA(
	DIA_NRO int PRIMARY KEY,
	DIA nvarchar(50)
);

CREATE TABLE BI_MODEL.RANGO_HORARIO(
	RANGO_HORARIO_NRO int IDENTITY PRIMARY KEY,
	RANGO_HORARIO_INICIO decimal(18, 0),
	RANGO_HORARIO_FIN decimal(18, 0)
);

CREATE TABLE BI_MODEL.PROVINCIA(
	PROVINCIA_NRO int PRIMARY KEY,
	PROVINCIA_NOMBRE nvarchar(255) NOT NULL UNIQUE
);


CREATE TABLE BI_MODEL.LOCALIDAD(
	LOCALIDAD_NRO int PRIMARY KEY,
	LOCALIDAD_PRIVINCIA_NRO int REFERENCES BI_MODEL.PROVINCIA,
	LOCALIDAD_NOMBRE nvarchar(255) NOT NULL,
);

CREATE TABLE BI_MODEL.RANGO_ETARIO(
	RANGO_ETARIO_NRO int PRIMARY KEY,
	RANGO_ETARIO nvarchar(20)
);

CREATE TABLE BI_MODEL.TIPO_MEDIO_PAGO(
	TIPO_MEDIO_PAGO_NRO int PRIMARY KEY,
	TIPO_MEDIO_PAGO nvarchar(50)
);

CREATE TABLE BI_MODEL.LOCAL(
	LOCAL_NRO int PRIMARY KEY,
	LOCAL_NOMBRE nvarchar(100)
);

CREATE TABLE BI_MODEL.CATEGORIA(
	CATEGORIA_NRO int PRIMARY KEY,
	CATEGORIA_NOMBRE nvarchar(50) NOT NULL UNIQUE,
);

CREATE TABLE BI_MODEL.TIPO_LOCAL(
	TIPO_LOCAL_NRO int PRIMARY KEY,
	TIPO_LOCAL_CATEGORIA_NRO int REFERENCES BI_MODEL.CATEGORIA NULL,
	TIPO_LOCAL_NOMBRE nvarchar(50) NOT NULL UNIQUE
);

CREATE TABLE BI_MODEL.TIPO_MOVILIDAD(
	TIPO_MOVILIDAD_NRO int PRIMARY KEY,
	TIPO_MOVILIDAD nvarchar(50) UNIQUE NOT NULL
);

	CREATE TABLE BI_MODEL.TIPO_PAQUETE(
	TIPO_PAQUETE_NRO int PRIMARY KEY,
	TIPO_PAQUETE_NOMBRE  nvarchar(50) NOT NULL UNIQUE,     
);

CREATE TABLE BI_MODEL.PEDIDO_ESTADO(
	PEDIDO_ESTADO_NRO int PRIMARY KEY,
	PEDIDO_ESTADO nvarchar(50) NOT NULL UNIQUE
);

CREATE TABLE BI_MODEL.MENSAJERIA_ESTADO(
	MENSAJERIA_ESTADO_NRO int PRIMARY KEY,
	ENVIO_MENSAJERIA_ESTADO nvarchar(50) NOT NULL UNIQUE,
);

CREATE TABLE BI_MODEL.ESTADO_RECLAMO(
	ESTADO_RECLAMO_NRO int PRIMARY KEY,
	ESTADO_RECLAMO_NOMBRE NVARCHAR(50) NOT NULL UNIQUE,
);

-- TABLAS HECHOS --
CREATE TABLE BI_MODEL.HECHO_PEDIDO(
	ID_HECHO_PEDIDO int IDENTITY PRIMARY KEY,
	HECHO_PEDIDO_DIA_NRO int REFERENCES BI_MODEL.DIA,
	HECHO_PEDIDO_RANGO_NRO int REFERENCES BI_MODEL.RANGO_HORARIO,
	HECHO_PEDIDO_LOCALIDAD_NRO int REFERENCES BI_MODEL.LOCALIDAD,
	HECHO_PEDIDO_CATEGORIA_NRO int REFERENCES BI_MODEL.CATEGORIA,
	HECHO_PEDIDO_PEDIDO_ESTADO_NRO int REFERENCES BI_MODEL.PEDIDO_ESTADO,
	HECHO_PEDIDO_LOCAL_NRO int REFERENCES BI_MODEL.LOCAL,
	HECHO_PEDIDO_CANTIDAD_PEDIDOS int,
	HECHO_PEDIDO_CANTIDAD_PEDIDOS_CANCELADOS int
);


IF OBJECT_ID('obtenerRangoHorarioNro', 'FN') IS NOT NULL
DROP FUNCTION obtenerRangoHorarioNro;
GO
CREATE FUNCTION obtenerRangoHorarioNro(@fecha datetime) RETURNS int 
AS
BEGIN
	DECLARE @hora int;
	SET @hora = DATEPART(hour, @fecha);

	DECLARE @rangoHorarioNro int;
	SELECT @rangoHorarioNro = RANGO_HORARIO_NRO FROM BI_MODEL.RANGO_HORARIO WHERE @hora >= RANGO_HORARIO_INICIO AND @hora <RANGO_HORARIO_FIN ;
	RETURN @rangoHorarioNro;
END
GO


IF OBJECT_ID('MIGRAR_TIEMPO', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_TIEMPO;
GO
CREATE PROCEDURE MIGRAR_TIEMPO
AS
	BEGIN
		INSERT INTO BI_MODEL.TIEMPO(FECHA,ANIO,MES)
		SELECT * FROM(
			SELECT DISTINCT FORMAT(PEDIDO_ENVIO_FECHA, 'yyyy-MM') AS FECHA, 
							YEAR(PEDIDO_ENVIO_FECHA) AS ANIO, 
							MONTH(PEDIDO_ENVIO_FECHA) AS MES
			FROM NEW_MODEL.PEDIDO_ENVIO 
			UNION
			SELECT DISTINCT FORMAT(ENVIO_MENSAJERIA_FECHA, 'yyyy-MM') AS FECHA, 
							YEAR(ENVIO_MENSAJERIA_FECHA) AS ANIO, 
							MONTH(ENVIO_MENSAJERIA_FECHA) AS MES
			FROM NEW_MODEL.ENVIO_MENSAJERIA
			) A ORDER BY 1 DESC
	END
GO

IF OBJECT_ID('MIGRAR_DIA', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_DIA;
GO
CREATE PROCEDURE MIGRAR_DIA
AS
	BEGIN
		INSERT INTO BI_MODEL.DIA(DIA_NRO,DIA)
		VALUES  (1, 'Lunes'), 
				(2, 'Martes'), 
				(3, 'Miercoles'), 
				(4, 'Jueves'), 
				(5, 'Viernes'), 
				(6, 'Sabado'),
				(7, 'Domingo')
	END
GO

IF OBJECT_ID('MIGRAR_RANGO_HORARIO', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_RANGO_HORARIO;
GO
CREATE PROCEDURE MIGRAR_RANGO_HORARIO
AS
	BEGIN
		DECLARE @horaInicio decimal(18, 0) = '8';
		DECLARE @horaFin decimal(18, 0) = '24';
		DECLARE @horaActual decimal(18, 0) = @horaInicio;

		WHILE @horaActual < @horaFin
		BEGIN
			INSERT INTO BI_MODEL.RANGO_HORARIO(RANGO_HORARIO_INICIO,RANGO_HORARIO_FIN) VALUES (@horaActual,@horaActual+2);
			SET @horaActual = @horaActual + 2;
		END
	END
GO

IF OBJECT_ID('MIGRAR_PROVINCIA', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_PROVINCIA;
GO
CREATE PROCEDURE MIGRAR_PROVINCIA
AS
	BEGIN
		INSERT INTO BI_MODEL.PROVINCIA(PROVINCIA_NRO,PROVINCIA_NOMBRE)
			SELECT PROVINCIA_NRO,PROVINCIA_NOMBRE
			FROM NEW_MODEL.PROVINCIA 

	END
GO

IF OBJECT_ID('MIGRAR_LOCALIDAD', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_LOCALIDAD;
GO
CREATE PROCEDURE MIGRAR_LOCALIDAD
AS
	BEGIN
		INSERT INTO BI_MODEL.LOCALIDAD(LOCALIDAD_NRO,LOCALIDAD_PRIVINCIA_NRO,LOCALIDAD_NOMBRE)
			SELECT 	LOCALIDAD_NRO ,
					LOCALIDAD_PRIVINCIA_NRO,
					LOCALIDAD_NOMBRE
			FROM NEW_MODEL.LOCALIDAD 

	END
GO

IF OBJECT_ID('MIGRAR_RANGO_ETARIO', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_RANGO_ETARIO;
GO
CREATE PROCEDURE MIGRAR_RANGO_ETARIO
AS
	BEGIN
		INSERT INTO BI_MODEL.RANGO_ETARIO(RANGO_ETARIO_NRO,RANGO_ETARIO)
		VALUES 	(1, 'Menores a 25 años'), 
				(2, 'Entre 25 a 35 años'), 
				(3, 'Entre 35 a 55 años'), 
				(4, 'Mayores a 55 años')
	END
GO

IF OBJECT_ID('MIGRAR_TIPO_MEDIO_PAGO', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_TIPO_MEDIO_PAGO;
GO
CREATE PROCEDURE MIGRAR_TIPO_MEDIO_PAGO
AS
	BEGIN
		INSERT INTO BI_MODEL.TIPO_MEDIO_PAGO(TIPO_MEDIO_PAGO_NRO,TIPO_MEDIO_PAGO)
		SELECT DISTINCT MEDIO_PAGO_NRO, MEDIO_PAGO FROM NEW_MODEL.MEDIO_PAGO
	END
GO

IF OBJECT_ID('MIGRAR_LOCAL', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_LOCAL;
GO
CREATE PROCEDURE MIGRAR_LOCAL 
AS
    BEGIN
        INSERT INTO BI_MODEL.LOCAL(LOCAL_NRO,LOCAL_NOMBRE)
        SELECT LOCAL_NRO,LOCAL_NOMBRE FROM NEW_MODEL.LOCAL
    END
GO

IF OBJECT_ID('MIGRAR_CATEGORIA', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_CATEGORIA;
GO
CREATE PROCEDURE MIGRAR_CATEGORIA 
AS
    BEGIN
        INSERT INTO BI_MODEL.CATEGORIA(CATEGORIA_NRO, CATEGORIA_NOMBRE)
        VALUES
		(1, 'Parrilla'),
		(2, 'Heladeria'),
		(3, 'Kiosco'),
		(4, 'Supermercado')
    END
GO

IF OBJECT_ID('MIGRAR_TIPO_LOCAL', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_TIPO_LOCAL;
GO
CREATE PROCEDURE MIGRAR_TIPO_LOCAL 
AS
    BEGIN
        INSERT INTO BI_MODEL.TIPO_LOCAL(TIPO_LOCAL_NRO,TIPO_LOCAL_CATEGORIA_NRO,TIPO_LOCAL_NOMBRE)
        SELECT TIPO_LOCAL_NRO, TIPO_LOCAL_CATEGORIA_NRO, TIPO_LOCAL_NOMBRE FROM NEW_MODEL.TIPO_LOCAL;

		UPDATE BI_MODEL.TIPO_LOCAL
		SET TIPO_LOCAL_CATEGORIA_NRO = 1 WHERE TIPO_LOCAL_NRO = 1

		UPDATE BI_MODEL.TIPO_LOCAL
		SET TIPO_LOCAL_CATEGORIA_NRO = 3 WHERE TIPO_LOCAL_NRO = 2

    END
GO


IF OBJECT_ID('MIGRAR_TIPO_MOVILIDAD', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_TIPO_MOVILIDAD;
GO
CREATE PROCEDURE MIGRAR_TIPO_MOVILIDAD 
AS
    BEGIN
        INSERT INTO BI_MODEL.TIPO_MOVILIDAD(TIPO_MOVILIDAD_NRO, TIPO_MOVILIDAD)
        SELECT TIPO_MOVILIDAD_NRO, TIPO_MOVILIDAD_NOMBRE FROM NEW_MODEL.TIPO_MOVILIDAD;
    END
GO

IF OBJECT_ID('MIGRAR_TIPO_PAQUETE', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_TIPO_PAQUETE;
GO
CREATE PROCEDURE MIGRAR_TIPO_PAQUETE 
AS
    BEGIN
        INSERT INTO BI_MODEL.TIPO_PAQUETE(TIPO_PAQUETE_NRO, TIPO_PAQUETE_NOMBRE)
        SELECT TIPO_PAQUETE_NRO, TIPO_PAQUETE_NOMBRE FROM NEW_MODEL.TIPO_PAQUETE;
    END
GO

IF OBJECT_ID('MIGRAR_PEDIDO_ESTADO', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_PEDIDO_ESTADO;
GO
CREATE PROCEDURE MIGRAR_PEDIDO_ESTADO 
AS
    BEGIN
        INSERT INTO BI_MODEL.PEDIDO_ESTADO(PEDIDO_ESTADO_NRO, PEDIDO_ESTADO)
        SELECT PEDIDO_ESTADO_NRO, PEDIDO_ESTADO FROM NEW_MODEL.PEDIDO_ESTADO;
    END
GO

IF OBJECT_ID('MIGRAR_MENSAJERIA_ESTADO', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_MENSAJERIA_ESTADO;
GO
CREATE PROCEDURE MIGRAR_MENSAJERIA_ESTADO 
AS
    BEGIN
        INSERT INTO BI_MODEL.MENSAJERIA_ESTADO(MENSAJERIA_ESTADO_NRO, ENVIO_MENSAJERIA_ESTADO)
        SELECT MENSAJERIA_ESTADO_NRO, ENVIO_MENSAJERIA_ESTADO FROM NEW_MODEL.MENSAJERIA_ESTADO;
    END
GO

IF OBJECT_ID('MIGRAR_ESTADO_RECLAMO', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_ESTADO_RECLAMO;
GO
CREATE PROCEDURE MIGRAR_ESTADO_RECLAMO 
AS
    BEGIN
        INSERT INTO BI_MODEL.ESTADO_RECLAMO(ESTADO_RECLAMO_NRO, ESTADO_RECLAMO_NOMBRE)
        SELECT ESTADO_RECLAMO_NRO, ESTADO_RECLAMO_NOMBRE FROM NEW_MODEL.ESTADO_RECLAMO;
    END
GO

IF OBJECT_ID('MIGRAR_HECHO_PEDIDO', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_HECHO_PEDIDO;
GO
CREATE PROCEDURE MIGRAR_HECHO_PEDIDO 
AS
    BEGIN
        INSERT INTO BI_MODEL.HECHO_PEDIDO(
			HECHO_PEDIDO_DIA_NRO,
			HECHO_PEDIDO_RANGO_NRO,
			HECHO_PEDIDO_LOCALIDAD_NRO,
			HECHO_PEDIDO_CATEGORIA_NRO,
			HECHO_PEDIDO_PEDIDO_ESTADO_NRO,
			HECHO_PEDIDO_LOCAL_NRO,
			HECHO_PEDIDO_CANTIDAD_PEDIDOS ,
			HECHO_PEDIDO_CANTIDAD_PEDIDOS_CANCELADOS 
		)
		SELECT 	
			DATEPART(WEEKDAY,t_pedido_envio.PEDIDO_ENVIO_FECHA) AS DIA_NRO,
			dbo.obtenerRangoHorarioNro(t_pedido_envio.PEDIDO_ENVIO_FECHA) AS RANGO,
			t_rango_horario.RANGO_HORARIO_INICIO AS HORA_INICIO,
			t_rango_horario.RANGO_HORARIO_FIN AS HORA_FIN,
			t_localidad.LOCALIDAD_NOMBRE AS LOCALIDAD,
			t_categoria.CATEGORIA_NOMBRE AS CATEGORIA,
			COUNT (DISTINCT t_pedido.PEDIDO_NRO) AS CANT_PEDIDOS
		FROM NEW_MODEL.PEDIDO t_pedido
		JOIN NEW_MODEL.PEDIDO_ENVIO t_pedido_envio ON t_pedido_envio.PEDIDO_ENVIO_NRO = t_pedido.PEDIDO_ENVIO_NRO
		JOIN BI_MODEL.RANGO_HORARIO t_rango_horario ON t_rango_horario.RANGO_HORARIO_NRO = dbo.obtenerRangoHorarioNro(t_pedido_envio.PEDIDO_ENVIO_FECHA)
		JOIN NEW_MODEL.DIRECCION_USUARIO t_direccion_usuario ON t_direccion_usuario.DIRECCION_USUARIO_NRO = t_pedido_envio.PEDIDO_ENVIO_DIRECCION_USUARIO_NRO
		JOIN NEW_MODEL.LOCALIDAD t_localidad ON t_localidad.LOCALIDAD_NRO = t_direccion_usuario.DIRECCION_USUARIO_LOCALIDAD_NRO
		JOIN NEW_MODEL.ITEM t_item ON t_item.ITEM_PEDIDO_NRO = t_pedido.PEDIDO_NRO
		JOIN NEW_MODEL.LOCAL t_local ON t_local.LOCAL_NRO = t_item.ITEM_LOCAL_PRODUCTO_LOCAL_NRO
		JOIN BI_MODEL.TIPO_LOCAL t_tipo_local ON t_tipo_local.TIPO_LOCAL_NRO = t_local.LOCAL_TIPO_LOCAL_NRO
		JOIN BI_MODEL.CATEGORIA t_categoria ON t_categoria.CATEGORIA_NRO = t_tipo_local.TIPO_LOCAL_CATEGORIA_NRO 
		GROUP BY DATEPART(WEEKDAY,t_pedido_envio.PEDIDO_ENVIO_FECHA), dbo.obtenerRangoHorarioNro(t_pedido_envio.PEDIDO_ENVIO_FECHA), t_rango_horario.RANGO_HORARIO_INICIO,t_rango_horario.RANGO_HORARIO_FIN, t_localidad.LOCALIDAD_NOMBRE, t_categoria.CATEGORIA_NOMBRE

		-- SELECT SUM(CANT_PEDIDOS) FROM () T

		SELECT DISTINCT DATEPART(hour, PEDIDO_ENVIO_FECHA) FROM NEW_MODEL.PEDIDO_ENVIO
		SELECT * FROM BI_MODEL.TIPO_LOCAL
    END
GO

IF OBJECT_ID('migrar_bi', 'P') IS NOT NULL
    DROP PROCEDURE migrar_bi;
GO
CREATE PROCEDURE migrar_bi
AS
BEGIN
	BEGIN TRANSACTION
BEGIN TRY
EXEC MIGRAR_TIEMPO;
EXEC MIGRAR_DIA;
EXEC MIGRAR_RANGO_HORARIO;
EXEC MIGRAR_PROVINCIA;
EXEC MIGRAR_LOCALIDAD;


PRINT '--- Tablas BI migradas correctamente --';
COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
THROW 50001, 'No se migraron las tablas BI',1;
END CATCH

END
GO