/* APARTADO 1 */

DROP DATABASE IF EXISTS liga_bd_03;
CREATE DATABASE liga_bd_03;

USE liga_bd_03;

CREATE TABLE Equipo (
	codEquipo INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR (50) UNIQUE NOT NULL,
	ciudad VARCHAR (50) NOT NULL,
	puntos INT
	);

CREATE TABLE Jugador (
    codJugador INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    dni VARCHAR(9) NOT NULL UNIQUE,
    edad TINYINT NOT NULL,
    telefono VARCHAR(16) NOT NULL,
    codEquipo INT,
    fechaAlta DATE DEFAULT (CURRENT_DATE) NOT NULL,
    dorsal VARCHAR(2),
    CONSTRAINT fk_jugador_equipo FOREIGN KEY (codEquipo)
        REFERENCES Equipo (codEquipo)
        ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE Partido (
    codEquipoLocal INT NOT NULL,
    codEquipoVisitante INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    resultado VARCHAR(10),
    PRIMARY KEY (codEquipoLocal , codEquipoVisitante , fecha_hora),
    CONSTRAINT fk_partido_equipo_local FOREIGN KEY (codEquipoLocal)
        REFERENCES Equipo (codEquipo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_partido_equipo_visitante FOREIGN KEY (codEquipoVisitante)
        REFERENCES Equipo (codEquipo)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/* APARTADO 2 */

ALTER TABLE jugador
	DROP FOREIGN KEY fk_jugador_equipo;

ALTER TABLE partido 
	DROP FOREIGN KEY fk_partido_equipo_local;
    
ALTER TABLE partido 
	DROP FOREIGN KEY fk_partido_equipo_visitante;
    
ALTER TABLE Equipo
	MODIFY codEquipo INT NOT NULL;

ALTER TABLE Equipo 
	DROP PRIMARY KEY;

ALTER TABLE Jugador
	DROP COLUMN codEquipo;
    
ALTER TABLE Partido
    DROP COLUMN codEquipoLocal,
    DROP COLUMN codEquipoVisitante;

ALTER TABLE Equipo
	ADD PRIMARY KEY (nombre);

ALTER TABLE Jugador
	ADD nombreEquipo VARCHAR (50);

ALTER TABLE Partido 
	ADD equipoLocal VARCHAR (50),
	ADD equipoVisitante VARCHAR (50);

ALTER TABLE Jugador
	ADD CONSTRAINT fk_jugador_equipo 
	FOREIGN KEY (nombreEquipo)
	REFERENCES Equipo (nombre)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE Partido
	ADD CONSTRAINT fk_partido_equipo_local 
	FOREIGN KEY (equipoLocal) 
	REFERENCES Equipo (nombre)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE Partido
	ADD CONSTRAINT fk_partido_equipo_visitante
	FOREIGN KEY (equipoVisitante) 
	REFERENCES Equipo (nombre)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
    
/* APARTADO 3 */

ALTER TABLE Equipo
	ADD codCapitan INT;

ALTER TABLE Equipo
	ADD CONSTRAINT fk_equipo_jugador 
	FOREIGN KEY (codCapitan) 
	REFERENCES Jugador (codJugador)
	ON DELETE SET NULL
    ON UPDATE CASCADE;
    
/* APARTADO 4 */
    
CREATE INDEX idx_jugador_apellido_nombre
    ON JUGADOR (Apellidos, Nombre);
    
ALTER TABLE Equipo
	RENAME COLUMN puntos TO ptosEquipo;

ALTER TABLE Equipo
	MODIFY COLUMN ptosEquipo INT DEFAULT 0;
    
DROP DATABASE IF EXISTS liga_bd_03;
