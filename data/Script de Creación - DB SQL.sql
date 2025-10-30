-- =============================ELIMINAR TABLAS=========================================
DROP TABLE IF EXISTS Gestioneros.Detalle_Compra;
DROP TABLE IF EXISTS Gestioneros.Compra;
DROP TABLE IF EXISTS Gestioneros.Proveedor;
DROP TABLE IF EXISTS Gestioneros.Detalle_Pedido;
DROP TABLE IF EXISTS Gestioneros.Madera;
DROP TABLE IF EXISTS Gestioneros.Tela;
DROP TABLE IF EXISTS Gestioneros.Relleno;
DROP TABLE IF EXISTS Gestioneros.SillonxMaterial;
DROP TABLE IF EXISTS Gestioneros.Material;
DROP TABLE IF EXISTS Gestioneros.Sillon;
DROP TABLE IF EXISTS Gestioneros.Medida;
DROP TABLE IF EXISTS Gestioneros.Modelo;
DROP TABLE IF EXISTS Gestioneros.Detalle_Factura;
DROP TABLE IF EXISTS Gestioneros.Factura;
DROP TABLE IF EXISTS Gestioneros.Envio;
DROP TABLE IF EXISTS Gestioneros.Pedido_Cancelacion;
DROP TABLE IF EXISTS Gestioneros.Pedido;
DROP TABLE IF EXISTS Gestioneros.Sucursal;
DROP TABLE IF EXISTS Gestioneros.Cliente;
DROP TABLE IF EXISTS Gestioneros.Ubicacion;

-- =============================ELIMINAR PROCEDURES=========================================

DROP PROCEDURE IF EXISTS Gestioneros.migrar_ubicacion;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_cliente;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_sucursal;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_pedido;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_cancelacion_pedido;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_envio;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_factura;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_detalle_factura;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_modelo;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_medida;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_sillon;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_material;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_sillon_x_material;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_relleno;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_tela;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_madera;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_detalle_pedido;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_proveedor;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_compra;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_detalle_compra;

-- Eliminar el esquema
DROP SCHEMA IF EXISTS Gestioneros;
GO

-- ====================================TABLAS==============================================


CREATE SCHEMA Gestioneros;
GO


CREATE TABLE Gestioneros.Ubicacion (
    ubicacion_id    INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    provincia         NVARCHAR(255) NOT NULL,
    localidad         NVARCHAR(255) NOT NULL,
    direccion         NVARCHAR(255) NOT NULL
);


CREATE TABLE Gestioneros.Cliente (
    cliente_id      INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ubicacion_id    INT NOT NULL,
    dni             bigint NOT NULL,
    nombre          NVARCHAR(255) NOT NULL,
    apellido        NVARCHAR(255) NOT NULL,
    fechaNacimiento       DATETIME2(6) NOT NULL,
    mail            NVARCHAR(255) NOT NULL,
    telefono        NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_Cliente_Ubicacion FOREIGN KEY (ubicacion_id) REFERENCES Gestioneros.Ubicacion(ubicacion_id)
);



CREATE TABLE Gestioneros.Sucursal (
    nro_sucursal    BIGINT PRIMARY KEY NOT NULL,
    ubicacion_id       INT NOT NULL,
    telefono        NVARCHAR(255) NOT NULL,
    mail            NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_Sucursal_Ubicacion FOREIGN KEY (ubicacion_id) REFERENCES Gestioneros.Ubicacion(ubicacion_id)
);




CREATE TABLE Gestioneros.Pedido (
    nro_pedido      INT PRIMARY KEY NOT NULL,
    nro_sucursal     BIGINT NOT NULL,
    cliente_id      INT NOT NULL,
    fecha   DATETIME2(6) NOT NULL,
    estado          NVARCHAR(50) NOT NULL,
    total       DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_Pedido_Sucursal FOREIGN KEY (nro_sucursal) REFERENCES Gestioneros.Sucursal(nro_sucursal),
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (cliente_id) REFERENCES Gestioneros.Cliente(cliente_id)
);


 CREATE TABLE Gestioneros.Modelo (
     cod_modelo   BIGINT PRIMARY KEY NOT NULL,
    descripcion  NVARCHAR(255),
     precio       DECIMAL(18,2) NOT NULL,
 );


CREATE TABLE Gestioneros.Medida (
    cod_medida   BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    alto                DECIMAL(18,2) NOT NULL,
    ancho               DECIMAL(18,2) NOT NULL,
    profundidad         DECIMAL(18,2) NOT NULL,
    precio              DECIMAL(18,2) NOT NULL,
);



CREATE TABLE Gestioneros.Sillon (
    cod_sillon   BIGINT PRIMARY KEY NOT NULL,
    cod_medida   BIGINT NOT NULL,
    cod_modelo   BIGINT NOT NULL,
    modelo       NVARCHAR(255),
    CONSTRAINT FK_Sillon_Modelo FOREIGN KEY (cod_modelo) REFERENCES Gestioneros.Modelo(cod_modelo),
    CONSTRAINT FK_Sillon_Medida FOREIGN KEY (cod_medida) REFERENCES Gestioneros.Medida(cod_medida)

);

CREATE TABLE Gestioneros.Material (
    nro_material   INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    tipo           NVARCHAR(255) NOT NULL,
    nombre         NVARCHAR(255) NOT NULL,
    descripcion    NVARCHAR(255) NOT NULL,
    precio         DECIMAL(38,2) NOT NULL
);



CREATE TABLE Gestioneros.SillonxMaterial (
    sillon_id    BIGINT NOT NULL,
    material_id  INT NOT NULL,
    CONSTRAINT PK_SillonxMaterial PRIMARY KEY (sillon_id, material_id),
    CONSTRAINT FK_SillonxMaterial_Sillon FOREIGN KEY (sillon_id) REFERENCES Gestioneros.Sillon(cod_sillon),
    CONSTRAINT FK_SillonxMaterial_Material FOREIGN KEY (material_id) REFERENCES Gestioneros.Material(nro_material)
);




CREATE TABLE Gestioneros.Relleno (
    nro_relleno   INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nro_material  INT NOT NULL,
    densidad       DECIMAL(38,2) NOT NULL,
    CONSTRAINT FK_relleno_material FOREIGN KEY (nro_material) REFERENCES Gestioneros.Material(nro_material)
);




CREATE TABLE Gestioneros.Tela (
    nro_tela   INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nro_material    INT NOT NULL,
    color          NVARCHAR(255) NOT NULL,
    textura        NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_tela_material FOREIGN KEY (nro_material) REFERENCES Gestioneros.Material(nro_material)
);


CREATE TABLE Gestioneros.Madera (
    nro_madera   INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nro_material    INT NOT NULL,
    color          NVARCHAR(255) NOT NULL,
    dureza         NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_madera_material FOREIGN KEY (nro_material) REFERENCES Gestioneros.Material(nro_material)
);



CREATE TABLE Gestioneros.Detalle_Pedido (
    nro_detalle_pedido INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    pedido_id     INT NOT NULL,
    sillon_id     BIGINT NOT NULL,
    cantidad      BIGINT NOT NULL,
    precio        DECIMAL(18, 2) NOT NULL,
    subtotal      DECIMAL(18, 2) NOT NULL,
    CONSTRAINT FK_DetallePedido_Pedido FOREIGN KEY (pedido_id) REFERENCES Gestioneros.Pedido(nro_pedido),
    CONSTRAINT FK_DetallePedido_Sillon FOREIGN KEY (sillon_id) REFERENCES Gestioneros.Sillon(cod_sillon)
);



CREATE TABLE Gestioneros.Pedido_Cancelacion (
    nro_pedido      INT PRIMARY KEY,
    nro_sucursal     BIGINT,
    cliente_id      INT,
    fecha           DATETIME2(6),
    motivo          NVARCHAR(255),
    CONSTRAINT FK_PedidoCancelacion_Pedido FOREIGN KEY (nro_pedido) REFERENCES Gestioneros.Pedido(nro_pedido),
    CONSTRAINT FK_PedidoCancelacion_Sucursal FOREIGN KEY (nro_sucursal) REFERENCES Gestioneros.Sucursal(nro_sucursal),
    CONSTRAINT FK_PedidoCancelacion_Cliente FOREIGN KEY (cliente_id) REFERENCES Gestioneros.Cliente(cliente_id)
);



CREATE TABLE Gestioneros.Envio (
    numero             DECIMAL(18,0) PRIMARY KEY NOT NULL,
    fecha_programada   DATETIME2(6) NOT NULL,
    fecha              DATETIME2(6) NOT NULL,
    importe_traslado    DECIMAL(18,2) NOT NULL,
    importe_subida  DECIMAL(18,2) NOT NULL,
    envio_total        DECIMAL
);





CREATE TABLE Gestioneros.Factura (
    nro_factura   BIGINT PRIMARY KEY NOT NULL,
    nro_sucursal  BIGINT NOT NULL,
    cliente_id    INT NOT NULL,
    envio_id       DECIMAL(18,0) NOT NULL,
    fecha         DATETIME2(6) NOT NULL,
    total         DECIMAL(38,2) NOT NULL,
    CONSTRAINT FK_Factura_Sucursal FOREIGN KEY (nro_sucursal) REFERENCES Gestioneros.Sucursal(nro_sucursal),
    CONSTRAINT FK_Factura_Cliente FOREIGN KEY (cliente_id) REFERENCES Gestioneros.Cliente(cliente_id),
    CONSTRAINT FK_Factura_Envio FOREIGN KEY (envio_id) REFERENCES Gestioneros.Envio(numero)
);


CREATE TABLE Gestioneros.Detalle_Factura (
    nro_detalle_factura INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nro_factura         BIGINT NOT NULL,
    nro_detalle_pedido  INT NOT NULL,
    cantidad            DECIMAL(18,0) NOT NULL,
    precio              DECIMAL(18,2) NOT NULL,
    subtotal            DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_DetalleFactura_Factura FOREIGN KEY (nro_factura) REFERENCES Gestioneros.Factura(nro_factura),
    CONSTRAINT FK_DetalleFactura_DetallePedido FOREIGN KEY (nro_detalle_pedido) REFERENCES Gestioneros.Detalle_Pedido(nro_detalle_pedido)
);






CREATE TABLE Gestioneros.Proveedor (
    id_Proveedor   INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ubicacion_id   INT NOT NULL,
    razon_Social   NVARCHAR(255) NOT NULL,
    CUIT           NVARCHAR(255) NOT NULL,
    telefono       NVARCHAR(255) NOT NULL,
    email          NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_Proveedor_Ubicaion FOREIGN KEY (ubicacion_id) REFERENCES Gestioneros.Ubicacion(ubicacion_id)
);




CREATE TABLE Gestioneros.Compra (
    nro_compra   DECIMAL(18,0) PRIMARY KEY NOT NULL,
    nro_sucursal BIGINT NOT NULL,
    fecha        DATETIME2(6) NOT NULL,
    total        DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_Compra_Sucursal FOREIGN KEY (nro_sucursal) REFERENCES Gestioneros.Sucursal(nro_sucursal)
);




CREATE TABLE Gestioneros.Detalle_Compra (
    nro_detalle_compra INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nro_compra    DECIMAL(18,0) NOT NULL,
    nro_material  INT NOT NULL,
    precio        DECIMAL(18,2) NOT NULL,
    cantidad      DECIMAL(18,0) NOT NULL,
    subtotal      DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_DetalleCompra_Compra FOREIGN KEY (nro_compra) REFERENCES Gestioneros.Compra(nro_compra),
    CONSTRAINT FK_DetalleCompra_Material FOREIGN KEY (nro_material) REFERENCES Gestioneros.material(nro_material)
);
GO




-- ====================================PROCEDURES==============================================




CREATE PROCEDURE Gestioneros.migrar_ubicacion
AS
BEGIN
     INSERT INTO Gestioneros.Ubicacion(provincia, localidad, direccion)
        SELECT DISTINCT nombre_provincia, nombre_localidad, nombre_direccion
        FROM (
            SELECT
                Sucursal_localidad AS nombre_localidad,
                Sucursal_provincia AS nombre_provincia,
                Sucursal_Direccion AS nombre_direccion
            FROM gd_esquema.Maestra
            UNION
            SELECT
                Cliente_localidad,
                Cliente_provincia,
                Cliente_Direccion
            FROM gd_esquema.Maestra
            UNION
            SELECT
                Proveedor_localidad,
                Proveedor_provincia,
                Proveedor_Direccion
            FROM gd_esquema.Maestra
        ) AS U
        WHERE U.nombre_localidad IS NOT NULL AND U.nombre_provincia IS NOT NULL AND U.nombre_direccion IS NOT NULL
        AND NOT EXISTS (
            SELECT 1 FROM Gestioneros.Ubicacion ubi WHERE ubi.localidad = U.nombre_localidad
            AND ubi.provincia = U.nombre_provincia AND ubi.direccion = U.nombre_direccion
        );
    END
   GO





CREATE PROCEDURE Gestioneros.migrar_cliente
AS
BEGIN
    INSERT INTO Gestioneros.Cliente (ubicacion_id, dni, nombre, apellido, fechaNacimiento, mail, telefono)
    SELECT DISTINCT
        U.ubicacion_id,
        M.CLIENTE_DNI,
        M.CLIENTE_NOMBRE,
        M.CLIENTE_APELLIDO,
        M.CLIENTE_FECHANACIMIENTO,
        M.CLIENTE_MAIL,
        M.CLIENTE_TELEFONO
    FROM gd_esquema.Maestra M
    JOIN Gestioneros.Ubicacion U 
        ON M.Cliente_Direccion = U.direccion
        AND M.Cliente_Localidad = U.localidad
        AND M.Cliente_Provincia = U.provincia
    WHERE M.CLIENTE_DNI IS NOT NULL
      AND M.CLIENTE_NOMBRE IS NOT NULL;
END;
GO




CREATE PROCEDURE Gestioneros.migrar_sucursal
AS
BEGIN  
    WITH SucursalesUnicas AS (
        SELECT
            M.SUCURSAL_NROSUCURSAL,
            U.ubicacion_id,
            M.SUCURSAL_TELEFONO,
            M.SUCURSAL_MAIL,
            ROW_NUMBER() OVER (
                PARTITION BY M.SUCURSAL_NROSUCURSAL
                ORDER BY M.SUCURSAL_DIRECCION
            ) AS rn
        FROM gd_esquema.Maestra M
        JOIN Gestioneros.Ubicacion U
            ON M.SUCURSAL_LOCALIDAD = U.localidad
            AND M.SUCURSAL_PROVINCIA = U.provincia
            AND M.SUCURSAL_DIRECCION = U.direccion
        WHERE M.SUCURSAL_NROSUCURSAL IS NOT NULL
    )
    INSERT INTO Gestioneros.Sucursal(nro_sucursal, ubicacion_id, telefono, mail)
    SELECT
        SUCURSAL_NROSUCURSAL,
        ubicacion_id,
        SUCURSAL_TELEFONO,
        SUCURSAL_MAIL
    FROM SucursalesUnicas
    WHERE rn = 1
    AND NOT EXISTS (
        SELECT 1
        FROM Gestioneros.Sucursal S
        WHERE S.nro_sucursal = SucursalesUnicas.SUCURSAL_NROSUCURSAL
    );
END;
GO



CREATE PROCEDURE Gestioneros.migrar_pedido
AS
BEGIN
    WITH PedidosUnicos AS (
        SELECT
            M.PEDIDO_NUMERO,
            S.nro_sucursal,
            C.cliente_id,
            M.PEDIDO_FECHA,
            M.PEDIDO_ESTADO,
            M.PEDIDO_TOTAL,
            ROW_NUMBER() OVER (
                PARTITION BY M.PEDIDO_NUMERO
                ORDER BY M.PEDIDO_FECHA
            ) AS rn
        FROM gd_esquema.Maestra M
        JOIN Gestioneros.Cliente C
            ON M.CLIENTE_DNI = C.dni
        JOIN Gestioneros.Sucursal S
            ON M.SUCURSAL_NROSUCURSAL = S.nro_sucursal
        WHERE M.CLIENTE_DNI IS NOT NULL
            AND M.PEDIDO_NUMERO IS NOT NULL
            AND M.PEDIDO_FECHA IS NOT NULL
            AND M.PEDIDO_ESTADO IS NOT NULL
            AND M.PEDIDO_TOTAL IS NOT NULL
    )
    INSERT INTO Gestioneros.Pedido(nro_pedido, nro_sucursal, cliente_id, fecha, estado, total)
    SELECT
        PEDIDO_NUMERO,
        nro_sucursal,
        cliente_id,
        PEDIDO_FECHA,
        PEDIDO_ESTADO,
        PEDIDO_TOTAL
    FROM PedidosUnicos
    WHERE rn = 1
    AND NOT EXISTS (
        SELECT 1
        FROM Gestioneros.Pedido P
        WHERE P.nro_pedido = PedidosUnicos.PEDIDO_NUMERO
    );
END;
GO



CREATE PROCEDURE Gestioneros.migrar_modelo
AS
BEGIN
INSERT INTO Gestioneros.Modelo(cod_modelo, descripcion, precio)
    SELECT DISTINCT
        SILLON_MODELO_CODIGO,
        SILLON_MODELO_DESCRIPCION,
        SILLON_MODELO_PRECIO
    FROM gd_esquema.Maestra
    WHERE SILLON_MODELO_CODIGO IS NOT NULL;
END;
GO


CREATE PROCEDURE Gestioneros.migrar_medida
AS
BEGIN  
    INSERT INTO Gestioneros.Medida(alto, ancho, profundidad, precio)
    SELECT DISTINCT
        M.SILLON_MEDIDA_ALTO,
        M.SILLON_MEDIDA_ANCHO,
        M.SILLON_MEDIDA_PROFUNDIDAD,
        M.SILLON_MEDIDA_PRECIO
    FROM gd_esquema.Maestra M
    WHERE M.SILLON_MEDIDA_ALTO IS NOT NULL
        AND M.SILLON_MEDIDA_ANCHO IS NOT NULL
        AND M.SILLON_MEDIDA_PROFUNDIDAD IS NOT NULL
        AND M.SILLON_MEDIDA_PRECIO IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM Gestioneros.Medida ME
            WHERE ME.alto = M.SILLON_MEDIDA_ALTO
              AND ME.ancho = M.SILLON_MEDIDA_ANCHO
              AND ME.profundidad = M.SILLON_MEDIDA_PROFUNDIDAD
              AND ME.precio = M.SILLON_MEDIDA_PRECIO
        );
END;
GO



CREATE PROCEDURE Gestioneros.migrar_sillon
AS
BEGIN
    WITH SillonesUnicos AS (
        SELECT
            M.SILLON_CODIGO AS cod_sillon,
            MO.cod_modelo,
            M.SILLON_MODELO AS modelo,
            M.SILLON_MEDIDA_ALTO AS alto,
            M.SILLON_MEDIDA_ANCHO AS ancho,
            M.SILLON_MEDIDA_PROFUNDIDAD AS profundidad,
            M.SILLON_MEDIDA_PRECIO AS precio,
            ROW_NUMBER() OVER (
                PARTITION BY M.SILLON_CODIGO
                ORDER BY M.SILLON_CODIGO
            ) AS rn
        FROM gd_esquema.Maestra M
        JOIN Gestioneros.Modelo MO
            ON M.SILLON_MODELO_CODIGO = MO.cod_modelo
        WHERE M.SILLON_CODIGO IS NOT NULL
    )
    INSERT INTO Gestioneros.Sillon (cod_sillon, cod_medida, cod_modelo, modelo)
    SELECT
        SU.cod_sillon,
        ME.cod_medida,
        SU.cod_modelo,
        SU.modelo
    FROM SillonesUnicos SU
    JOIN Gestioneros.Medida ME
        ON SU.alto = ME.alto
        AND SU.ancho = ME.ancho
        AND SU.profundidad = ME.profundidad
        AND SU.precio = ME.precio
    WHERE SU.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM Gestioneros.Sillon S
          WHERE S.cod_sillon = SU.cod_sillon
      );
END;
GO




CREATE PROCEDURE Gestioneros.migrar_material
AS
BEGIN
INSERT INTO Gestioneros.Material(tipo, nombre, descripcion, precio)
    SELECT DISTINCT
        MATERIAL_TIPO,
        MATERIAL_NOMBRE,
        MATERIAL_DESCRIPCION,
        MATERIAL_PRECIO
    FROM gd_esquema.Maestra
    WHERE MATERIAL_NOMBRE IS NOT NULL;
END;
GO




CREATE PROCEDURE Gestioneros.migrar_sillon_x_material
AS
BEGIN
    INSERT INTO Gestioneros.SillonxMaterial(sillon_id, material_id)
    SELECT DISTINCT
        S.cod_sillon,
        MAT.nro_material
    FROM gd_esquema.Maestra M
    JOIN Gestioneros.Sillon S
        ON M.SILLON_CODIGO = S.cod_sillon
    JOIN Gestioneros.Material MAT
        ON M.MATERIAL_NOMBRE = MAT.nombre
            AND M.MATERIAL_TIPO = MAT.tipo
            AND M.MATERIAL_DESCRIPCION = MAT.descripcion
    WHERE M.SILLON_CODIGO IS NOT NULL
        AND M.MATERIAL_NOMBRE IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM Gestioneros.SillonxMaterial SM
            WHERE SM.sillon_id = S.cod_sillon
                AND SM.material_id = MAT.nro_material
         );
END;
GO

CREATE PROCEDURE Gestioneros.migrar_relleno
AS
BEGIN
    INSERT INTO Gestioneros.Relleno(nro_material, densidad)
    SELECT DISTINCT
        MAT.nro_material,
        RELLENO_DENSIDAD
    FROM gd_esquema.Maestra M
    JOIN Gestioneros.Material MAT
        ON M.MATERIAL_NOMBRE = MAT.nombre
    WHERE RELLENO_DENSIDAD IS NOT NULL;
END;
GO

CREATE PROCEDURE Gestioneros.migrar_tela
AS
BEGIN
    INSERT INTO Gestioneros.Tela(nro_material, color, textura)
        SELECT DISTINCT
            MAT.nro_material,
            TELA_COLOR,
            TELA_TEXTURA
        FROM gd_esquema.Maestra M
        JOIN Gestioneros.Material MAT
            ON M.MATERIAL_NOMBRE = MAT.nombre
        WHERE TELA_COLOR IS NOT NULL;
END;
GO

CREATE PROCEDURE Gestioneros.migrar_madera
AS
BEGIN
    INSERT INTO Gestioneros.Madera(nro_material, color, dureza)
        SELECT DISTINCT
            MAT.nro_material,
            MADERA_COLOR,
            MADERA_DUREZA
        FROM gd_esquema.Maestra M
        JOIN Gestioneros.Material MAT
            ON M.MATERIAL_NOMBRE = MAT.nombre
        WHERE MADERA_COLOR IS NOT NULL
END;
GO



CREATE PROCEDURE Gestioneros.migrar_detalle_pedido
AS
BEGIN  
    INSERT INTO Gestioneros.Detalle_Pedido (
        pedido_id,
        sillon_id,
        cantidad,
        precio,
        subtotal
    )
    SELECT DISTINCT
        P.nro_pedido,
        S.cod_sillon,
        M.DETALLE_PEDIDO_CANTIDAD,
        M.DETALLE_PEDIDO_PRECIO,
        M.DETALLE_PEDIDO_SUBTOTAL
    FROM gd_esquema.Maestra M 
    JOIN Gestioneros.Pedido P 
        ON M.PEDIDO_NUMERO = P.nro_pedido
    JOIN Gestioneros.Sillon S
        ON M.SILLON_CODIGO = S.cod_sillon
    WHERE 
        M.PEDIDO_NUMERO IS NOT NULL
        AND M.SILLON_CODIGO IS NOT NULL
        AND M.DETALLE_PEDIDO_CANTIDAD IS NOT NULL
        AND M.DETALLE_PEDIDO_PRECIO IS NOT NULL
        AND M.DETALLE_PEDIDO_SUBTOTAL IS NOT NULL
        AND NOT EXISTS (
            SELECT 1 FROM Gestioneros.Detalle_Pedido DP
            WHERE DP.pedido_id = P.nro_pedido
              AND DP.sillon_id = S.cod_sillon
              AND DP.cantidad = M.DETALLE_PEDIDO_CANTIDAD
              AND DP.precio = M.DETALLE_PEDIDO_PRECIO
              AND DP.subtotal = M.DETALLE_PEDIDO_SUBTOTAL
        );
END;
GO




CREATE PROCEDURE Gestioneros.migrar_cancelacion_pedido
AS
BEGIN  
    WITH CancelacionesUnicas AS (
        SELECT
            P.nro_pedido,
            S.nro_sucursal,
            C.cliente_id,
            M.PEDIDO_CANCELACION_FECHA AS fecha,
            M.PEDIDO_CANCELACION_MOTIVO AS motivo,
            ROW_NUMBER() OVER (
                PARTITION BY M.PEDIDO_NUMERO
                ORDER BY M.PEDIDO_CANCELACION_FECHA
            ) AS rn
        FROM gd_esquema.Maestra M
        JOIN Gestioneros.Pedido P
            ON M.PEDIDO_NUMERO = P.nro_pedido
        JOIN Gestioneros.Sucursal S
            ON M.SUCURSAL_NROSUCURSAL = S.nro_sucursal
        JOIN Gestioneros.Cliente C
            ON M.CLIENTE_DNI = C.dni
        WHERE M.PEDIDO_CANCELACION_FECHA IS NOT NULL
          AND M.PEDIDO_CANCELACION_MOTIVO IS NOT NULL
    )
    INSERT INTO Gestioneros.Pedido_Cancelacion(nro_pedido, nro_sucursal, cliente_id, fecha, motivo)
    SELECT
        nro_pedido,
        nro_sucursal,
        cliente_id,
        fecha,
        motivo
    FROM CancelacionesUnicas
    WHERE rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM Gestioneros.Pedido_Cancelacion PC
          WHERE PC.nro_pedido = CancelacionesUnicas.nro_pedido
      );
END;
GO


CREATE PROCEDURE Gestioneros.migrar_envio
AS
BEGIN  
    INSERT INTO Gestioneros.Envio(numero, fecha_programada, fecha, importe_traslado,importe_subida,envio_total)
    SELECT DISTINCT
        ENVIO_NUMERO,
        ENVIO_FECHA_PROGRAMADA,
        ENVIO_FECHA,
        ENVIO_IMPORTETRASLADO,
        ENVIO_IMPORTESUBIDA,
        ENVIO_TOTAL
    FROM gd_esquema.Maestra M
    WHERE ENVIO_NUMERO IS NOT NULL;
END;
GO


CREATE PROCEDURE Gestioneros.migrar_factura
AS
BEGIN
    WITH FacturasUnicas AS (
        SELECT
            M.FACTURA_NUMERO,
            S.nro_sucursal,
            C.cliente_id,
            E.numero AS envio_id,
            M.FACTURA_FECHA,
            M.FACTURA_TOTAL,
            ROW_NUMBER() OVER (
                PARTITION BY M.FACTURA_NUMERO
                ORDER BY M.FACTURA_FECHA
            ) AS rn
        FROM gd_esquema.Maestra M
        JOIN Gestioneros.Sucursal S
            ON M.SUCURSAL_NROSUCURSAL = S.nro_sucursal
        JOIN Gestioneros.Cliente C
            ON M.CLIENTE_DNI = C.dni
        JOIN Gestioneros.Envio E
            ON M.ENVIO_NUMERO = E.numero
    )
    INSERT INTO Gestioneros.Factura(nro_factura, nro_sucursal, cliente_id, envio_id, fecha, total)
    SELECT
        FACTURA_NUMERO,
        nro_sucursal,
        cliente_id,
        envio_id,
        FACTURA_FECHA,
        FACTURA_TOTAL
    FROM FacturasUnicas
    WHERE rn = 1
    AND NOT EXISTS (
        SELECT 1
        FROM Gestioneros.Factura F
        WHERE F.nro_factura = FacturasUnicas.FACTURA_NUMERO
    );
END;
GO



CREATE PROCEDURE Gestioneros.migrar_detalle_factura
AS
BEGIN
    INSERT INTO Gestioneros.Detalle_Factura(nro_detalle_pedido, nro_factura, cantidad, precio, subtotal)
    SELECT
        DP.nro_detalle_pedido,
        F.nro_factura,
        M.DETALLE_FACTURA_CANTIDAD,
        M.DETALLE_FACTURA_PRECIO,
        M.DETALLE_FACTURA_SUBTOTAL
    FROM gd_esquema.Maestra M
    JOIN Gestioneros.Factura F
        ON M.FACTURA_NUMERO = F.nro_factura
    OUTER APPLY (
        SELECT TOP 1 DP.nro_detalle_pedido
        FROM Gestioneros.Detalle_Pedido DP
        WHERE DP.pedido_id = M.PEDIDO_NUMERO
          AND DP.cantidad = M.DETALLE_PEDIDO_CANTIDAD
          AND DP.precio = M.DETALLE_PEDIDO_PRECIO
          AND DP.subtotal = M.DETALLE_PEDIDO_SUBTOTAL
    ) AS DP
    WHERE M.DETALLE_FACTURA_CANTIDAD IS NOT NULL
      AND M.DETALLE_FACTURA_PRECIO IS NOT NULL;
END;
GO




CREATE PROCEDURE Gestioneros.migrar_proveedor
AS
BEGIN
    INSERT INTO Gestioneros.Proveedor (ubicacion_id, razon_Social, CUIT, telefono, email)
    SELECT DISTINCT
        U.ubicacion_id,
        M.PROVEEDOR_RAZONSOCIAL,
        M.PROVEEDOR_CUIT,
        M.PROVEEDOR_TELEFONO,
        M.PROVEEDOR_MAIL
    FROM gd_esquema.Maestra M
    JOIN Gestioneros.Ubicacion U
        ON M.PROVEEDOR_LOCALIDAD = U.localidad
        AND M.PROVEEDOR_PROVINCIA = U.provincia
        AND M.PROVEEDOR_DIRECCION = U.direccion
    WHERE M.PROVEEDOR_CUIT IS NOT NULL;
END;
GO



CREATE PROCEDURE Gestioneros.migrar_compra
AS
BEGIN
    INSERT INTO Gestioneros.Compra (nro_compra, nro_sucursal, fecha, total)
    SELECT DISTINCT
        COMPRA_NUMERO,
        S.nro_sucursal,
        COMPRA_FECHA,
        COMPRA_TOTAL
    FROM gd_esquema.Maestra M
    JOIN Gestioneros.Sucursal S
      ON M.SUCURSAL_NROSUCURSAL = S.nro_sucursal
    WHERE COMPRA_NUMERO IS NOT NULL;
END;
GO




CREATE PROCEDURE Gestioneros.migrar_detalle_compra
AS
BEGIN
    INSERT INTO Gestioneros.Detalle_Compra (nro_compra, nro_material, precio, cantidad, subtotal)
    SELECT DISTINCT
        C.nro_compra,
        MAT.nro_material,
        DETALLE_COMPRA_PRECIO,
        DETALLE_COMPRA_CANTIDAD,
        DETALLE_COMPRA_SUBTOTAL
       
    FROM gd_esquema.Maestra M
    JOIN Gestioneros.Material MAT
      ON M.MATERIAL_NOMBRE = MAT.nombre
        AND M.MATERIAL_TIPO = MAT.tipo
        AND M.MATERIAL_DESCRIPCION = MAT.descripcion
    JOIN Gestioneros.Compra C
        ON M.COMPRA_NUMERO = C.nro_compra
    WHERE COMPRA_NUMERO IS NOT NULL;
END;
GO



     
-- ===========================================================EJECUCION PROCEDIMIENTO=====================================
EXEC Gestioneros.migrar_ubicacion;
EXEC Gestioneros.migrar_cliente;
EXEC Gestioneros.migrar_sucursal;
EXEC Gestioneros.migrar_pedido;
EXEC Gestioneros.migrar_modelo;
EXEC Gestioneros.migrar_medida;
EXEC Gestioneros.migrar_sillon;
EXEC Gestioneros.migrar_material;
EXEC Gestioneros.migrar_sillon_x_material;
EXEC Gestioneros.migrar_relleno;
EXEC Gestioneros.migrar_tela;
EXEC Gestioneros.migrar_madera;
EXEC Gestioneros.migrar_detalle_pedido;
EXEC Gestioneros.migrar_cancelacion_pedido;
EXEC Gestioneros.migrar_envio;
EXEC Gestioneros.migrar_factura;
EXEC Gestioneros.migrar_detalle_factura;
EXEC Gestioneros.migrar_proveedor;
EXEC Gestioneros.migrar_compra;
EXEC Gestioneros.migrar_detalle_compra;

