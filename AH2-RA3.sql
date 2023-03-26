CREATE DATABASE biblioteca;

USE biblioteca;

CREATE TABLE autores (
  id_autor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50),
  apellido VARCHAR(50),
  nacionalidad VARCHAR(50)
);

CREATE TABLE libros (
  id_libro INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100),
  id_autor INT,
  genero VARCHAR(50),
  editorial VARCHAR(50),
  fecha_publicacion DATE,
  cantidad_disponible INT,
  FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

CREATE TABLE miembros (
  id_miembro INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50),
  apellido VARCHAR(50),
  direccion VARCHAR(100),
  telefono VARCHAR(20),
  fecha_nacimiento DATE
);

CREATE TABLE prestamos (
  id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
  id_miembro INT,
  id_libro INT,
  fecha_prestamo DATE,
  fecha_devolucion DATE,
  devuelto BOOLEAN,
  FOREIGN KEY (id_miembro) REFERENCES miembros(id_miembro),
  FOREIGN KEY (id_libro) REFERENCES libros(id_libro)
);



USE biblioteca;

INSERT INTO autores (nombre, apellido, nacionalidad) VALUES
('Gabriel', 'García Márquez', 'Colombiano'),
('Mario', 'Vargas Llosa', 'Peruano'),
('Isabel', 'Allende', 'Chilena'),
('Julio', 'Cortázar', 'Argentino'),
('Pablo', 'Neruda', 'Chileno');

-- Añadir 10 libros con su información correspondiente, relacionándolos con los autores.
INSERT INTO libros (titulo, id_autor, genero, editorial, fecha_publicacion, cantidad_disponible) VALUES
('Cien años de soledad', 1, 'Realismo mágico', 'Sudamericana', '1967-05-30', 3),
('La ciudad y los perros', 2, 'Novela', 'Seix Barral', '1963-10-30', 2),
('La casa de los espíritus', 3, 'Realismo mágico', 'Plaza & Janés', '1982-01-01', 4),
('Rayuela', 4, 'Novela', 'Sudamericana', '1963-06-28', 1),
('Veinte poemas de amor y una canción desesperada', 5, 'Poesía', 'Universitaria', '1924-08-15', 5),
('Crónica de una muerte anunciada', 1, 'Realismo mágico', 'Sudamericana', '1981-05-07', 2),
('La fiesta del chivo', 2, 'Novela histórica', 'Santillana Ediciones Generales', '2000-01-01', 1),
('Paula', 3, 'Autobiografía', 'Plaza & Janés', '1994-01-01', 3),
('Canto general', 5, 'Poesía', 'Universitaria', '1950-01-01', 2),
('Bestiario', 4, 'Cuento', 'Sudamericana', '1951-01-01', 2);

-- Añadir 3 miembros con su información correspondiente.
INSERT INTO miembros (nombre, apellido, direccion, telefono, fecha_nacimiento) VALUES
('Juan', 'Pérez', 'Calle 10 # 20-30', '1234567890', '1995-03-15'),
('María', 'García', 'Calle 5 # 15-25', '0987654321', '1998-07-20'),
('Pedro', 'Rodríguez', 'Carrera 7 # 12-30', '5555555', '1990-12-31');

-- Registrar 2 préstamos de libros a miembros.
INSERT INTO prestamos (id_miembro, id_libro, fecha_prestamo, fecha_devolucion, devuelto) VALUES
(1, 2, '2023-03-22', NULL, 0),
(2, 5, '2023-03-23', NULL, 0);



/* 2.Modificar datos existentes en las tablas dela base de datos: */
USE biblioteca;

UPDATE miembros SET direccion = 'Nueva dirección', telefono = 'Nuevo teléfono' WHERE id_miembro = 1;

UPDATE libros SET cantidad_disponible = cantidad_disponible - 1 WHERE id_libro = 1;

/*
3.Eliminar registros de acuerdo con criterios establecidos:
•Eliminar un autor que no tenga libros asociados.
•Eliminar un miembro que no tenga préstamos registrados.
*/
USE biblioteca;

DELETE FROM autores WHERE id_autor = 1 AND NOT EXISTS (SELECT id_libro FROM libros WHERE id_autor = 1);


DELETE FROM miembros WHERE id_miembro = 1 AND NOT EXISTS (SELECT id_prestamo FROM prestamos WHERE id_miembro = 1);


/*
4.Buscar y mostrar registros de acuerdo con criterios establecidos:
•Encontrar todos los libros de un género específico.
•Encontrar todos los miembros que tengan entre 18 y 25 años.
•Mostrar todos los préstamos que no hayan sido devueltos.
*/
USE biblioteca;
SELECT * FROM libros WHERE genero = 'ciencia ficción';

SELECT * FROM miembros WHERE fecha_nacimiento BETWEEN '2003-03-25' AND '2010-03-25';

SELECT * FROM prestamos WHERE devuelto = FALSE;


/*
5.Mostrar datos por medio de consultas avanzadas y subconsultas:
•Mostrar los 3 libros más prestados.
*/

SELECT libros.titulo, COUNT(prestamos.id_libro) AS num_prestamos
FROM libros
INNER JOIN prestamos ON libros.id_libro = prestamos.id_libro
WHERE prestamos.devuelto = false
GROUP BY libros.id_libro
ORDER BY num_prestamos DESC
LIMIT 3;
