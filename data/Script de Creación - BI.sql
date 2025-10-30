
-- ====================
-- Eliminación del BI
-- ====================


-- Eliminar vistas 
DROP VIEW IF EXISTS Gestioneros.V_Ganancias_Mensuales_Sucursal;
DROP VIEW IF EXISTS Gestioneros.V_Factura_Promedio_Provincia;
DROP VIEW IF EXISTS Gestioneros.V_Top3_Modelos_Vendidos;
DROP VIEW IF EXISTS Gestioneros.V_Volumen_Pedidos;
DROP VIEW IF EXISTS Gestioneros.V_Conversion_Pedidos;
DROP VIEW IF EXISTS Gestioneros.V_Tiempo_Promedio_Fabricacion;
DROP VIEW IF EXISTS Gestioneros.V_Promedio_Compras_Mensual;
DROP VIEW IF EXISTS Gestioneros.V_Compras_Por_Tipo_Material;
DROP VIEW IF EXISTS Gestioneros.V_Cumplimiento_Envios;
DROP VIEW IF EXISTS Gestioneros.V_Top3_Localidades_Costo_Envio;

-- Eliminar tablas de hechos
DROP TABLE IF EXISTS Gestioneros.H_Envios;
DROP TABLE IF EXISTS Gestioneros.H_Pedidos;
DROP TABLE IF EXISTS Gestioneros.H_Compras;
DROP TABLE IF EXISTS Gestioneros.H_Facturacion;

-- Eliminar tablas de dimensiones 
DROP TABLE IF EXISTS Gestioneros.D_Cliente;
DROP TABLE IF EXISTS Gestioneros.D_Sucursal;
DROP TABLE IF EXISTS Gestioneros.D_Modelo_Sillon;
DROP TABLE IF EXISTS Gestioneros.D_Tipo_Material;
DROP TABLE IF EXISTS Gestioneros.D_Estado_Pedido;
DROP TABLE IF EXISTS Gestioneros.D_Turno_Ventas;
DROP TABLE IF EXISTS Gestioneros.D_Rango_Etario;
DROP TABLE IF EXISTS Gestioneros.D_Ubicacion;
DROP TABLE IF EXISTS Gestioneros.D_Tiempo;

-- Eliminar procedimientos de migración
DROP PROCEDURE IF EXISTS Gestioneros.migrar_H_Envios;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_H_Pedidos;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_H_Compras;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_H_Facturacion;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_D_Cliente;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_D_Sucursal;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_D_Modelo_Sillon;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_D_Tipo_Material;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_D_Estado_Pedido;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_D_Turno_Ventas;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_D_Rango_Etario;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_D_Ubicacion;
DROP PROCEDURE IF EXISTS Gestioneros.migrar_D_Tiempo;



-- ======================================================
-- Creación de Tablas de Dimensión (Dimension Tables)
-- ======================================================


-- Tabla de Dimensión: Tiempo
CREATE TABLE GESTIONEROS.D_Tiempo (
    Tiempo_Id INT PRIMARY KEY,
    tiempo_cuatrimestre DATETIME,
    tiempo_mes DATETIME,
    tiempo_anio DATETIME
);




-- Tabla de Dimensión: Ubicación
CREATE TABLE GESTIONEROS.D_Ubicacion (
    Ubicacion_Id INT IDENTITY(1,1) PRIMARY KEY,
    Provincia NVARCHAR(255),
    Localidad NVARCHAR(255),
    direccion NVARCHAR(255)
);




-- Tabla de Dimensión: Rango Etario
CREATE TABLE GESTIONEROS.D_Rango_Etario (
    Rango_Etario_Id INT IDENTITY(1,1) PRIMARY KEY,
    Rango_Etario_Detalle NVARCHAR(50)
);




-- Tabla de Dimensión: Turno Ventas
CREATE TABLE GESTIONEROS.D_Turno_Ventas (
    Turno_Id INT IDENTITY(1,1) PRIMARY KEY,
    Turno_Detalle NVARCHAR(50)
);




-- Tabla de Dimensión: Tipo Material
CREATE TABLE GESTIONEROS.D_Tipo_Material (
    Tipo_Material_Id INT IDENTITY(1,1) PRIMARY KEY,
    Tipo_Materal_Nombre NVARCHAR(255),
    Tipo_Material_Detalle NVARCHAR(255),
    Precio_Material DECIMAL(38,2)
);




-- Tabla de Dimensión: Modelo Sillón
CREATE TABLE GESTIONEROS.D_Modelo_Sillon (
    Modelo_Sillon_Id BIGINT PRIMARY KEY,
    Modelo_Descripcion NVARCHAR(255)
);




-- Tabla de Dimensión: Estado Pedido
CREATE TABLE GESTIONEROS.D_Estado_Pedido (
    Estado_Pedido_Id INT IDENTITY(1,1) PRIMARY KEY,
    Estado_Pedido_Detalle NVARCHAR(50)
);




-- Tabla de Dimensión: Sucursal
CREATE TABLE GESTIONEROS.D_Sucursal (
    nro_sucursal BIGINT PRIMARY KEY,
    Ubicacion_Id INT,
    mail NVARCHAR(255),
    telefono NVARCHAR(255),
    FOREIGN KEY (Ubicacion_Id) REFERENCES GESTIONEROS.D_Ubicacion(Ubicacion_Id)
);




-- Tabla de Dimensión: Cliente
CREATE TABLE GESTIONEROS.D_Cliente (
    Cliente_Id INT PRIMARY KEY,
    Rango_Etario_Id INT,
    Ubicacion_Id INT,
    FOREIGN KEY (Rango_Etario_Id) REFERENCES GESTIONEROS.D_Rango_Etario(Rango_Etario_Id),
    FOREIGN KEY (Ubicacion_Id) REFERENCES GESTIONEROS.D_Ubicacion(Ubicacion_Id)
);








-- ==============================================
-- Creación de Tablas de Hechos (Fact Tables)
-- ==============================================




CREATE TABLE GESTIONEROS.H_Facturacion (
    Factura_Id BIGINT,
    Tiempo_Id INT,
    nro_sucursal BIGINT,
    Cliente_Id INT,
    Importe_Total DECIMAL(18,2),
    PRIMARY KEY (Factura_Id),
    FOREIGN KEY (Tiempo_Id) REFERENCES GESTIONEROS.D_Tiempo(Tiempo_Id),
    FOREIGN KEY (nro_sucursal) REFERENCES GESTIONEROS.D_Sucursal(nro_sucursal),
    FOREIGN KEY (Cliente_Id) REFERENCES GESTIONEROS.D_Cliente(Cliente_Id)
);




CREATE TABLE GESTIONEROS.H_Compras (
    Compra_Id DECIMAL(18,0),
    Tiempo_Id INT,
    nro_sucursal BIGINT,
    Importe_Total DECIMAL(18,2),
    Tipo_Material_Id INT,
    PRIMARY KEY (Compra_Id, Tipo_Material_Id),
    FOREIGN KEY (Tiempo_Id) REFERENCES GESTIONEROS.D_Tiempo(Tiempo_Id),
    FOREIGN KEY (nro_sucursal) REFERENCES GESTIONEROS.D_Sucursal(nro_sucursal),
    FOREIGN KEY (Tipo_Material_Id) REFERENCES GESTIONEROS.D_Tipo_Material(Tipo_Material_Id)
);




CREATE TABLE GESTIONEROS.H_Pedidos (
    Pedido_Id INT NOT NULL,
    Tiempo_Id INT,
    nro_sucursal BIGINT,
    Turno_Id INT,
    Estado_Pedido_Id INT,
    Modelo_Sillon_Id BIGINT NOT NULL,
    Cliente_Id INT,
    cantidad INT,
    PRIMARY KEY (Pedido_Id, Modelo_Sillon_Id),
    FOREIGN KEY (Tiempo_Id) REFERENCES GESTIONEROS.D_Tiempo(Tiempo_Id),
    FOREIGN KEY (nro_sucursal) REFERENCES GESTIONEROS.D_Sucursal(nro_sucursal),
    FOREIGN KEY (Turno_Id) REFERENCES GESTIONEROS.D_Turno_Ventas(Turno_Id),
    FOREIGN KEY (Estado_Pedido_Id) REFERENCES GESTIONEROS.D_Estado_Pedido(Estado_Pedido_Id),
    FOREIGN KEY (Modelo_Sillon_Id) REFERENCES GESTIONEROS.D_Modelo_Sillon(Modelo_Sillon_Id),
    FOREIGN KEY (Cliente_Id) REFERENCES GESTIONEROS.D_Cliente(Cliente_Id)
);


CREATE TABLE GESTIONEROS.H_Envios (
    Envio_Id DECIMAL(18,0) PRIMARY KEY,
    Tiempo_Id INT,
    Cliente_Id INT,
    Costo_Envio DECIMAL(18,2),
    Cumplido_En_Fecha BIT,
    FOREIGN KEY (Tiempo_Id) REFERENCES GESTIONEROS.D_Tiempo(Tiempo_Id),
    FOREIGN KEY (Cliente_Id) REFERENCES GESTIONEROS.D_Cliente(Cliente_Id)
);


go



-- ====================================================
--   CREACIÓN DE PROCEDIMIENTOS PARA MIGRAR TABLAS BI 
-- ====================================================



-- Procedimiento para poblar D_Tiempo
CREATE PROCEDURE GESTIONEROS.migrar_D_Tiempo
AS
BEGIN
    DECLARE @StartDate DATE, @EndDate DATE;




     SELECT
        @StartDate = (SELECT MIN(FechaMin) FROM (
            SELECT MIN(fecha) AS FechaMin FROM Gestioneros.Factura
            UNION ALL
            SELECT MIN(fecha) FROM Gestioneros.Compra
            UNION ALL
            SELECT MIN(fecha) FROM Gestioneros.Pedido
            UNION ALL
            SELECT MIN(fecha) FROM Gestioneros.Envio
        ) AS MinFechas),
        @EndDate = (SELECT MAX(FechaMax) FROM (
            SELECT MAX(fecha) AS FechaMax FROM Gestioneros.Factura
            UNION ALL
            SELECT MAX(fecha) FROM Gestioneros.Compra
            UNION ALL
            SELECT MAX(fecha) FROM Gestioneros.Pedido
            UNION ALL
            SELECT MAX(fecha) FROM Gestioneros.Envio
        ) AS MaxFechas);


    IF @StartDate IS NULL SET @StartDate = '2010-01-01';
    IF @EndDate IS NULL SET @EndDate = '2027-12-31';


    WHILE @StartDate <= @EndDate
    BEGIN
        INSERT INTO GESTIONEROS.D_Tiempo (
            Tiempo_Id, tiempo_cuatrimestre, tiempo_mes, tiempo_anio
        )
        VALUES (
            CAST(FORMAT(@StartDate, 'yyyyMMdd') AS INT),
            DATEFROMPARTS(YEAR(@StartDate),
                CASE
                    WHEN MONTH(@StartDate) BETWEEN 1 AND 4 THEN 1
                    WHEN MONTH(@StartDate) BETWEEN 5 AND 8 THEN 5
                    ELSE 9
                END,
                1),
            DATEFROMPARTS(YEAR(@StartDate), MONTH(@StartDate), 1),
            DATEFROMPARTS(YEAR(@StartDate), 1, 1)
        );


        SET @StartDate = DATEADD(day, 1, @StartDate);
    END;
END;
GO


-- Procedimiento para poblar D_Ubicacion
CREATE PROCEDURE GESTIONEROS.migrar_D_Ubicacion
AS
BEGIN
    INSERT INTO GESTIONEROS.D_Ubicacion (Provincia, Localidad, direccion)
    SELECT DISTINCT provincia, localidad, direccion
    FROM Gestioneros.Ubicacion
    WHERE provincia IS NOT NULL AND localidad IS NOT NULL AND direccion IS NOT NULL
END;
GO




-- Procedimiento para poblar D_Rango_Etario
CREATE PROCEDURE GESTIONEROS.migrar_D_Rango_Etario
AS
BEGIN
    INSERT INTO GESTIONEROS.D_Rango_Etario (Rango_Etario_Detalle) VALUES
    ('<25'),
    ('25-35'),
    ('35-50'),
    ('>50');
END;
GO




-- Procedimiento para poblar D_Turno_Ventas
CREATE PROCEDURE GESTIONEROS.migrar_D_Turno_Ventas
AS
BEGIN
    INSERT INTO GESTIONEROS.D_Turno_Ventas (Turno_Detalle) VALUES
    ('08:00 - 14:00'),
    ('14:00 - 20:00');
END;
GO




-- Procedimiento para poblar D_Tipo_Material
CREATE PROCEDURE GESTIONEROS.migrar_D_Tipo_Material
AS
BEGIN
    INSERT INTO GESTIONEROS.D_Tipo_Material (Tipo_Material_Detalle, Precio_Material, Tipo_Materal_Nombre)
    SELECT DISTINCT tipo, precio, nombre FROM Gestioneros.Material;
END;
GO




-- Procedimiento para poblar D_Modelo_Sillon
CREATE PROCEDURE GESTIONEROS.migrar_D_Modelo_Sillon
AS
BEGIN
    INSERT INTO GESTIONEROS.D_Modelo_Sillon (Modelo_Sillon_Id, Modelo_Descripcion)
    SELECT cod_modelo, descripcion FROM Gestioneros.Modelo;
END;
GO




-- Procedimiento para poblar D_Estado_Pedido
CREATE PROCEDURE GESTIONEROS.migrar_D_Estado_Pedido
AS
BEGIN
    INSERT INTO GESTIONEROS.D_Estado_Pedido (Estado_Pedido_Detalle)
    SELECT DISTINCT estado FROM Gestioneros.Pedido;
END;
GO




-- Procedimiento para poblar D_Sucursal
CREATE PROCEDURE GESTIONEROS.migrar_D_Sucursal
AS
BEGIN
    INSERT INTO GESTIONEROS.D_Sucursal (nro_sucursal, Ubicacion_Id, mail, telefono)
    SELECT DISTINCT
        s.nro_sucursal,
        BIU.ubicacion_id,
        s.mail,
        s.telefono
    FROM Gestioneros.Sucursal s
    JOIN Gestioneros.Ubicacion u ON s.ubicacion_id = u.ubicacion_id
    JOIN GESTIONEROS.D_Ubicacion BIU ON
            BIU.Provincia = U.provincia AND
            BIU.Localidad = U.localidad AND
            BIU.direccion = U.direccion
    WHERE NOT EXISTS (
        SELECT 1
        FROM GESTIONEROS.D_Sucursal BIS
        WHERE BIS.nro_sucursal = S.nro_sucursal
    );
END;
GO




-- Procedimiento para poblar D_Cliente
CREATE PROCEDURE GESTIONEROS.migrar_D_Cliente
AS
BEGIN
    DECLARE @RangoEtarioId INT;




    DECLARE cliente_cursor CURSOR FOR
        SELECT c.cliente_id, c.fechaNacimiento, u.ubicacion_id
        FROM Gestioneros.Cliente c
        JOIN Gestioneros.Ubicacion u ON c.ubicacion_id = u.ubicacion_id;




    DECLARE @cliente_id INT, @fechaNacimiento DATE, @ubicacion_id INT, @edad INT;




    OPEN cliente_cursor;
    FETCH NEXT FROM cliente_cursor INTO @cliente_id, @fechaNacimiento, @ubicacion_id;




    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @edad = DATEDIFF(year, @fechaNacimiento, GETDATE());




        IF @edad < 25
            SET @RangoEtarioId = 1;
        ELSE IF @edad BETWEEN 25 AND 35
            SET @RangoEtarioId = 2;
        ELSE IF @edad BETWEEN 36 AND 50
            SET @RangoEtarioId = 3;
        ELSE
            SET @RangoEtarioId = 4;




        INSERT INTO GESTIONEROS.D_Cliente (Cliente_Id, Rango_Etario_Id, Ubicacion_Id)
        VALUES (@cliente_id, @RangoEtarioId, @ubicacion_id);




        FETCH NEXT FROM cliente_cursor INTO @cliente_id, @fechaNacimiento, @ubicacion_id;
    END;




    CLOSE cliente_cursor;
    DEALLOCATE cliente_cursor;
END;
GO




-- Procedimiento para poblar H_Facturacion
CREATE PROCEDURE GESTIONEROS.migrar_H_Facturacion
AS
BEGIN
    INSERT INTO GESTIONEROS.H_Facturacion(Factura_Id, Tiempo_Id, nro_sucursal, Cliente_Id, Importe_Total)
    SELECT f.nro_factura, CAST(FORMAT(f.fecha, 'yyyyMMdd') AS INT), f.nro_sucursal, f.cliente_id, f.total
    FROM Gestioneros.Factura f;
END;
GO




-- Procedimiento para poblar H_Compras
CREATE PROCEDURE GESTIONEROS.migrar_H_Compras
AS
BEGIN
    WITH ComprasAgrupados AS (
         SELECT c.nro_compra as Compra_ID, CAST(FORMAT(c.fecha, 'yyyyMMdd') AS INT) AS Tiempo_ID, c.nro_sucursal, c.total, tm.Tipo_Material_Id
    FROM Gestioneros.Compra c join Gestioneros.Detalle_Compra dc on c.nro_compra = dc.nro_compra join Gestioneros.Material m on m.nro_material = dc.nro_material
    join Gestioneros.D_Tipo_Material tm on tm.Tipo_Materal_Nombre = m.nombre and tm.Tipo_Material_Detalle = tm.Tipo_Material_Detalle
    GROUP by c.nro_compra, c.fecha,  c.nro_sucursal, c.total, tm.Tipo_Material_Id
    )
    INSERT INTO GESTIONEROS.H_Compras(Compra_Id, Tiempo_Id, nro_sucursal, Importe_Total, Tipo_Material_Id)
    SELECT
        ca.Compra_ID,
        ca.Tiempo_ID,
        ca.nro_sucursal,
        ca.total,
        ca.Tipo_Material_Id
    FROM ComprasAgrupados ca
    LEFT JOIN Gestioneros.H_Compras h on h.Compra_Id = ca.Compra_ID and h.Tipo_Material_Id = ca.Tipo_Material_Id where h.Compra_Id is null;
END;
GO






CREATE PROCEDURE GESTIONEROS.migrar_H_Pedidos
AS
BEGIN
    WITH PedidosAgrupados AS (
        SELECT
            p.nro_pedido AS Pedido_Id,
            CAST(FORMAT(p.fecha, 'yyyyMMdd') AS INT) AS Tiempo_Id,
            p.nro_sucursal,
            CASE
                WHEN CAST(p.fecha AS TIME) BETWEEN '08:00:00' AND '13:59:59' THEN 1
                ELSE 2
            END AS Turno_Id,
            ep.Estado_Pedido_Id,
            ms.Modelo_Sillon_Id,
            c.Cliente_Id,
            SUM(dp.cantidad) AS cantidad
        FROM Gestioneros.Pedido p
        JOIN Gestioneros.Detalle_Pedido dp ON dp.pedido_id = p.nro_pedido
        JOIN Gestioneros.Sillon s ON dp.sillon_id = s.cod_sillon
        JOIN Gestioneros.D_Modelo_Sillon ms ON ms.Modelo_Sillon_Id = s.cod_modelo
        JOIN GESTIONEROS.D_Estado_Pedido ep ON p.estado = ep.Estado_Pedido_Detalle
        JOIN Gestioneros.D_Cliente c ON c.Cliente_Id = p.cliente_id
        GROUP BY
            p.nro_pedido,
            p.fecha,
            p.nro_sucursal,
            ep.Estado_Pedido_Id,
            ms.Modelo_Sillon_Id,
            c.Cliente_Id
    )
    INSERT INTO GESTIONEROS.H_Pedidos (
        Pedido_Id, Tiempo_Id, nro_sucursal, Turno_Id, Estado_Pedido_Id, Modelo_Sillon_Id, Cliente_Id, cantidad
    )
    SELECT
        pa.Pedido_Id,
        pa.Tiempo_Id,
        pa.nro_sucursal,
        pa.Turno_Id,
        pa.Estado_Pedido_Id,
        pa.Modelo_Sillon_Id,
        pa.Cliente_Id,
        pa.cantidad
    FROM PedidosAgrupados pa
    LEFT JOIN GESTIONEROS.H_Pedidos h
        ON h.Pedido_Id = pa.Pedido_Id AND h.Modelo_Sillon_Id = pa.Modelo_Sillon_Id
    WHERE h.Pedido_Id IS NULL;
END;
GO








-- Procedimiento para poblar H_Envios
CREATE PROCEDURE GESTIONEROS.migrar_H_Envios
AS
BEGIN
    INSERT INTO GESTIONEROS.H_Envios(Envio_Id, Tiempo_Id, Cliente_Id, Costo_Envio, Cumplido_En_Fecha)
    SELECT
        e.numero,
        CAST(FORMAT(e.fecha, 'yyyyMMdd') AS INT),
        f.cliente_id,
        e.envio_total,
        CASE WHEN e.fecha <= e.fecha_programada THEN 1 ELSE 0 END
    FROM Gestioneros.Envio e
    JOIN Gestioneros.Factura f ON e.numero = f.envio_id;
END;
GO












-- ======================================================
-- Creación de Vistas para Indicadores de Negocio
-- ======================================================


-- 1. Ganancias: Total de ingresos (facturación) - total de egresos (compras), por cada mes, por cada sucursal.
CREATE OR ALTER VIEW GESTIONEROS.V_Ganancias_Mensuales_Sucursal AS
WITH Ingresos AS (
    SELECT
        YEAR(t.tiempo_anio) AS Anio,
        MONTH(t.tiempo_mes) AS Mes,
        f.nro_sucursal,
        SUM(f.Importe_Total) AS Total_Ingresos
    FROM GESTIONEROS.H_Facturacion f
    JOIN GESTIONEROS.D_Tiempo t ON f.Tiempo_Id = t.Tiempo_Id
    GROUP BY YEAR(t.tiempo_anio), MONTH(t.tiempo_mes), f.nro_sucursal
),
Egresos AS (
    SELECT
        YEAR(t.tiempo_anio) AS Anio,
        MONTH(t.tiempo_mes) AS Mes,
        c.nro_sucursal,
        SUM(c.Importe_Total) AS Total_Egresos
    FROM GESTIONEROS.H_Compras c
    JOIN GESTIONEROS.D_Tiempo t ON c.Tiempo_Id = t.Tiempo_Id
    GROUP BY YEAR(t.tiempo_anio), MONTH(t.tiempo_mes), c.nro_sucursal
)
SELECT
    ISNULL(i.Anio, e.Anio) AS Anio,
    ISNULL(i.Mes, e.Mes) AS Mes,
    ISNULL(i.nro_sucursal, e.nro_sucursal) AS nro_sucursal,
    ISNULL(i.Total_Ingresos, 0) AS Ingresos,
    ISNULL(e.Total_Egresos, 0) AS Egresos,
    ISNULL(i.Total_Ingresos, 0) - ISNULL(e.Total_Egresos, 0) AS Ganancia
FROM Ingresos i
FULL OUTER JOIN Egresos e
    ON i.Anio = e.Anio AND i.Mes = e.Mes AND i.nro_sucursal = e.nro_sucursal;
GO




-- 2. Factura promedio por cuatrimestre y provincia
CREATE VIEW GESTIONEROS.V_Factura_Promedio_Provincia AS
SELECT
    YEAR(t.tiempo_cuatrimestre) AS Anio,
    CEILING(MONTH(t.tiempo_cuatrimestre) / 4.0) AS Cuatrimestre,
    u.Provincia,
    AVG(f.Importe_Total) as Factura_Promedio
FROM GESTIONEROS.H_Facturacion f
JOIN GESTIONEROS.D_Tiempo t ON f.Tiempo_Id = t.Tiempo_Id
JOIN GESTIONEROS.D_Sucursal s ON f.nro_sucursal = s.nro_sucursal
JOIN GESTIONEROS.D_Ubicacion u ON s.Ubicacion_Id = u.Ubicacion_Id
GROUP BY YEAR(t.tiempo_cuatrimestre), CEILING(MONTH(t.tiempo_cuatrimestre) / 4.0), u.Provincia
GO




--3.
CREATE OR ALTER VIEW GESTIONEROS.V_Top3_Modelos_Vendidos AS
WITH VentasModelos AS (
    SELECT
        t.tiempo_anio as Anio,
        t.tiempo_cuatrimestre as Cuatrimestre,
        u.Localidad,
        re.Rango_Etario_Detalle,
        ms.Modelo_Descripcion,
        SUM(hp.cantidad) AS Total_Vendido
    FROM GESTIONEROS.H_Pedidos hp
    JOIN GESTIONEROS.D_Tiempo t ON hp.Tiempo_Id = t.Tiempo_Id
    JOIN GESTIONEROS.D_Sucursal su ON hp.nro_sucursal = su.nro_sucursal
    JOIN GESTIONEROS.D_Ubicacion u ON su.Ubicacion_Id = u.Ubicacion_Id
    JOIN GESTIONEROS.D_Cliente c ON hp.Cliente_Id = c.Cliente_Id
    JOIN GESTIONEROS.D_Rango_Etario re ON c.Rango_Etario_Id = re.Rango_Etario_Id
    JOIN GESTIONEROS.D_Modelo_Sillon ms ON hp.Modelo_Sillon_Id = ms.Modelo_Sillon_Id
    GROUP BY
        t.tiempo_anio,
        t.tiempo_cuatrimestre,
        u.Localidad,
        re.Rango_Etario_Detalle,
        ms.Modelo_Descripcion
)
SELECT
    Anio,
    Cuatrimestre,
    Localidad,
    Rango_Etario_Detalle,
    Modelo_Descripcion,
    Total_Vendido
FROM (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY Anio, Cuatrimestre, Localidad, Rango_Etario_Detalle
            ORDER BY Total_Vendido DESC
        ) AS rn
    FROM VentasModelos
) t
WHERE rn <= 3;
GO






-- 4. Volumen de pedidos por turno, sucursal y mes
CREATE VIEW GESTIONEROS.V_Volumen_Pedidos AS
SELECT
    YEAR(t.tiempo_mes) AS Anio,
    MONTH(t.tiempo_mes) AS Mes,
    p.nro_sucursal,
    tv.Turno_Detalle,
    COUNT(p.Pedido_Id) as Cantidad_Pedidos
FROM GESTIONEROS.H_Pedidos p
JOIN GESTIONEROS.D_Tiempo t ON p.Tiempo_Id = t.Tiempo_Id
JOIN GESTIONEROS.D_Turno_Ventas tv ON p.Turno_Id = tv.Turno_Id
GROUP BY YEAR(t.tiempo_mes), MONTH(t.tiempo_mes), p.nro_sucursal, tv.Turno_Detalle;
GO




-- 5. Conversión de pedidos por estado, cuatrimestre y sucursal
CREATE VIEW GESTIONEROS.V_Conversion_Pedidos AS
SELECT
    YEAR(t.tiempo_cuatrimestre) AS Anio,
    ((MONTH(t.tiempo_cuatrimestre) - 1) / 4) + 1 AS Cuatrimestre,
    p.nro_sucursal,
    ep.Estado_Pedido_Detalle,
    CAST(COUNT(p.Pedido_Id) * 100.0 / SUM(COUNT(p.Pedido_Id)) OVER (
        PARTITION BY YEAR(t.tiempo_cuatrimestre), ((MONTH(t.tiempo_cuatrimestre) - 1) / 4) + 1, p.nro_sucursal
    ) AS DECIMAL(5,2)) as Porcentaje
FROM GESTIONEROS.H_Pedidos p
JOIN GESTIONEROS.D_Tiempo t ON p.Tiempo_Id = t.Tiempo_Id
JOIN GESTIONEROS.D_Estado_Pedido ep ON p.Estado_Pedido_Id = ep.Estado_Pedido_Id
GROUP BY YEAR(t.tiempo_cuatrimestre), ((MONTH(t.tiempo_cuatrimestre) - 1) / 4) + 1, p.nro_sucursal, ep.Estado_Pedido_Detalle;
GO




-- 6. Tiempo promedio de fabricación por sucursal y cuatrimestre
CREATE OR ALTER VIEW GESTIONEROS.V_Tiempo_Promedio_Fabricacion AS
WITH PedidosConFecha AS (
    SELECT
        p.Pedido_Id,
        p.nro_sucursal,
        p.Cliente_Id,
        tp.tiempo_cuatrimestre AS Fecha_Pedido
    FROM GESTIONEROS.H_Pedidos p
    JOIN GESTIONEROS.D_Tiempo tp ON p.Tiempo_Id = tp.Tiempo_Id
),
FacturasConFecha AS (
    SELECT
        f.Factura_Id,
        f.nro_sucursal,
        f.Cliente_Id,
        tf.tiempo_cuatrimestre AS Fecha_Factura
    FROM GESTIONEROS.H_Facturacion f
    JOIN GESTIONEROS.D_Tiempo tf ON f.Tiempo_Id = tf.Tiempo_Id
)
SELECT
    DATEPART(YEAR, f.Fecha_Factura) AS Anio,
    CEILING(DATEPART(MONTH, f.Fecha_Factura) / 4.0) AS Cuatrimestre,
    f.nro_sucursal,
    AVG(CAST(DATEDIFF(DAY, p.Fecha_Pedido, f.Fecha_Factura) AS FLOAT)) AS Promedio_Dias_Fabricacion
FROM FacturasConFecha f
JOIN PedidosConFecha p
    ON f.Cliente_Id = p.Cliente_Id
    AND f.nro_sucursal = p.nro_sucursal
    AND p.Fecha_Pedido <= f.Fecha_Factura
    AND DATEDIFF(DAY, p.Fecha_Pedido, f.Fecha_Factura) <= 60
GROUP BY
    DATEPART(YEAR, f.Fecha_Factura),
    CEILING(DATEPART(MONTH, f.Fecha_Factura) / 4.0),
    f.nro_sucursal;
GO


-- 7. Promedio de Compras por mes
CREATE VIEW GESTIONEROS.V_Promedio_Compras_Mensual AS
SELECT
    YEAR(t.tiempo_mes) AS Anio,
    MONTH(t.tiempo_mes) AS Mes,
    AVG(c.Importe_Total) as Promedio_Compras
FROM GESTIONEROS.H_Compras c
JOIN GESTIONEROS.D_Tiempo t ON c.Tiempo_Id = t.Tiempo_Id
GROUP BY YEAR(t.tiempo_mes), MONTH(t.tiempo_mes);
GO




--8
CREATE VIEW GESTIONEROS.V_Compras_Por_Tipo_Material AS
SELECT
    YEAR(t.tiempo_cuatrimestre) AS Anio,
    CEILING(MONTH(t.tiempo_cuatrimestre) / 4.0) AS Cuatrimestre,
    c.nro_sucursal,
    tm.Tipo_Material_Detalle,
    SUM(tm.Precio_Material) AS Total_Gastado
FROM GESTIONEROS.H_Compras c
JOIN GESTIONEROS.D_Tipo_Material tm ON c.Tipo_Material_Id = tm.Tipo_Material_Id
JOIN GESTIONEROS.D_Tiempo t ON c.Tiempo_Id = t.Tiempo_Id
GROUP BY
    YEAR(t.tiempo_cuatrimestre),
    CEILING(MONTH(t.tiempo_cuatrimestre) / 4.0),
    c.nro_sucursal,
    tm.Tipo_Material_Detalle;
GO




-- 9. Porcentaje de cumplimiento de envíos por mes
CREATE VIEW GESTIONEROS.V_Cumplimiento_Envios AS
SELECT
    YEAR(t.tiempo_mes) AS Anio,
    MONTH(t.tiempo_mes) AS Mes,
    CAST(SUM(CASE WHEN e.Cumplido_En_Fecha = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(e.Envio_Id) AS DECIMAL(5,2)) as Porcentaje_Cumplimiento
FROM GESTIONEROS.H_Envios e
JOIN GESTIONEROS.D_Tiempo t ON e.Tiempo_Id = t.Tiempo_Id
GROUP BY YEAR(t.tiempo_mes), MONTH(t.tiempo_mes);
GO




-- 10. Las 3 localidades con mayor costo de envío promedio
CREATE VIEW GESTIONEROS.V_Top3_Localidades_Costo_Envio AS
SELECT TOP 3
    u.Localidad,
    u.Provincia,
    AVG(e.Costo_Envio) as Promedio_Costo_Envio
FROM GESTIONEROS.H_Envios e
JOIN GESTIONEROS.D_Cliente c ON e.Cliente_Id = c.Cliente_Id
JOIN GESTIONEROS.D_Ubicacion u ON c.Ubicacion_Id = u.Ubicacion_Id
GROUP BY u.Localidad, u.Provincia
ORDER BY Promedio_Costo_Envio DESC;
GO



-- ===================================================
-- EJECUCIÓN DE PROCEDIMIENTOS PARA MIGRAR TABLAS BI 
-- ===================================================


EXEC GESTIONEROS.migrar_D_Tiempo;
EXEC GESTIONEROS.migrar_D_Ubicacion;
EXEC GESTIONEROS.migrar_D_Rango_Etario;
EXEC GESTIONEROS.migrar_D_Turno_Ventas;
EXEC GESTIONEROS.migrar_D_Tipo_Material;
EXEC GESTIONEROS.migrar_D_Modelo_Sillon;
EXEC GESTIONEROS.migrar_D_Estado_Pedido;
EXEC GESTIONEROS.migrar_D_Sucursal;
EXEC GESTIONEROS.migrar_D_Cliente;
EXEC GESTIONEROS.migrar_H_Facturacion;
EXEC GESTIONEROS.migrar_H_Compras;
EXEC GESTIONEROS.migrar_H_Pedidos;
EXEC GESTIONEROS.migrar_H_Envios;


GO


