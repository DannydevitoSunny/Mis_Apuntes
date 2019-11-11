
--CREACION DE UNA TABLA-------------------------------------------------------------------------
-- apoyo actividad 10
-- apoyo actividad 11

DROP TABLE IF EXISTS `Usuarios`;
CREATE TABLE IF NOT EXISTS `Usuarios` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sexo` char(6) COLLATE utf8_spanish_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Usuarios_UN` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--ponerlo dentro de la tabla para crear una primary key
CONSTRAINT pk_responsable_quirofano PRIMARY KEY (cod_quirofano,cod_trabajador)

--Hacer un alter table:
ALTER TABLE quirofano_area ADD CONSTRAINT FOREIGN KEY (cod_quirofano) REFERENCES quirofano(cod_quirofano) ON UPDATE CASCADE ON DELETE CASCADE;--Estamos añadiendo la flecha que relaciona las tablas;

--renombrar una columna:
ALTER TABLE responsable_area CHANGE cod_area area TINYINT UNSIGNED; -- CHANGE cambia nombre y tipo de dato
ALTER TABLE trabajadores MODIFY direccion VARCHAR(150) NOT NULL; -- MODIFY solo cambia tipo de dato


--Elimininar de la tabla responsable_area la FK que va desde empleado a la tabla
--trabajadores.
SELECT * FROM information_schema.referential_constraints WHERE constraint_schema= 'hospital'; --vemos las cosntraints de la base de datos hospital, buscamos el nombre de la foreign key que necesitamos
ALTER TABLE responsable_area DROP FOREIGN KEY responsable_area_ibfk_1; -- Indicamos la tabla desde la que nace y indicamos el nombre de la foreign key para dropearla


--insertar datos en la tabla:
INSERT INTO hospital VALUES --respetando el orden de los datos
(1,'11111','11111'),
(2,'22222','22222'),
(3,'3333333','333333');

INSERT IGNORE INTO areas VALUES (102, 'Thyro', '5'),(101, 'Differin', '5'), (115, 'Argentum', '4'),(66, 'Ephedrine', '45'),(43, 'Topiclear', '87'),(87, 'Aricept', '47');-- Si los datos ya existen, no se alteran


-- Cargamos datos de un fichero externo:
LOAD DATA INFILE ' <ruta donde tengamos la tabla guardada> ' INTO TABLE quirofano_area FIELDS TERMINATED BY ';' ( cod_quirofano, cod_area); --indicamos el orden de los datos
LOAD DATA INFILE ' <ruta donde tengamos la tabla guardada> ' INTO TABLE responsable_quirofano FIELDS TERMINATED BY '*' LINES TERMINATED BY ';'; --indicamos en que termina cada campo
LOAD DATA INFILE 'C:/xampp/mysql/data/hospital/quiro.txt' REPLACE INTO TABLE quirofano FIELDS TERMINATED BY '$' LINES TERMINATED BY '\n' (cod_quirofano,nombre,num_mesas_operacion); -- Reemplazamos los antiguos datos con los nuevos



------------ TEXT INDEX y FULLTEXT INDEX---------------
CREATE INDEX idx_area ON areas(nombre);
CREATE FULLTEXT INDEX idx_ejercicio_10 ON actv_10.trabajadores(direccion);




--CREACIÓN DE USUARIOS------------------------------------------------------------------
--apoyo en actividad 12

CREATE USER 'Simo'@'localhost' IDENTIFIED BY 'muerte';
CREATE USER 'Haya'@'%' IDENTIFIED BY 'blanca';
DROP USER 'Simo'@'localhost'; -- Dropeamos el usuario
USE mysql;
SELECT user, host, password FROM user;--Vemos los usuarios

SELECT user, host, password FROM mysql.user;--Vemos los usuarios sIN tener que estar en la base de datos mysql


--Segunda forma

SHOW GRANTS FOR 'Simo'@'localhost'; -- Muestra los permisos del usuario INdicado
SELECT PASSWORD('supercalifragilisticoespialidoso');

CREATE USER 'Simo'@'localhost' IDENTIFIED BY PASSWORD '*B01459247E9E39BA8F5C260977D5C515BAA1D2F4';
SHOW GRANTS FOR 'Simo'@'localhost';

--Tercera forma

CREATE USER 'Simo'@'localhost';
SET PASSWORD FOR 'Simo'@'localhost' = PASSWORD('MUERTE') -- La codifica de otra manera, las mayus son distINtas a las mINus

SHOW GRANTS FOR 'Simo'@'localhost'; -- Muestra los permisos del usuario INdicado


--PRIVILEGIOS--------------------------------------------------------

SHOW GRANTS FOR 'Simo'@'localhost'; -- Muestra los permisos del usuario INdicado
SHOW PRIVILEGES; -- Te muestra todos los permisos que puedes asignar a los usarios

--Creacion de un usuario casi como root
CREATE USER 'edu'@'localhost' IDENTIFIED BY '12345qwert';
GRANT ALL PRIVILEGES ON *.* TO 'edu'@'localhost' WITH GRANT OPTION; --Decimos que le estamos dANDo todos los privilegios en todo, INcluso puede dar privilegios a otros usuarios y crearlos (es un AdmIN.)
FLUSH PRIVILEGES; --Recargamos privilegios o recargargamos usuarios

CREATE USER 'edu'@'localhost' IDENTIFIED BY '1234qwer';
GRANT SELECT(<columna>, <columna>), UPDATE(<columna>) ON 'basededatos.tabla' TO 'edu'@'localhost';-- Asignamos al usuario INdicado los permisos que queramos (SELECT, UPDATE) y decimos lo que queremos ver INdicANDolo entre parentesis
SHOW PRIVILEGES; -- Refrescamos los privilegios

--Update de actores:
UPDATE actor SET last_name = 'DE NIRO' WHERE actor_id=207;

SELECT CURRENT_ROLE;--vemos los roles que hay ahora mismo

CRETATE ROLE stark; --creamos el rol stark

GRANT ALL PRIVILEGES ON sakila.actor TO stark; -- decimos que el rol stark tendrá acceso a la tabla actor
FLUSH PRIVILEGES; -- refresh de los priilegios

GRANT stark TO 'usuario'@'localhost'; -- asigamos a un usuario los permisos que hemos dado con el paquete stark

SET ROLE stark; --Actua con los permisos de rol de stark

SET DEFAULT ROLE stark FOR 'usuario'@'localhost'; --Actua por defecto con el rol de stark

FLUSH PRIVILEGES; --refrescamos privilegios

GRANT USAGE ON *.* TO 'usuario'@'usuario' WITH MAX_QUERIES_PER_HOUR 2; -- decimos que bloqueamos las consultas de este usario a 2 por hora




-- LAS CONSULTAS------------------------------------------------------------

SELECT DISTINCT nombre FROM usuarios; --Selecciona todos los nombres distintos

SELECT count(*) FROM usuarios; --Devuelve un numero, en este caso el numero de usuarios

SELECT count(distINct(nombre)) FROM usuarios; -- Devuelve el numero de usuarios distintos que hay

SELECT * FROM compra WHERE precio_compra <= "15000"; --Devuelve todo lo que este por debajo de 15000

SELECT * FROM compra where precio_compra >=14500 AND precio_compra <= 15000; --Lo mismo pero con un rango

SELECT * FROM compra where precio_compra >=14500 AND precio_compra <= 15000 OR precio_compra >=11000 AND precio_compra <= 12000 ;

SELECT count(*) FROM vehiculos WHERE marca != "audi"; --Devuelve el numero de marcas distintas de audi

SELECT count(distINct(marca)) FROM vehiculos WHERE marca != "audi"; --Lo mismo que la de arriba

SELECT * FROM vehiculos WHERE marca = "toyota" OR marca = "volvo"; --Devuelve solo los que sean toyota o volvo

SELECT * FROM vehiculos WHERE marca IN("toyota", "marca");---> lo mismo que arriba; TAMBIEN EXISTE EL NOT IN, justo lo contrario

SELECT * FROM vehiculos WHERE marca LIKE "volvo"; -- LIKE es el igual para texto

SELECT * FROM modelos WHERE modelos LIKE "%es"; ---> el porcentaje los busca todo

SELECT * FROM modelos WHERE modelos LIKE "%es%";

SELECT * FROM modelos WHERE modelos LIKE "_es"; ----> La barra baja busca un caracterg

SELECT * FROM modelos WHERE modelos LIKE "%es_a"; --Se pueden convinar

update nombre_usuario set nombre_usuario="Roberto" WHERE dni="x16516848" --Cambiamos el campo nombre_usuario donde el DNI sea el que indicamos



-------------------DOLAR, CEDILLA, SUM, MIN-----------------------------------------

SELECT nombre FROM Usuarios WHERE nombre RLIKE ^[A-B];--       ^-empieza,  $-termINa
SELECT MIN(km) FROM compra;
SELECT MAX(km) FROM compra;
SELECT SUM(km) FROM compra;
SELECT AVG(km) FROM comrpa;




---------------- GROUP BY ---------------> si hacemos la media de los precios de todos los coches, con GROUP BY podemos ordenarlos por marcas y veremos la media por cada marca!

SELECT AVG(precio_compra), usuario FROM compra GROUP BY usuario; --Me va a agrupar por cada usuario distinto

SELECT avg(precio_compra) AS precio_medio, usuario FROM compra GROUP BY usuario; -- AS para renombrar la columna como queramos

SELECT * FROM usuarios, compra WHERE usuarios.id = compra.usuario LIMIT 300; --Igualamos para quitar los falsos positivos

SELECT avg(precio_compra) AS precio_medio, marca FROM vehiculos, compra WHERE vehiculos.id = compra.vehiculo GROUP BY marca; 

SELECT * FROM compra HAVING km > 300;

SELECT * FROM compra HAVING km BETWEEN 300 AND 500;

SELECT * FROM usuarios, compra WHERE usuarios.id = compra.usuario GROUP BY YEAR(fecha_compra) HAVING SUM(precio_compra) > 20000 LIMIT 5; --Having para GROUP BY, ademas utilizamos la funcion YEAR, tambien existe DAY, HOUR, MONTH, etc...

SELECT usuario, SUM(precio_compra) as total, year(fecha_compra) FROM compra GROUP BY usuario, year(fecha_compra) HAVING total > 20000 ORDER BY usuario,total LIMIT 10; --El group by puede ser de varios

SELECT * FROM usuarios GROUP BY nombre, year(fecha_registro);

SELECT count(nombre), nombre, year(fecha_registro) AS año FROM usuarios GROUP BY nombre, year(fecha_registro) ORDER BY 1 DESC LIMIT 20; --Orden DESC, tambien se puede ASC

SELECT * FROM usuarios WHERE fecha_registro >=(SELECT fecha_registro AS limite FROM usuarios WHERE id = 300); ------> SUB consulta!

SELECT * FROM compra WHERE precio_compra <= (SELECT MIN(precio_compra) FROM compra, vehiculos WHERE vehiculos.id=compra.vehiculo AND marca="BMW");

SELECT nombre, email FROM usuarios, compra WHERE compra.usuario = usuarios.id AND vehiculo IN (SELECT vehiculos.id FROM vehiculos, compra WHERE vehiculos.id = compra.vehiculo AND usuario = (SELECT id FROM usuarios WHERE email = "aleebh@google.cn"));

SELECT nombre, email FROM usuarios, vehiculos, compra WHERE compra.usuario = usuarios.id  AND compra.vehiculo = vehiculos.id AND marca IN (SELECT vehiculos.marca FROM vehiculos, compra WHERE vehiculos.id = compra.vehiculo AND usuario = (SELECT id FROM usuarios WHERE email = "aleebh@google.cn"));



-------- IN, NOT IN ---------------> IN/IN es equivalente a 'que contenga ..' ejemplo :     marca IN (Samsung, Hauwei, Nokia)----> devuelve las marcas que  contengas los siguientes nombres

SELECT * FROM usuarios JOIN compra ON usuarios.id = compra.usuario; --Unimos tablas

SELECT * FROM usuarios LEFT JOIN compra ON id = usuario;

SELECT * FROM usuarios WHERE usuarios.id > ALL (SELECT vehiculos.id FROM vehiculos);

SELECT * FROM usuarios WHERE usuarios.id > ANY (SELECT vehiculos.id FROM vehiculos); ---> ANY = SOME

create VIEW Mi_Consulta AS SELECT * FROM usuarios LEFT JOIN compra ON id = usuario; -----> Crea un resultado en forma de tabla, asi no tenemos que escribir la consulta larga;


--APUTNES SUELTOS-------------------------------------------------------------

-- para crear una tabla temporal:
CREATE TEMPORARY TABLE vendedores AS (SELECT * FROM consultas.usuarios WHERE nombre LIKE 'j%' or nombre LIKE '%a');

-- para cambiar datos de toda la tabla:
UPDATE vendedores SET id=2020;

-- hacer un union, unir las dos tablas:
SELECT * FROM vendedores UNION SELECT * FROM usuarios;

SELECT * FROM participantes UNION SELECT * FROM participantes_reserva; --Sumamos las dos tablas

-- Utilizando exists
SELECT * FROM usuarios WHERE exists (SELECT usuario, SUM(precio_compra) AS precio_total FROM compra WHERE id=usuario GROUP BY usuario HAVING precio_total > 70000);

-- ROWS solo lee las filas que nosotros le digamos
SELECT * FROM usuarios LIMIT rows examINed 100;

-- Exportamos la consulta a un fichero externo
SELECT title, SUM(rental_rate*DATEDIFF(return_date, rental_date)) FROM rental, inventory, film WHERE inventory.film_id = film.film_id AND rental.inventory_id = inventory.inventory_id GROUP BY title ORDER BY 2 DESC LIMIT 50 INTO OUTFILE 'C:\Users\eduar\Desktop' FIELDS TERMINATED BY ';';

-- Restamos la diferencia entre dos columnas de tipo fecha
    SELECT AVG(DATEDIFF(return_date, rental_date)) AS promedio_alquiler FROM rental GROUP BY inventory_id ORDER BY 1 DESC;

-- Podemos multiplicar datos de columnas:
SELECT SUM(rental_rate*DATEDIFF(return_date, rental_date)) FROM rental, inventory, film WHERE inventory.film_id = film.film_id AND rental.inventory_id = inventory.inventory_id AND title LIKE 'ACADEMY%';

-- Mostramos donde el campo indicado sea null, IS NULL != '':
SELECT * FROM address WHERE address2 IS NULL;
