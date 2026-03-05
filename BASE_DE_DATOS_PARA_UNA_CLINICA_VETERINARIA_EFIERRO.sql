/******************************************************************
 EVALUACIÓN FINAL MÓDULO 3: BASE DE DATOS CLÍNICA VETERINARIA
 Alumno: EDUARDO FIERRO DUQUE
 Fecha: 05-03-2026
 ******************************************************************/

-- Limpieza previa para permitir re-ejecución (Opcional, muy útil para pruebas)
DROP TABLE IF EXISTS Atencion;
DROP TABLE IF EXISTS Mascota;
DROP TABLE IF EXISTS Profesional;
DROP TABLE IF EXISTS Dueno;

-- 1. CREACIÓN DE TABLAS CON INTEGRIDAD REFERENCIAL
CREATE TABLE Dueno (
    id_dueno SERIAL PRIMARY KEY, -- SERIAL equivale a INT + AUTO_INCREMENT en Postgres
    nombre VARCHAR(100),
    direccion VARCHAR(200),
    telefono VARCHAR(20)
);

CREATE TABLE Profesional (
    id_profesional SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100)
);

CREATE TABLE Mascota (
    id_mascota SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    tipo VARCHAR(50), 
    fecha_nacimiento DATE,
    id_dueno INT,
    CONSTRAINT fk_dueno FOREIGN KEY (id_dueno) REFERENCES Dueno(id_dueno)
);

CREATE TABLE Atencion (
    id_atencion SERIAL PRIMARY KEY,
    fecha_atencion DATE,
    descripcion TEXT,
    id_mascota INT,
    id_profesional INT,
    CONSTRAINT fk_mascota FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota),
    CONSTRAINT fk_profesional FOREIGN KEY (id_profesional) REFERENCES Profesional(id_profesional)
);

-- 2. INSERCIÓN DE DATOS SEGÚN INSTRUCCIONES
INSERT INTO Dueno (id_dueno, nombre, direccion, telefono) VALUES
(1, 'Juan Pérez', 'Calle Falsa 123', '555-1234'),
(2, 'Ana Gómez', 'Avenida Siempre Viva 456', '555-5678'),
(3, 'Carlos Ruiz', 'Calle 8 de Octubre 789', '555-8765');

INSERT INTO Mascota (id_mascota, nombre, tipo, fecha_nacimiento, id_dueno) VALUES
(1, 'Rex', 'Perro', '2020-05-10', 1),
(2, 'Luna', 'Gato', '2019-02-20', 2),
(3, 'Fido', 'Perro', '2021-03-15', 3);

INSERT INTO Profesional (id_profesional, nombre, especialidad) VALUES
(1, 'Dr. Martínez', 'Veterinario'),
(2, 'Dr. Pérez', 'Especialista en dermatología'),
(3, 'Dr. López', 'Cardiólogo veterinario');

INSERT INTO Atencion (id_atencion, fecha_atencion, descripcion, id_mascota, id_profesional) VALUES
(1, '2025-03-01', 'Chequeo general', 1, 1),
(2, '2025-03-05', 'Tratamiento dermatológico', 2, 2),
(3, '2025-03-07', 'Consulta cardiológica', 3, 3);

-- Resetear los contadores de SERIAL para que las nuevas inserciones no choquen
SELECT setval('dueno_id_dueno_seq', (SELECT MAX(id_dueno) FROM Dueno));
SELECT setval('mascota_id_mascota_seq', (SELECT MAX(id_mascota) FROM Mascota));
SELECT setval('atencion_id_atencion_seq', (SELECT MAX(id_atencion) FROM Atencion));

-- 3. CONSULTAS REQUERIDAS

-- A. Obtener todos los dueños y sus mascotas
SELECT d.nombre AS Dueno, m.nombre AS Mascota 
FROM Dueno d 
JOIN Mascota m ON d.id_dueno = m.id_dueno;

-- B. Atenciones realizadas con detalles del profesional
SELECT a.fecha_atencion, m.nombre AS Mascota, p.nombre AS Profesional, a.descripcion 
FROM Atencion a 
JOIN Mascota m ON a.id_mascota = m.id_mascota 
JOIN Profesional p ON a.id_profesional = p.id_profesional;

-- C. Conteo de atenciones por profesional (Funciones de Agregación)
SELECT p.nombre, COUNT(a.id_atencion) AS total_atenciones 
FROM Profesional p 
LEFT JOIN Atencion a ON p.id_profesional = a.id_profesional 
GROUP BY p.nombre;

-- D. Actualización y Eliminación
UPDATE Dueno SET direccion = 'Nueva Dirección 2026' WHERE nombre = 'Juan Pérez';
DELETE FROM Atencion WHERE id_atencion = 2;

-- 4. TRANSACCIÓN PARA NUEVA MASCOTA Y ATENCIÓN
BEGIN;
    INSERT INTO Mascota (nombre, tipo, fecha_nacimiento, id_dueno) 
    VALUES ('Sasha', 'Gato', '2022-01-10', 3);

    INSERT INTO Atencion (fecha_atencion, descripcion, id_mascota, id_profesional)
    VALUES (CURRENT_DATE, 'Vacunación de rutina', (SELECT MAX(id_mascota) FROM Mascota), 1);

    UPDATE Dueno SET telefono = '555-9999' WHERE id_dueno = 3;
COMMIT;
