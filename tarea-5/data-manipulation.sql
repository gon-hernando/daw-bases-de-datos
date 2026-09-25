-- ACTIVIDAD 1

-- Apartado 1.1

/*•	Inserta una nueva agencia llamada "InmoSalobreña" con sede en la C/. Nueva 34, en el Local A. En Salobreña, provincia de Granada. Su teléfono es el 958-098-909 y su cif "C-180012001".*/
ALTER TABLE viviendas.agencia
CHANGE COLUMN cif cif CHAR(11) NOT NULL;
INSERT INTO vivienda.agencia (idAgencia, nombre, cif, direccion, telefono) 
VALUES (5, 'InmoSalobreña', 'C1800112001', 'C/. Nueva 34, Local A. Salobreña (Granada)', '958098909');

/*•	Inserta una nueva vivienda (con los datos que quieras) para la agencia número 1, cuyo propietario tiene el identificador 1, y está ubicada en la "C/. Roma" nº 3. Con código postal 41005.*/
INSERT INTO viviendas.cp (cp, idPoblacion) VALUES (41005, 3);
INSERT INTO viviendas.vivienda (idVivienda, calle, num, piso, cp, descripcion, idPropietario, idAgencia) VALUES (20, 'C./Roma', 3, 2, 41005, 'piso coqueto', 1, 1);

-- Apartado 1.2

/*•	Queremos modificar el propietario de la vivienda situada en la "C/. Siderurgia nº 4 1º-C" en Sevilla, de forma que sea Álvaro de la Font.*/
ALTER TABLE viviendas.propietario
CHANGE COLUMN dni dni VARCHAR(45) NULL;

INSERT INTO viviendas.propietario (idPropietario, nombre, apellidos) VALUES ('16', 'Alvaro', 'de la Font');

UPDATE viviendas.vivienda 
SET 
    idPropietario = 16
WHERE
    (idVivienda = 7);
    
/*•	Actualiza en la tabla "cp", el código postal 11520 por 11001.*/
INSERT INTO viviendas.poblacion (idPoblacion, poblacion, provincia) VALUES (8, ' Cádiz', 'Cádiz');

INSERT INTO viviendas.cp (cp, idPoblacion) VALUES (11001, 8);

UPDATE viviendas.vivienda 
SET 
    cp = 11001
WHERE
    idVivienda = 8;
    
UPDATE viviendas.vivienda 
SET 
    cp = 11001
WHERE
    idVivienda = 10;


-- Apartado 1.3

/*•	Elimina la vivienda ubicada en la C/. Sevilla nº 3 de la base de datos de la tabla "vivienda"*/
DELETE FROM viviendas.vivienda 
WHERE
    (idVivienda = '15');

/*•	Elimina el inquilino Domingo González Cabrera de la tabla de "inquilino"*/    
DELETE FROM viviendas.inquilino 
WHERE
    (idInquilino = '10');

-- ACTIVIDAD 2

-- Apartado 2.1

UPDATE inquilino 
SET 
    nombre = 'Maria Isabel',
    apellidos = 'Vargas Vargas'
WHERE
    telefono = '968852212';
    
 -- Apartado 2.2
 INSERT INTO cp VALUES (41008, 2), (41009, 2), (41701, 6), (41092, 5);
 
  -- Apartado 2.3
DELETE FROM alquiler 
WHERE
    idInquilino = 20
    OR (IdInquilino = 15 AND idVivienda = 1);
  
  -- ACTIVIDAD 3

-- Apartado 3.1

SELECT 
    idPropietario
FROM
    propietario
WHERE
    nombre = 'Alonso'
        AND apellidos = 'Puebla Díaz';
        
-- Apartado 3.2

UPDATE vivienda 
SET 
    idAgencia = (SELECT 
            idAgencia
        FROM
            agencia
        WHERE
            nombre = 'TuNUevaCasa')
WHERE
    idPropietario = (SELECT 
            idPropietario
        FROM
            propietario
        WHERE
            dni = '44578891S');
            
-- Apartado 3.3

INSERT INTO vivienda (calle, num, piso, cp, idPropietario, idAgencia)
SELECT 
    'Calle Bonifacio Caro',
    34,
    1,
    18610,
    p.idPropietario,
    (SELECT idAgencia
        FROM agencia
        WHERE nombre = 'ArrendaSevilla'
    )
FROM propietario p
WHERE p.idPropietario NOT IN (
    SELECT v.idPropietario
    FROM vivienda v
    WHERE v.idAgencia = (
        SELECT idAgencia
        FROM agencia
        WHERE nombre = 'ArrendaSevilla'
    )
);


-- Apartado 3.4

INSERT INTO inquilino (dni, nombre, apellidos, telefono)
SELECT
    p.dni,
    p.nombre,
    p.apellidos,
    p.telefono
FROM propietario p
WHERE p.idPropietario NOT IN (
    SELECT v.idPropietario
    FROM vivienda v
    WHERE v.idVivienda IN (
        SELECT a.idVivienda
        FROM alquiler a
    )
);

-- Apartado 3.5

UPDATE propietario 
SET 
    email = CONCAT(LEFT(nombre, 1),
            LEFT(apellidos, 4),
            '@alquileres.org')
WHERE
    idPropietario IN (SELECT 
            idPropitario
        FROM
            vivienda
        WHERE
            idVivienda IN (SELECT 
                    idVivienda
                FROM
                    alquiler
                WHERE
                    fecInicio >= '2000-01-01'));
        

-- Apartado 3.6

DELETE FROM vivienda 
WHERE
    idPropietario IN (SELECT 
        idPropietario
    FROM
        vivienda
    GROUP BY idPropietario
    HAVING COUNT(idVivienda) = (SELECT 
            COUNT(idVivienda) AS numViviendas
        FROM
            vivienda
        GROUP BY idPropietario
        ORDER BY numViviendas
        LIMIT 1))
    AND idVivienda NOT IN (SELECT 
        idVivienda
    FROM
        alquiler);
