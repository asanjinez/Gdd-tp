USE GD1C2023
GO

-- CREACION DEL SCHEMA --
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'NEW_MODEL')
BEGIN
    EXEC('CREATE SCHEMA NEW_MODEL');
END

-- CREACION DE TABLAS --
IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'MENSAJERIA')
BEGIN 
    DROP TABLE NEW_MODEL.MENSAJERIA
END

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'ENVIO_MENSAJERIA')
BEGIN 
    DROP TABLE NEW_MODEL.ENVIO_MENSAJERIA
END

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'MENSAJERIA_ESTADO')
BEGIN 
    DROP TABLE NEW_MODEL.MENSAJERIA_ESTADO
END

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PAQUETE')
BEGIN 
    DROP TABLE NEW_MODEL.PAQUETE
END

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'TIPO_PAQUETE')
BEGIN 
    DROP TABLE NEW_MODEL.TIPO_PAQUETE
END

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'CUPON_RECLAMO')
BEGIN 
    DROP TABLE NEW_MODEL.CUPON_RECLAMO;
END

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'CUPON')
BEGIN 
    DROP TABLE NEW_MODEL.CUPON;
END

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'CUPON_TIPO')
BEGIN 
    DROP TABLE NEW_MODEL.CUPON_TIPO;
END

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'RECLAMO')
BEGIN
    DROP TABLE NEW_MODEL.RECLAMO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'OPERADOR')
BEGIN
    DROP TABLE NEW_MODEL.OPERADOR;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'ESTADO_RECLAMO')
BEGIN
    DROP TABLE NEW_MODEL.ESTADO_RECLAMO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'TIPO_RECLAMO')
BEGIN
    DROP TABLE NEW_MODEL.TIPO_RECLAMO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'ITEM')
BEGIN
    DROP TABLE NEW_MODEL.ITEM;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'LOCAL_PRODUCTO')
BEGIN
    DROP TABLE NEW_MODEL.LOCAL_PRODUCTO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PRODUCTO')
BEGIN
    DROP TABLE NEW_MODEL.PRODUCTO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'HORARIO')
BEGIN
    DROP TABLE NEW_MODEL.HORARIO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'DIA')
BEGIN
    DROP TABLE NEW_MODEL.DIA;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'LOCAL')
BEGIN
    DROP TABLE NEW_MODEL.LOCAL;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'CATEGORIA')
BEGIN
    DROP TABLE NEW_MODEL.CATEGORIA;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'TIPO_LOCAL')
BEGIN
    DROP TABLE NEW_MODEL.TIPO_LOCAL;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PEDIDO')
BEGIN
    DROP TABLE NEW_MODEL.PEDIDO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'MEDIO_PAGO')
BEGIN
    DROP TABLE NEW_MODEL.MEDIO_PAGO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'MEDIO_PAGO_TIPO')
BEGIN
    DROP TABLE NEW_MODEL.MEDIO_PAGO_TIPO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PEDIDO_ESTADO')
BEGIN
    DROP TABLE NEW_MODEL.PEDIDO_ESTADO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PEDIDO_ENVIO')
BEGIN
    DROP TABLE NEW_MODEL.PEDIDO_ENVIO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'DIRECCION_USUARIO')
BEGIN
    DROP TABLE NEW_MODEL.DIRECCION_USUARIO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'ALTA')
BEGIN
    DROP TABLE NEW_MODEL.ALTA;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'REPARTIDOR')
BEGIN
    DROP TABLE NEW_MODEL.REPARTIDOR;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'TIPO_MOVILIDAD')
BEGIN
    DROP TABLE NEW_MODEL.TIPO_MOVILIDAD;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'USUARIO')
BEGIN
    DROP TABLE NEW_MODEL.USUARIO;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'LOCALIDAD')
BEGIN
    DROP TABLE NEW_MODEL.LOCALIDAD;
END;

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PROVINCIA')
BEGIN
    DROP TABLE NEW_MODEL.PROVINCIA;
END;

CREATE TABLE NEW_MODEL.PROVINCIA(
    PROVINCIA_NRO int IDENTITY PRIMARY KEY,
    PROVINCIA_NOMBRE nvarchar(255) NOT NULL UNIQUE,
);

CREATE TABLE NEW_MODEL.LOCALIDAD(
    LOCALIDAD_NRO int IDENTITY PRIMARY KEY,
    LOCALIDAD_PRIVINCIA_NRO int REFERENCES NEW_MODEL.PROVINCIA,
    LOCALIDAD_NOMBRE nvarchar(255) NOT NULL,
);

CREATE TABLE NEW_MODEL.USUARIO(
    USUARIO_NRO int IDENTITY PRIMARY KEY,
    USUARIO_NOMBRE nvarchar(255) NOT NULL,
    USUARIO_APELLIDO nvarchar(255) NOT NULL,
    USUARIO_DNI decimaL(18,0) NOT NULL UNIQUE,
    USUARIO_FECHA_REGISTRO datetime2(3) NOT NULL,  
    USUARIO_TELEFONO decimal(18, 0) NOT NULL,
    USUARIO_MAIL nvarchar(255) NOT NULL UNIQUE,      
    USUARIO_FECHA_NAC date NOT NULL
);

CREATE TABLE NEW_MODEL.TIPO_MOVILIDAD(
   TIPO_MOVILIDAD_NRO int IDENTITY PRIMARY KEY,
   TIPO_MOVILIDAD_NOMBRE nvarchar(50) NOT NULL UNIQUE
);

CREATE TABLE NEW_MODEL.REPARTIDOR(
    REPARTIDOR_NRO int IDENTITY PRIMARY KEY,
    REPARTIDOR_TIPO_MOVILIDAD_NRO int REFERENCES NEW_MODEL.TIPO_MOVILIDAD,
    REPARTIDOR_NOMBRE nvarchar(255) NOT NULL,
    REPARTIDOR_APELLIDO nvarchar(255) NOT NULL,
    REPARTIDOR_DNI decimal(18, 0) NOT NULL UNIQUE,
    REPARTIDOR_TELEFONO decimal(18, 0) NOT NULL,
    REPARTIDOR_DIRECION nvarchar(255) NOT NULL,
    REPARTIDOR_EMAIL nvarchar(255) NOT NULL UNIQUE,
    REPARTIDOR_FECHA_NAC date NOT NULL,
    REPARTIDOR_TIPO_MOVILIDAD nvarchar(50) NOT NULL
);

CREATE TABLE NEW_MODEL.ALTA(
    ALTA_REPARTIDOR_NRO int REFERENCES NEW_MODEL.REPARTIDOR,
    ALTA_LOCALIDAD_NRO int REFERENCES NEW_MODEL.LOCALIDAD,
    ALTA_ACTIVA BIT NOT NULL,
    PRIMARY KEY(ALTA_REPARTIDOR_NRO,ALTA_LOCALIDAD_NRO)
);

CREATE TABLE NEW_MODEL.DIRECCION_USUARIO(
    DIRECCION_USUARIO_NRO int IDENTITY PRIMARY KEY,
    DIRECCION_USUARIO_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO NOT NULL,
    DIRECCION_USUARIO_LOCALIDAD_NRO int REFERENCES NEW_MODEL.LOCALIDAD NOT NULL,
    DIRECCION_USUARIO_NOMBRE nvarchar(50) NOT NULL,
    DIRECCION_USUARIO_DIRECCION nvarchar(255) NOT NULL,
);


CREATE TABLE NEW_MODEL.PEDIDO_ENVIO(
    PEDIDO_ENVIO_NRO int IDENTITY PRIMARY KEY,
    PEDIDO_ENVIO_REPARTIDOR_NRO int REFERENCES NEW_MODEL.REPARTIDOR,
    PEDIDO_ENVIO_DIRECCION_USUARIO_NRO int REFERENCES NEW_MODEL.DIRECCION_USUARIO NOT NULL,
    PEDIDO_ENVIO_PRECIO decimal(18, 2) DEFAULT 0 NOT NULL,
    PEDIDO_ENVIO_TARIFA_SERVICIO decimal(18, 2) DEFAULT 0 NOT NULL,
    PEDIDO_ENVIO_PROPINA decimal(18, 2) DEFAULT 0 NOT NULL
);


CREATE TABLE NEW_MODEL.PEDIDO_ESTADO(
    PEDIDO_ESTADO_NRO int IDENTITY PRIMARY KEY,
    PEDIDO_ESTADO nvarchar(50) NOT NULL UNIQUE
);


CREATE TABLE NEW_MODEL.MEDIO_PAGO_TIPO(
    MEDIO_PAGO_TIPO_NRO int IDENTITY PRIMARY KEY,
    MEDIO_PAGO_TIPO nvarchar(50) NOT NULL UNIQUE
);


CREATE TABLE NEW_MODEL.MEDIO_PAGO(
    MEDIO_PAGO_NRO int IDENTITY PRIMARY KEY,
    MEDIO_PAGO_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO NOT NULL,
    MEDIO_PAGO_TIPO_NRO int REFERENCES NEW_MODEL.MEDIO_PAGO_TIPO NOT NULL,
    MEDIO_PAGO_NRO_TARJETA nvarchar(50) NULL,
    MEDIO_PAGO_MARCA_TARJETA nvarchar(100) NULL
);


CREATE TABLE NEW_MODEL.PEDIDO(
    PEDIDO_NRO int IDENTITY PRIMARY KEY,
    PEDIDO_PEDIDO_ENVIO_NRO int REFERENCES NEW_MODEL.PEDIDO_ENVIO NULL,
    PEDIDO_ESTADO_NRO int REFERENCES NEW_MODEL.PEDIDO_ESTADO NOT NULL,
    PEDIDO_MEDIO_PAGO_NRO int REFERENCES NEW_MODEL.MEDIO_PAGO NOT NULL,
    PEDIDO_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO NOT NULL,
    PEDIDO_TOTAL_CUPONES decimal(18, 2) DEFAULT 0 NOT NULL,
    PEDIDO_OBSERV nvarchar(255) NULL,
    PEDIDO_FECHA datetime NOT NULL,
    PEDIDO_FECHA_ENTREGA datetime NOT NULL,
    PEDIDO_TIEMPO_ESTIMADO_ENTREGA decimal(18, 2) NOT NULL,
    PEDIDO_CALIFICACION decimal(18, 0) NULL,
    PEDIDO_TOTAL_SERVICIO decimal(18, 2) NULL,
	PEDIDO_TOTAL_PRODUCTOS decimal(18, 2) NULL
);

CREATE TABLE NEW_MODEL.TIPO_LOCAL(
    TIPO_LOCAL_NRO int IDENTITY PRIMARY KEY,
    TIPO_LOCAL_NOMBRE nvarchar(50) NOT NULL UNIQUE,
);

CREATE TABLE NEW_MODEL.CATEGORIA(
    CATEGORIA_NRO int IDENTITY PRIMARY KEY,
    CATEGORIA_TIPO_LOCAL_NRO int REFERENCES NEW_MODEL.TIPO_LOCAL,
    CATEGORIA_NOMBRE nvarchar(50) NOT NULL UNIQUE,
);

CREATE TABLE NEW_MODEL.LOCAL(
    LOCAL_NRO int IDENTITY PRIMARY KEY,
    LOCAL_CATEGORIA_NRO int REFERENCES NEW_MODEL.CATEGORIA,
    LOCAL_LOCALIDAD_NRO int REFERENCES NEW_MODEL.LOCALIDAD,
    LOCAL_NOMBRE nvarchar(100) NOT NULL,
	LOCAL_DESCRIPCION nvarchar(255) NOT NULL,
	LOCAL_DIRECCION nvarchar(255) NOT NULL,
);

CREATE TABLE NEW_MODEL.DIA(
    DIA_NRO int IDENTITY PRIMARY KEY,
    HORARIO_LOCAL_DIA nvarchar(50) NULL,

);

CREATE TABLE NEW_MODEL.HORARIO(
    HORARIO_NRO int IDENTITY PRIMARY KEY,
    HORARIO_LOCAL_NRO int REFERENCES NEW_MODEL.LOCAL,
    HORARIO_DIA int REFERENCES NEW_MODEL.DIA,
	HORARIO_LOCAL_HORA_APERTURA decimal(18, 0) NULL,
	HORARIO_LOCAL_HORA_CIERRE decimal(18, 0) NULL,
);


CREATE TABLE NEW_MODEL.PRODUCTO(
    PRDUCTO_NRO int IDENTITY PRIMARY KEY,
    PRODUCTO_LOCAL_CODIGO nvarchar(50) UNIQUE,
	PRODUCTO_LOCAL_NOMBRE nvarchar(50) NOT NULL,
	PRODUCTO_LOCAL_DESCRIPCION nvarchar(255) NOT NULL,
);

CREATE TABLE NEW_MODEL.LOCAL_PRODUCTO(
    LOCAL_PRODUCTO_LOCAL_NRO int REFERENCES NEW_MODEL.LOCAL,
    LOCAL_PRODUCTO_PRODUCTO_NRO int REFERENCES NEW_MODEL.PRODUCTO,
    PRIMARY KEY(LOCAL_PRODUCTO_LOCAL_NRO, LOCAL_PRODUCTO_PRODUCTO_NRO)
);

CREATE TABLE NEW_MODEL.ITEM(
	ITEM_LOCAL_PRODUCTO_LOCAL_NRO int,
	ITEM_LOCAL_PRODUCTO_PRODUCTO_NRO int,
    ITEM_PEDIDO_NRO int REFERENCES NEW_MODEL.PEDIDO,
    ITEM_CANTIDAD decimal(18,0) DEFAULT 0 NOT NULL,
    ITEM_PRECIO decimal(18,2) DEFAULT 0 NOT NULL,
    ITEM_TOTAL decimal(18,2) DEFAULT 0 NOT NULL,
	FOREIGN KEY (ITEM_LOCAL_PRODUCTO_LOCAL_NRO, ITEM_LOCAL_PRODUCTO_PRODUCTO_NRO) REFERENCES NEW_MODEL.LOCAL_PRODUCTO(LOCAL_PRODUCTO_LOCAL_NRO, LOCAL_PRODUCTO_PRODUCTO_NRO),
    PRIMARY KEY(ITEM_LOCAL_PRODUCTO_LOCAL_NRO, ITEM_LOCAL_PRODUCTO_PRODUCTO_NRO,ITEM_PEDIDO_NRO)
);

CREATE TABLE NEW_MODEL.TIPO_RECLAMO(
	TIPO_RECLAMO_NRO int IDENTITY PRIMARY KEY,
	TIPO_RECLAMO_NOMBRE nvarchar(50) NOT NULL
);

CREATE TABLE NEW_MODEL.ESTADO_RECLAMO(
	ESTADO_RECLAMO_NRO int IDENTITY PRIMARY KEY,
	ESTADO_RECLAMO_NOMBRE NVARCHAR(50) NOT NULL
);

CREATE TABLE NEW_MODEL.OPERADOR(
	OPERADOR_NRO int IDENTITY PRIMARY KEY,
	OPERADOR_RECLAMO_DNI_NUMERO int UNIQUE,
	OPERADOR_RECLAMO_NOMBRE nvarchar(255) NOT NULL,
	OPERADOR_RECLAMO_APELLIDO nvarchar(255) NOT NULL,
	OPERADOR_RECLAMO_TELEFONO decimal(18,0) NOT NULL,
	OPERADOR_RECLAMO_DIRECCION nvarchar(255) NOT NULL,
	OPERADOR_RECLAMO_MAIL nvarchar(255) NOT NULL,
	OPERADOR_RECLAMO_FECHA_NAC datetime NOT NULL
);

CREATE TABLE NEW_MODEL.RECLAMO(
	RECLAMO_NRO	int IDENTITY PRIMARY KEY,
	RECLAMO_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO,
	RECLAMO_PEDIDO_NRO int REFERENCES NEW_MODEL.PEDIDO,
	RECLAMO_TIPO_RECLAMO_NRO int REFERENCES NEW_MODEL.TIPO_RECLAMO,
	RECLAMO_ESTADO_RECLAMO_NRO int REFERENCES NEW_MODEL.ESTADO_RECLAMO,
	RECLAMO_OPERADOR_NRO int REFERENCES NEW_MODEL.OPERADOR,
	RECLAMO_FECHA datetime NOT NULL,
	RECLAMO_DESCRIPCION nvarchar(255) NOT NULL,
	RECLAMO_FECHA_SOLUCION datetime NULL,
	RECLAMO_SOLUCION nvarchar(255) NULL,
	RECLAMO_CALIFICACION decimal(18, 0) NOT NULL
);

CREATE TABLE NEW_MODEL.CUPON_TIPO(
	CUPON_TIPO_NRO int IDENTITY PRIMARY KEY,
	CUPON_TIPO_NOMBRE nvarchar(50) NULL,
);


CREATE TABLE NEW_MODEL.CUPON(
	CUPON_NRO int IDENTITY PRIMARY KEY,                         
	CUPON_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO,
	CUPON_PEDIDO_NRO int REFERENCES NEW_MODEL.PEDIDO,
	CUPON_TIPO_NRO int REFERENCES NEW_MODEL.CUPON_TIPO,
	CUPON_MONTO decimal(18,2) NULL,
	CUPON_FECHA_ALTA datetime NULL,
	CUPON__FECHA_VENCIMIENTO datetime NULL
);

CREATE TABLE NEW_MODEL.CUPON_RECLAMO(
	CUPON_RECLAMO_CUPON_NRO int REFERENCES NEW_MODEL.CUPON,
	CUPON_RECLAMO_RECLAMO_NRO int REFERENCES NEW_MODEL.RECLAMO,
    PRIMARY KEY(CUPON_RECLAMO_CUPON_NRO,CUPON_RECLAMO_RECLAMO_NRO)
);

CREATE TABLE NEW_MODEL.TIPO_PAQUETE(
    TIPO_PAQUETE_NRO int IDENTITY PRIMARY KEY,
    TIPO_PAQUETE_NOMBRE  nvarchar(50) NOT NULL UNIQUE,     
    PAQUETE_ALTO_MAX decimal(18,2) NOT NULL,     
    PAQUETE_ANCHO_MAX decimal(18,2) NOT NULL,     
    PAQUETE_LARGO_MAX decimal(18,2) NOT NULL,     
    PAQUETE_PESO_MAX decimal(18,2) NOT NULL
);

CREATE TABLE NEW_MODEL.PAQUETE(
    PAQUETE_NRO int IDENTITY PRIMARY KEY,
    PAQUETE_TIPO_PAQUETE_NRO int REFERENCES NEW_MODEL.TIPO_PAQUETE,     
    TIPO_PAQUETE_PRECIO decimal(18,2) NULL
);

CREATE TABLE NEW_MODEL.MENSAJERIA_ESTADO(
    MENSAJERIA_ESTADO_NRO int IDENTITY PRIMARY KEY,
    ENVIO_MENSAJERIA_ESTADO nvarchar(50) NULL,
);


CREATE TABLE NEW_MODEL.ENVIO_MENSAJERIA(
    ENVIO_MENSAJERIA int IDENTITY PRIMARY KEY,
    ENVIO_MENSAJERIA_LOCALIDAD_NRO int REFERENCES NEW_MODEL.LOCALIDAD,
	ENVIO_MENSAJERIA_DIR_ORIG nvarchar(255) NULL,
	ENVIO_MENSAJERIA_DIR_DEST nvarchar(255) NULL,
	ENVIO_MENSAJERIA_TIEMPO_ESTIMADO decimal(18, 2) NULL,
	ENVIO_MENSAJERIA_KM decimal(18, 2) NULL,
	ENVIO_MENSAJERIA_PRECIO_ENVIO decimal(18, 2) NULL,
	ENVIO_MENSAJERIA_PROPINA decimal(18, 2) NULL,
	ENVIO_MENSAJERIA_VALOR_ASEGURADO decimal(18, 2) NULL,
	ENVIO_MENSAJERIA_PRECIO_SEGURO decimal(18, 2) NULL,
);
    
CREATE TABLE NEW_MODEL.MENSAJERIA(
    MENSAJERIA_NRO int IDENTITY PRIMARY KEY,
    MENSAJERIA_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO,
    MENSAJERIA_REPARTIDOR_NRO int REFERENCES NEW_MODEL.REPARTIDOR,
    MENSAJERIA_MEDIO_PAGO_NRO int REFERENCES NEW_MODEL.MEDIO_PAGO,
    MENSAJERIA_PAQUETE_NRO int REFERENCES NEW_MODEL.PAQUETE,
    MENSAJERIA_ENVIO int REFERENCES NEW_MODEL.ENVIO_MENSAJERIA,
    MENSAJERIA_ESTADO int REFERENCES NEW_MODEL.MENSAJERIA_ESTADO,
	MENSAJERIA_TOTAL decimal(18, 2) NULL,
	MENSAJERIA_OBSERV nvarchar(255) NULL,
    ENVIO_MENSAJERIA_FECHA datetime NULL,
	ENVIO_MENSAJERIA_FECHA_ENTREGA datetime NULL,
    ENVIO_MENSAJERIA_TIEMPO_ESTIMADO decimal(18, 2) NULL,
	ENVIO_MENSAJERIA_CALIFICACION decimal(18, 0) NULL,    
);


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'dropear_tablas')
	DROP PROCEDURE dropear_tablas
GO

CREATE PROCEDURE dropear_tablas
 AS
    BEGIN
        BEGIN TRANSACTION  
        BEGIN TRY    
            DROP TABLE NEW_MODEL.MENSAJERIA
            DROP TABLE NEW_MODEL.ENVIO_MENSAJERIA
            DROP TABLE NEW_MODEL.MENSAJERIA_ESTADO
            DROP TABLE NEW_MODEL.PAQUETE
            DROP TABLE NEW_MODEL.TIPO_PAQUETE
            DROP TABLE NEW_MODEL.CUPON_RECLAMO
            DROP TABLE NEW_MODEL.CUPON
            DROP TABLE NEW_MODEL.CUPON_TIPO
            DROP TABLE NEW_MODEL.RECLAMO
            DROP TABLE NEW_MODEL.OPERADOR
            DROP TABLE NEW_MODEL.ESTADO_RECLAMO
            DROP TABLE NEW_MODEL.TIPO_RECLAMO
            DROP TABLE NEW_MODEL.ITEM
            DROP TABLE NEW_MODEL.LOCAL_PRODUCTO
            DROP TABLE NEW_MODEL.PRODUCTO
            DROP TABLE NEW_MODEL.HORARIO
            DROP TABLE NEW_MODEL.DIA
            DROP TABLE NEW_MODEL.LOCAL
            DROP TABLE NEW_MODEL.CATEGORIA
            DROP TABLE NEW_MODEL.TIPO_LOCAL
            DROP TABLE NEW_MODEL.PEDIDO
            DROP TABLE NEW_MODEL.MEDIO_PAGO
            DROP TABLE NEW_MODEL.MEDIO_PAGO_TIPO
            DROP TABLE NEW_MODEL.PEDIDO_ESTADO
            DROP TABLE NEW_MODEL.PEDIDO_ENVIO
            DROP TABLE NEW_MODEL.DIRECCION_USUARIO
            DROP TABLE NEW_MODEL.ALTA
            DROP TABLE NEW_MODEL.REPARTIDOR
            DROP TABLE NEW_MODEL.TIPO_MOVILIDAD
            DROP TABLE NEW_MODEL.USUARIO
            DROP TABLE NEW_MODEL.LOCALIDAD
            DROP TABLE NEW_MODEL.PROVINCIA

            PRINT 'Tablas DROPEADAS correctamente.';
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            THROW 50001, 'Error al hacer DROP TABLAS',1;
        END CATCH    
    END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_PROVINCIAS')
    DROP PROCEDURE MIGRAR_PROVINCIAS
GO
CREATE PROCEDURE MIGRAR_PROVINCIAS
AS
    BEGIN
        INSERT INTO NEW_MODEL.PROVINCIA(PROVINCIA_NOMBRE)
		(SELECT DISTINCT DIRECCION_USUARIO_PROVINCIA AS PROVINCIA_NOMBRE FROM gd_esquema.Maestra WHERE DIRECCION_USUARIO_PROVINCIA IS NOT NULL
		UNION
		SELECT DISTINCT ENVIO_MENSAJERIA_PROVINCIA AS PROVINCIA_NOMBRE FROM gd_esquema.Maestra WHERE ENVIO_MENSAJERIA_PROVINCIA IS NOT NULL
		UNION
		SELECT DISTINCT LOCAL_PROVINCIA AS PROVINCIA_NOMBRE FROM gd_esquema.Maestra  WHERE LOCAL_PROVINCIA IS NOT NULL
		)
    END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'insertLocalidadedEnProvincia')
    DROP PROCEDURE insertLocalidadedEnProvincia
GO
CREATE PROCEDURE insertLocalidadedEnProvincia
    @ProvinciaNro int,
	@ProvinciaNombre nvarchar(255)
	AS
		BEGIN
			INSERT INTO NEW_MODEL.LOCALIDAD(LOCALIDAD_PRIVINCIA_NRO, LOCALIDAD_NOMBRE)
			(SELECT DISTINCT @ProvinciaNro AS LOCALIDAD_PRIVINCIA_NRO, DIRECCION_USUARIO_LOCALIDAD AS LOCALIDAD_NOMBRE FROM gd_esquema.Maestra WHERE DIRECCION_USUARIO_LOCALIDAD IS NOT NULL AND DIRECCION_USUARIO_PROVINCIA = @ProvinciaNombre
			UNION
			SELECT DISTINCT @ProvinciaNro AS LOCALIDAD_PRIVINCIA_NRO, ENVIO_MENSAJERIA_LOCALIDAD AS LOCALIDAD_NOMBRE FROM gd_esquema.Maestra WHERE ENVIO_MENSAJERIA_LOCALIDAD IS NOT NULL AND DIRECCION_USUARIO_PROVINCIA = @ProvinciaNombre
			UNION
			SELECT DISTINCT @ProvinciaNro AS LOCALIDAD_PRIVINCIA_NRO, LOCAL_LOCALIDAD AS LOCALIDAD_NOMBRE FROM gd_esquema.Maestra WHERE LOCAL_LOCALIDAD IS NOT NULL AND DIRECCION_USUARIO_PROVINCIA = @ProvinciaNombre)
		END
	GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_LOCALIDADES')
    DROP PROCEDURE MIGRAR_LOCALIDADES
GO
CREATE PROCEDURE MIGRAR_LOCALIDADES
AS
    BEGIN
        DECLARE @count INT;

        CREATE TABLE #temp_provincias(
            PROVINCIA_NRO int,
            PROVINCIA_NOMBRE nvarchar(255) 
        );

        INSERT INTO #temp_provincias 
        SELECT * FROM NEW_MODEL.PROVINCIA

        SELECT @count = COUNT(*) FROM #temp_provincias;

        WHILE @count > 0
        BEGIN
            DECLARE @ProvNro int = (SELECT TOP(1) PROVINCIA_NRO FROM #temp_provincias);
            DECLARE @ProvNombre nvarchar(255) = (SELECT TOP(1) PROVINCIA_NOMBRE FROM #temp_provincias);
            EXEC insertLocalidadedEnProvincia @ProvinciaNro = @ProvNro, @ProvinciaNombre = @ProvNombre

            DELETE TOP (1) FROM #temp_provincias
            SELECT @count = COUNT(*) FROM #temp_provincias;
        END

        DROP TABLE #temp_provincias;
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_USUARIOS')
    DROP PROCEDURE MIGRAR_USUARIOS
GO
CREATE PROCEDURE MIGRAR_USUARIOS
AS
    BEGIN
        INSERT INTO NEW_MODEL.USUARIO(USUARIO_NOMBRE, USUARIO_APELLIDO, USUARIO_DNI, USUARIO_FECHA_REGISTRO, USUARIO_TELEFONO,USUARIO_MAIL, USUARIO_FECHA_NAC)
        SELECT DISTINCT USUARIO_NOMBRE, USUARIO_APELLIDO, USUARIO_DNI, USUARIO_FECHA_REGISTRO, USUARIO_TELEFONO,USUARIO_MAIL, USUARIO_FECHA_NAC
        FROM gd_esquema.Maestra
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'obtenerTipoAPartirDeNombreMovilidad')
    DROP FUNCTION obtenerTipoAPartirDeNombreMovilidad
GO
CREATE FUNCTION obtenerTipoAPartirDeNombreMovilidad(@TipoMovilidadNombre nvarchar(50)) RETURNS int 
AS
    BEGIN
        DECLARE @TipoMOvilidadId int;
        SELECT @TipoMOvilidadId = TIPO_MOVILIDAD_NRO FROM NEW_MODEL.TIPO_MOVILIDAD WHERE TIPO_MOVILIDAD_NOMBRE = @TipoMovilidadNombre;
        RETURN @TipoMOvilidadId;

    END
GO
    
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_REPARTIDOR')
    DROP PROCEDURE insertLocalidadedEnProvincia
GO
CREATE PROCEDURE insertarTipoMovilidadEnRepartidor
	AS
		BEGIN
            INSERT INTO NEW_MODEL.REPARTIDOR(REPARTIDOR_TIPO_MOVILIDAD_NRO ,REPARTIDOR_NOMBRE , REPARTIDOR_APELLIDO ,REPARTIDOR_DNI,REPARTIDOR_TELEFONO,REPARTIDOR_DIRECION ,REPARTIDOR_EMAIL ,REPARTIDOR_FECHA_NAC)
            SELECT DISTINCT dbo.obtenerTipoAPartirDeNombreMovilidad(REPARTIDOR_TIPO_MOVILIDAD) ,REPARTIDOR_NOMBRE , REPARTIDOR_APELLIDO ,REPARTIDOR_DNI,REPARTIDOR_TELEFONO,REPARTIDOR_DIRECION ,REPARTIDOR_EMAIL ,REPARTIDOR_FECHA_NAC 
            FROM gd_esquema.Maestra
		END
	GO

-- CREATE PROCEDURE MIGRAR_DIRECCION_USUARIO AS
-- BEGIN
-- 	INSERT INTO NEW_MODEL.(DIRECCION_USUARIO_NOMBRE,DIRECCION_USUARIO_DIRECCION)
-- 	SELECT DISTINCT DIRECCION_USUARIO_NOMBRE,DIRECCION_USUARIO_DIRECCION FROM gd_esquema.Maestra
-- 	WHERE DIRECCION_USUARIO_DIRECCION IS NOT NULL
-- END
-- GO


-- CREATE PROCEDURE MIGRAR_PEDIDO_ENVIO AS
-- BEGIN
-- 	INSERT INTO NEW_MODEL.PEDIDO_ENVIO(PEDIDO_ENVIO_PRECIO, PEDIDO_ENVIO_TARIFA_SERVICIO,PEDIDO_ENVIO_PROPINA)
-- 	SELECT DISTINCT PEDIDO_PRECIO_ENVIO,PEDIDO_TARIFA_SERVICIO,PEDIDO_PROPINA FROM gd_esquema.Maestra
-- 	WHERE PEDIDO_PRECIO_ENVIO IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE MIGRAR_PEDIDO_ESTADO AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.PEDIDO_ESTADO(PEDIDO_ESTADO)
-- 	SELECT DISTINCT PEDIDO_ESTADO FROM gd_esquema.Maestra
-- 	WHERE PEDIDO_ESTADO IS NOT NULL
-- END
-- GO




-- CREATE PROCEDURE MIGRAR_MEDIO_PAGO_TIPO AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.MEDIO_PAGO_TIPO(MEDIO_PAGO_TIPO)
-- 	SELECT DISTINCT MEDIO_PAGO_TIPO FROM gd_esquema.Maestra
-- 	WHERE MEDIO_PAGO_TIPO IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE .MIGRAR_MEDIO_PAGO AS
-- BEGIN
-- 	INSERT INTO NEW_MODEL.(MEDIO_PAGO_NRO_TARJETA,MEDIO_PAGO_MARCA_TARJETA)
-- 	SELECT DISTINCT MEDIO_PAGO_NRO_TARJETA, MARCA_TARJETA FROM gd_esquema.Maestra
-- 	WHERE MEDIO_PAGO_NRO_TARJETA IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE MIGRAR_PEDIDO AS
-- BEGIN
-- 	INSERT INTO NEW_MODEL.PEDIDO(PEDIDO_NRO, PEDIDO_TOTAL_CUPONES ,PEDIDO_OBSERV ,PEDIDO_FECHA ,PEDIDO_FECHA_ENTREGA ,PEDIDO_TIEMPO_ESTIMADO_ENTREGA ,PEDIDO_CALIFICACION ,PEDIDO_TOTAL_SERVICIO ,PEDIDO_TOTAL_PRODUCTO)
-- 		SELECT DISTINCT PEDIDO_NRO,PEDIDO_TOTAL_CUPONES,PEDIDO_OBSERV,PEDIDO_FECHA,PEDIDO_FECHA_ENTREGA,PEDIDO_TIEMPO_ESTIMADO_ENTREGA,PEDIDO,PEDIDO_TOTAL_SERVICIO,PEDIDO_TOTAL_PRODUCTOS  FROM gd_esquema.Maestra
-- 		WHERE PEDIDO_NRO IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE MIGRAR_TIPO_LOCAL AS
-- BEGIN
-- 	INSERT INTO NEW_MODEL.TIPO_LOCAL(LOCAL_TIPO)
-- 	SELECT DISTINCT LOCAL_TIPO FROM gd_esquema.Maestra
-- 	WHERE LOCAL_TIPO IS NOT NULL
-- END
-- GO

-- --CATEGORIA--


-- CREATE PROCEDURE MIGRAR_LOCAL AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.LOCAL(LOCAL_DESCRIPCIO, LOCAL_DIRECCION, LOCAL_NOMBRE)
-- 	SELECT DISTINCT LOCAL_DESCRIPCION, LOCAL_DIRECCION,LOCAL_NOMBRE FROM gd_esquema.Maestra
-- 	WHERE LOCAL_DIRECCION IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE .MIGRAR_DIA AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.DIA(HORARIO_LOCAL_DIA)
-- 	SELECT DISTINCT HORARIO_LOCAL_DIA FROM gd_esquema.Maestra
-- 	WHERE HORARIO_LOCAL_DIA IS NOT NULL
-- END
-- GO




-- CREATE PROCEDURE MIGRAR_HORARIO AS
-- BEGIN
-- 	INSERT INTO NEW_MODEL.(HORARIO_APERTURA,HORARIO_CIERRE)
-- 	SELECT DISTINCT HORARIO_LOCAL_HORA_APERTURA,HORARIO_LOCAL_HORA_CIERRE FROM gd_esquema.Maestra
-- 	WHERE HORARIO_LOCAL_HORA_APERTURA IS NOT NULL
-- END
-- GO


-- CREATE PROCEDURE MIGRAR_PRODUCTO AS
-- BEGIN
-- 	INSERT INTO NEW_MODEL.PRODCUTO(PRODUCTO_CODIGO,PRODUCTO_NOMBRE,PRODUCTO_DESCRIPCION)
-- 	SELECT DISTINCT PRODUCTO_LOCAL_CODIGO PRODUCTO_LOCAL_NOMBRE, PRODUCTO_LOCAL_DESCRIPCION FROM gd_esquema.Maestra
-- 	WHERE PRODUCTO_LOCAL_CODIGO IS NOT NULL
-- END
-- GO


-- --LOCAL PRODUCTO--



-- CREATE PROCEDURE MIGRAR_ITEM AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.NEW_MODEL.ITEM(ITEM_CANTIDAD,ITEM_PRECIO)
-- 		SELECT DISTINCT PRODUCTO_CANTIDAD,PRODUCTO_LOCAL_PRECIO FROM gd_esquema.Maestra
-- 		--WHERE ?? IS NOT NULL
	
-- END
-- GO




-- CREATE PROCEDURE MIGRAR_TIPO_RECLAMO AS
-- BEGIN
-- 	SET IDENTITY_INSERT NEW_MODEL.TIPO_RECLAMO ON
-- 	INSERT INTO NEW_MODEL.NEW_MODEL.(TIPO_RECLAMO_NOMBRE)
-- 	SELECT DISTINCT RECLAMO_TIPO FROM gd_esquema.Maestra
-- 	WHERE RECLAMO_TIPO IS NOT NULL
-- END
-- GO



-- CREATE PROCEDURE MIGRAR_ESTADO_RECLAMO AS
-- BEGIN
-- 	SET IDENTITY_INSERT NEW_MODEL.ESTADO_RECLAMO ON
-- 	INSERT INTO NEW_MODEL.NEW_MODEL.(ESTADO_RECLAMO_NOMBRE)
-- 	SELECT DISTINCT RECLAMO_ESTADO FROM gd_esquema.Maestra
-- 	WHERE RECLAMO_ESTADO IS NOT NULL
-- END
-- GO


-- CREATE PROCEDURE MIGRAR_OPERADOR AS
-- BEGIN
-- 	INSERT INTO NEW_MODEL.(OPERADOR_RECLAMO_NOMBRE ,OPERADOR_RECLAMO_APELLIDO ,OPERADOR_RECLAMO_DNI_NRO ,OPERADOR_RECLAMO_TELEFONO ,OPERADOR_RECLAMO_DIRECCION ,OPERADOR_RECLAMO_MAIL ,OPERADOR_RECLAMO_FECHA_NAC)
-- 	SELECT DISTINCT OPERADOR_RECLAMO_NOMBRE ,OPERADOR_RECLAMO_APELLIDO ,OPERADOR_RECLAMO_DNI ,OPERADOR_RECLAMO_TELEFONO ,OPERADOR_RECLAMO_DIRECCION ,OPERADOR_RECLAMO_MAIL ,OPERADOR_RECLAMO_FECHA_NAC FROM gd_esquema.Maestra
-- 	WHERE OPERADOR_RECLAMO_DNI IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE MIGRAR_RECLAMO AS
-- BEGIN
-- 	INSERT INTO NEW_MODEL.NEW_MODEL.RECLAMO(RECLAMO_NRO,RECLAMO_FECHA,RECLAMO_DESCRIPCION,RECLAMO_FECHA_SOLUCION ,RECLAMO_SOLUCION,RECLAMO_CALIFICACION)
-- 	SELECT DISTINCT RECLAMO_NRO,RECLAMO_FECHA,RECLAMO_DESCRIPCION,RECLAMO_FECHA_SOLUCION ,RECLAMO_SOLUCION,RECLAMO_CALIFICACION  FROM gd_esquema.Maestra
-- 	WHERE RECLAMO_NRO IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE MIGRAR_CUPON_TIPO AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.NEW_MODEL.CUPON_TIPO()
-- 	SELECT DISTINCT FROM gd_esquema.Maestra
-- 	WHERE  IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE MIGRAR_CUPON AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.CUPON(CUPON_NRO,CUPON_MONTO,CUPON_FECHA_ALTA,CUPON_FECHA_VENCIMIENTO	)
-- 	SELECT DISTINCT CUPON_NRO,CUPON_MONTO,CUPON_FECHA_ALTA,CUPON_FECHA_VENCIMIENTO	 FROM gd_esquema.Maestra
-- 	WHERE CUPON_NRO IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE MIGRAR_TIPO_PAQUETE AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.TIPO_PAQUETE(TIPO_PAQUETE_NOMBRE,PAQUETE_ALTO_MAX,PAQUETE_ANCHO_MAX,PAQUETE_LARGO_MAX,PAQUETE_PESO_MAX)
-- 	SELECT DISTINCT PAQUETE_TIPO,PAQUETE_ALTO_MAX,PAQUETE_ANCHO_MAX,PAQUETE_LARGO_MAX,PAQUETE_PESO_MAX FROM gd_esquema.Maestra
-- 	WHERE PAQUETE_TIPO IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE MIGRAR_PAQUETE AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.PAQUETE(TIPO_PAQUETE_PRECIO)
-- 	SELECT DISTINCT PAQUETE_TIPO_PRECIO FROM gd_esquema.Maestra
-- 	WHERE PAQUETE_TIPO_PRECIO IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE MIGRAR_MENSAJERIA_ESTADO AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.MENSAJERIA_ESTADO(MENSAJERIA_ESTADO)
-- 	SELECT DISTINCT ENVIO_MENSAJERIA_ESTADO FROM gd_esquema.Maestra
-- 	WHERE ENVIO_MENSAJERIA_ESTADO IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE MIGRAR_ENVIO_MENSAJERIA AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.ENVIO_MENSAJERIA(ENVIO_MENSAJERIA_DIR_ORIGEN,ENVIO_MENSAJERIA_DIR_DEST,MENSAJERIA_TIEMPO_ESTIMADO,ENVIO_MENSAJERIA_KM,ENVIO_MENSAJERIA_PRECIO_ENVIO,ENVIO_MENSAJERIA_PROPINA)
-- 	SELECT DISTINCT ENVIO_MENSAJERIA_DIR_ORIG,ENVIO_MENSAJERIA_DIR_DEST, ENVIO_MENSAJERIA_TIEMPO_ESTIMADO, ENVIO_MENSAJERIA_KM, ENVIO_MENSAJERIA_PRECIO_ENVIO, ENVIO_MENSAJERIA_PROPINA FROM gd_esquema.Maestra
-- 	WHERE ENVIO_MENSAJERIA_TIEMPO_ESTIMADO IS NOT NULL
-- END
-- GO

-- CREATE PROCEDURE MIGRAR_MENSAJERIA AS
-- BEGIN
	
-- 	INSERT INTO NEW_MODEL.MENSAJERIA(MENSAJERIA_TOTAL,MENSAJERIA_OBSERV,MENSAJERIA_FECHA ,MENSAJERIA_FECHA_ENTREGA ,MENSAJERIA_VALOR_ASEGURADO ,MENSAJERIA_CALIFICACION,MENSAJERIA_PRECIO_SEGURO)
-- 	SELECT DISTINCT ENVIO_MENSAJERIA_TOTAL,ENVIO_MENSAJERIA_OBSERV,ENVIO_MENSAJERIA_FECHA ,ENVIO_MENSAJERIA_FECHA_ENTREGA ,ENVIO_MENSAJERIA_VALOR_ASEGURADO ,ENVIO_MENSAJERIA_CALIFICACION,ENVIO_MENSAJERIA_PRECIO_SEGURO , 
--  FROM gd_esquema.Maestra
-- 	WHERE  IS NOT NULL
-- END
-- GO