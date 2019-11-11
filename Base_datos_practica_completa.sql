CREATE DATABASE exasaql1;
CREATE TABLE libros(
    id INT(6) unsigned AUTO_INCREMENT PRIMARY KEY NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    auto VARCHAR(100) NOT NULL,
    precio DECIMAL(2) NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;
----------------------------------------------------------------

CREATE TABLE sede(
    id SMALLINT(3) unsigned AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Nombre VARCHAR(100)  NOT NULL,
    Direccion VARCHAR(100)  NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;


CREATE INDEX idx_sede ON sede(nombre);

SHOW INDEX FROM sede;

----------------------------------------------------------------


CREATE TABLE sede_libro(
    num_ejemplares SMALLINT(3) unsigned NOT NULL,
    id_sede SMALLINT(3) unsigned NOT NULL,
    id_libro INT(6) unsigned NOT NULL,
    CONSTRAINT pk_sede_libro PRIMARY KEY (id_sede,id_libro)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

ALTER TABLE sede_libro ADD CONSTRAINT FOREIGN KEY (id_sede) REFERENCES sede(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE sede_libro ADD CONSTRAINT FOREIGN KEY (id_libro) REFERENCES libros(id) ON UPDATE CASCADE ON DELETE CASCADE;

---------------------------------------------------------------------

CREATE TABLE usuarios(
    id INT(6) unsigned AUTO_INCREMENT PRIMARY KEY NOT NULL,
    email VARCHAR(50) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-------------------------------------------------------------------------

CREATE TABLE prestamo(
    usu INT(6) unsigned NOT NULL,
    book INT(6) NOT NULL,
    biblio SMALLINT(3) NOT NULL,
    fecha_prestamo TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_fin_prestamo TIMESTAMP NULL,
    CONSTRAINT pk_prestamo PRIMARY KEY (usu,book,biblio,fecha_prestamo)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

ALTER TABLE prestamo ADD CONSTRAINT FOREIGN KEY (book, biblio) REFERENCES sede_libro(sede, libro) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE prestamo ADD CONSTRAINT FOREIGN KEY (usu) REFERENCES usuario(id) ON UPDATE CASCADE ON DELETE CASCADE;

-------------------------------------------------------------

LOAD DATA INFILE 'C:/exaSQL/Libros.txt' INTO TABLE libros FIELDS TERMINATED BY '*' LINES TERMINATED BY '-' ( titulo, auto, precio);
LOAD DATA INFILE 'C:/exaSQL/Sede_biblio.csv' IGNORE INTO TABLE sede_libro FIELDS TERMINATED BY ';' ( id_sede, id_libro, num_ejemplares);
LOAD DATA INFILE 'C:/exaSQL/Sedes.txt' INTO TABLE sede FIELDS TERMINATED BY '$%$' LINES TERMINATED BY '#' ( nombre, direccion);
LOAD DATA INFILE 'C:/exaSQL/Usuarios.csv' INTO TABLE usuarios FIELDS TERMINATED BY ';' ( nombre, email, fecha_registro);
LOAD DATA INFILE 'C:/exaSQL/Prestamo.csv' IGNORE INTO TABLE prestamo FIELDS TERMINATED BY ';' ( biblio, book, usu, fecha_prestamo, fecha_fin_prestamo);

---------------------------------------------------------------------------

CREATE ROLE bibliotecario;
GRANT SELECT, INSERT, UPDATE ON exasaql1.libros TO bibliotecario;
GRANT SELECT, INSERT, UPDATE ON exasaql1.prestamo TO bibliotecario;
FLUSH PRIVILEGES;
SELECT user FROM mysql.user;

-----------------------------------------------------

CREATE USER 'Arnold'@'%' IDENTIFIED BY '1234';
SET DEFAULT ROLE bibliotecario FOR 'Arnold'@'%';
FLUSH PRIVILEGES;
GRANT USAGE ON *.* TO 'Arnold'@'%' WITH MAX_QUERIES_PER_HOUR 5 MAX_CONNECTIONS_PER_HOUR 3;

--------------------------------------------------------

CREATE USER 'admin'@'localhost' IDENTIFIED BY PASSWORD '*B01459247E9E39BA8F5C260977D5C515BAA1D2F4';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;

----------------------------------------------------------
--SAKILA
SELECT title FROM film_list WHERE category LIKE (SELECT category FROM film_list WHERE title LIKE 'Arizona Bang');

SELECT COUNT(rental_id) FROM rental WHERE return_date BETWEEN '2005-05-01 00:00:00' AND '2005-05-30 23:59:59';

SELECT inventory_id in(SELECT FID FROM film_list WHERE title LIKE "C_n%")

SELECT inventory_id, store_id, title FROM inventory, film_list WHERE film_id = FID AND title LIKE "C_n%" ORDER BY 1;--order by 1 = order by inventory id;

SELECT COUNT(rental_id) AS veces_alquilado, inventory_id FROM rental GROUP BY inventory_id HAVING COUNT(rental_id) > 3;

---------------------------------------------------------------------
--exasaql1

SELECT titulo FROM libros WHERE id IN (SELECT book FROM prestamo WHERE fecha_prestamo BETWEEN '2018-01-01 00:00:00' AND '2018-12-31 23:59:59' AND biblio IN (SELECT id FROM sede WHERE nombre LIKE 'ALPHA'));



SELECT titulo FROM libros WHERE id NOT IN (SELECT book FROM prestamo WHERE YEAR(fecha_prestamo) = '2018');

SELECT titulo, book, COUNT(*) AS leido FROM prestamo,libros WHERE libros.id = prestamo.book GROUP BY book ORDER BY leido LIMIT 10;

SELECT nombre, COUNT(fecha_prestamo) AS sacado FROM usuarios,prestamo WHERE prestamo.usu = usuarios.id WHERE sacado> AVG(fecha_prestamo) GROUP BY usuarios.nombre ORDER BY nombre;
