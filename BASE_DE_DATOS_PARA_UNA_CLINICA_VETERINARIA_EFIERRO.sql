/*************************************************************
 EVALUACIÓN FINAL MÓDULO 3: BASE DE DATOS CLÍNICA VETERINARIA
 Alumno: EDUARDO FIERRO DUQUE 05_03_26
 *************************************************************/

-- 1. CREACIÓN DE LA ESTRUCTURA
-- Creamos las tablas con IF NOT EXISTS para evitar errores de duplicidad.
-- Usamos SERIAL para que PostgreSQL gestione los IDs automáticamente.

CREATE TABLE IF NOT EXISTS Dueno (
    id_dueno SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    direccion VARCHAR(200),
    telefono VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Profesional (
    id_profesional SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Mascota (
    id_mascota SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    tipo VARCHAR(50), 
    fecha_nacimiento DATE,
    id_dueno INT,
    CONSTRAINT fk_dueno FOREIGN KEY (id_dueno) REFERENCES Dueno(id_dueno)
);

CREATE TABLE IF NOT EXISTS Atencion (
    id_atencion SERIAL PRIMARY KEY,
    fecha_atencion DATE,
    descripcion TEXT,
    id_mascota INT,
    id_profesional INT,
    CONSTRAINT fk_mascota FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota),
    CONSTRAINT fk_profesional FOREIGN KEY (id_profesional) REFERENCES Profesional(id_profesional)
);

-- 2. CARGA DE DATOS INICIALES
INSERT INTO Dueno (nombre, direccion, telefono) VALUES
('Juan Pérez', 'Calle Falsa 123', '555-1234'),
('Ana Gómez', 'Avenida Siempre Viva 456', '555-5678'),
('Carlos Ruiz', 'Calle 8 de Octubre 789', '555-8765')
ON CONFLICT DO NOTHING;

INSERT INTO Mascota (nombre, tipo, fecha_nacimiento, id_dueno) VALUES
('Rex', 'Perro', '2020-05-10', 1),
('Luna', 'Gato', '2019-02-20', 2),
('Fido', 'Perro', '2021-03-15', 3)
ON CONFLICT DO NOTHING;

INSERT INTO Profesional (nombre, especialidad) VALUES
('Dr. Martínez', 'Veterinario'),
('Dr. Pérez', 'Especialista en dermatología'),
('Dr. López', 'Cardiólogo veterinario')
ON CONFLICT DO NOTHING;

INSERT INTO Atencion (fecha_atencion, descripcion, id_mascota, id_profesional) VALUES
('2025-03-01', 'Chequeo general', 1, 1),
('2025-03-05', 'Tratamiento dermatológico', 2, 2),
('2025-03-07', 'Consulta cardiológica', 3, 3)
ON CONFLICT DO NOTHING;

-- 3. CONSULTAS DE EVALUACIÓN

-- Consultar dueños y sus mascotas
SELECT d.nombre AS Dueno, m.nombre AS Mascota FROM Dueno d JOIN Mascota m ON d.id_dueno = m.id_dueno;

-- Consultar atenciones con detalle del profesional
SELECT a.fecha_atencion, m.nombre AS Mascota, p.nombre AS Profesional, a.descripcion 
FROM Atencion a 
JOIN Mascota m ON a.id_mascota = m.id_mascota 
JOIN Profesional p ON a.id_profesional = p.id_profesional;

-- Contar atenciones por profesional
SELECT p.nombre, COUNT(a.id_atencion) AS total FROM Profesional p LEFT JOIN Atencion a ON p.id_profesional = a.id_profesional GROUP BY p.nombre;

-- Actualizar dirección y eliminar una atención
UPDATE Dueno SET direccion = 'Nueva Dirección 2026' WHERE nombre = 'Juan Pérez';
DELETE FROM Atencion WHERE id_atencion = 2;

-- 4. TRANSACCIÓN FINAL
BEGIN;
    INSERT INTO Mascota (nombre, tipo, fecha_nacimiento, id_dueno) VALUES ('Sasha', 'Gato', '2022-01-10', 3);
    INSERT INTO Atencion (fecha_atencion, descripcion, id_mascota, id_profesional) VALUES (CURRENT_DATE, 'Vacuna', (SELECT MAX(id_mascota) FROM Mascota), 1);
    UPDATE Dueno SET telefono = '555-0000' WHERE id_dueno = 3;
COMMIT;