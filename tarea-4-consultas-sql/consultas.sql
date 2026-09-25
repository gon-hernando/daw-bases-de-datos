/*"CONSULTA 1: ¿Nombre y apellidos de los profesores que nacieron el 4 de Enero de 1999?*/

SELECT 
    nombre, apellidos /*seleccionamos los campos a mostrar*/
FROM
    profesor /*de la tabla especifica*/
WHERE
    fecha_nacimiento = "1999-1-4"; /*filtramos por fecha de nacimiento*/

/*CONSULTA 2: ¿Cuántos alumnos hay matriculados en la asignatura cuyo código identificativo es el 4?*/

SELECT 
    COUNT(dni_alumno) /*función de conteo*/
FROM
    matricula
WHERE
    cod_asignatura = '4';

/*CONSULTA 3: Mostrar los nombres y apellidos de todos los alumnos que están cursando la asignatura "Bases de Datos", ordenados alfabéticamente por apellidos y nombre*/

SELECT 
    alumno.nombre, apellidos #necesario alumno. por repeticion de nombre en diferentes tablas
FROM
    alumno
        INNER JOIN
    matricula ON alumno.dni_alumno = matricula.dni_alumno #enlazamos a matricula como tabla puente a tabla asignatura
        INNER JOIN
    asignatura ON matricula.cod_asignatura = asignatura.cod_asignatura
WHERE
    asignatura.nombre = 'Bases de Datos'
ORDER BY apellidos , nombre;

/*CONSULTA 4: Mostrar los nombres y apellidos de los profesores que dan alguna asignatura del curso de 'Desarrollo Web'  ordenando alfabéticamente los resultados por apellidos y nombre (Nota: No se deben mostrar los profesores repetidos)*/

SELECT DISTINCT
    profesor.nombre, apellidos #necesario profesor. por repeticion de nombre en diferentes tablas
FROM
    profesor
        INNER JOIN
    asignatura ON profesor.dni_profesor = asignatura.dni_profesor #enlazamos a asignatura como tabla puente a tabla curso
        INNER JOIN
    curso ON asignatura.cod_curso = curso.codigo_curso
WHERE
    curso.nombre = 'Desarrollo Web'; #filtro

/*CONSULTA 5: Mostrar un listado con todos los profesores del centro, indicando en una columna si el profesor es tutor o no de algún curso.*/

SELECT 
    profesor.nombre, apellidos,

        CASE
        WHEN curso.codigo_curso IS NOT NULL THEN 'Si' #funcion CASE definiendo campo tutoriza (si/no) en funcion de campo codigo_curso (not null/null)
        ELSE 'No'
    END AS tutoriza

FROM
    profesor
        LEFT JOIN /*mostrar todos los profesores, aunque no sean tutores.*/
    curso ON profesor.dni_profesor = curso.dni_tutor;

/*CONSULTA 6: Para cada asignatura del curso "Desarrollo Web" mostrar el número de alumnos matriculados y el número de alumnos que han aprobado.*/

SELECT 
    asignatura.nombre,
    COUNT(matricula.dni_alumno) AS numeroAlumnos, #contamos numero de matriculas y definimos como nuevo campo numeroAlumnos
    SUM(CASE #definimos sumatorio
                WHEN matricula.nota >= 5 THEN 1 #función CASE para numeroAprobados
                ELSE 0
            END) AS numeroAprobados
FROM
    asignatura
        INNER JOIN
    curso ON asignatura.cod_curso = curso.codigo_curso
        INNER JOIN
    matricula ON asignatura.cod_asignatura = matricula.cod_asignatura
WHERE
    curso.nombre = 'Desarrollo Web' #filtro
GROUP BY asignatura.nombre; #agrupamos el conteo y el sumatorio por asignatura.nombre

/*CONSULTA 7: Mostrar un listado de qué días, a qué horas y en qué aulas se imparte la asignatura de "Javascript".*/

SELECT 
    aula_asignatura.cod_aula,
    aula_asignatura.dia,
    aula_asignatura.hora
FROM
    aula_asignatura
        INNER JOIN
    asignatura ON aula_asignatura.cod_asignatura = asignatura.cod_asignatura
WHERE
    asignatura.nombre = 'Javascript';

/*CONSULTA 8: Mostrar los nombres de las asignaturas que tienen matriculados entre 20 y 25 alumnos */

SELECT 
    asignatura.nombre
FROM
    asignatura
        INNER JOIN
    matricula ON asignatura.cod_asignatura = matricula.cod_asignatura
GROUP BY asignatura.nombre #mostramos el campo seleccionado agrupandolo por asignatura.nombre
HAVING COUNT(matricula.dni_alumno) BETWEEN 20 AND 25; #funcion HAVING puesto que WHERE no aplica para funciones agregadas (ej:COUNT)

/*CONSULTA 9: ¿Cuál es la edad media (con un decimal) de todos los alumnos matriculados en el curso de Piano? */

    SELECT 
    ROUND(AVG(edad), 1) AS edad_media #seleccionamos media de edad
FROM
    (SELECT DISTINCT 
        alumno.dni_alumno,
            TIMESTAMPDIFF(YEAR, alumno.fecha_nacimiento, CURDATE()) AS edad #diferencia de año actual con fecha nacimeinto para edad
    FROM
        alumno
    INNER JOIN matricula ON alumno.dni_alumno = matricula.dni_alumno
    INNER JOIN asignatura ON matricula.cod_asignatura = asignatura.cod_asignatura
    INNER JOIN curso ON asignatura.cod_curso = curso.codigo_curso
    WHERE
        curso.nombre = 'piano') temporal; #filtro y nombre de consulta temporal por exigencia de SQL (subconsulta)
