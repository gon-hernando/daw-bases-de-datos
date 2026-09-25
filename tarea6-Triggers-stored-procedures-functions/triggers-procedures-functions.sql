-- TRIGGER DE INSERCIÓN --

/*
* Genera un trigger que al insertar un producto 
* si su precio es menor que cero lo ponga a cero 
* y genere una excepción avisando de ello.
*/

DELIMITER $$

DROP TRIGGER IF EXISTS trigger_check_precio_before_insert;

CREATE TRIGGER trigger_check_precio_before_insert
BEFORE INSERT 
ON producto 
FOR EACH ROW
BEGIN
	IF	NEW.precio < 0 THEN
		SET new.precio = 0;
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'El precio no puede ser negativo, se ha ajustado a 0';
	END IF;
END$$

DELIMITER ;


-- TRIGGER DE ACTUALIZACIÓN --

/* 
Genera un trigger que al actualizar un precio 
si es menor que cero lo ponga a cero 
y avise con una excepción.
*/

DELIMITER $$

DROP TRIGGER IF EXISTS trigger_check_precio_before_update;

CREATE TRIGGER trigger_check_precio_before_update
BEFORE UPDATE 
ON producto
FOR EACH ROW
BEGIN
	IF NEW.precio < 0 THEN
		SET new.precio = 0;
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'El precio no puede ser negativo, se ha ajustado a 0';
	END IF;
END$$

DELIMITER ;


-- TRIGGER DE BORRADO --

/*Al borrar un producto lo guarda en el log*/

DELIMITER $$

DROP TRIGGER IF EXISTS trigger_log_delete_producto;

CREATE TRIGGER trigger_log_delete_producto
BEFORE DELETE 
ON producto 
FOR EACH ROW
BEGIN
	INSERT INTO producto_borrado_log (producto_id, nombre, precio, id_fabricante)
    VALUES (OLD.id, OLD.nombre, OLD.precio, OLD.id_fabricante);
END$$

DELIMITER ;


-- PROCEDIMIENTO ALMACENADO --

/* 
•reciba un ID y un porcentaje 
•aumente el precio de todos los productos de ese fabricante en el porcentaje 
•devuelva cuántas filas se actualizaron
*/

DELIMITER $$

DROP PROCEDURE IF EXISTS cambiar_precio_fabricante $$

CREATE PROCEDURE cambiar_precio_fabricante (
IN p_id_fabricante INT,
IN p_porcentaje DECIMAL (5,2),
OUT p_lineas INT
)

BEGIN 
	UPDATE producto
    SET precio = precio + (precio * p_porcentaje / 100)
    WHERE id_fabricante = p_id_fabricante;
    
    SET p_lineas = ROW_COUNT();
    
END$$

DELIMITER ;


-- FUNCIÓN --

DELIMITER $$

DROP FUNCTION IF EXISTS precio_medio_fabricante $$

CREATE FUNCTION precio_medio_fabricante (
f_id_fabricante INT
)
RETURNS DECIMAL (10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE media DECIMAL (10,2);
    
	SELECT AVG(precio) INTO media 
    FROM producto
	WHERE id_fabricante = f_id_fabricante;
    
    RETURN COALESCE(media, 0);
    
END$$

DELIMITER ;


    
