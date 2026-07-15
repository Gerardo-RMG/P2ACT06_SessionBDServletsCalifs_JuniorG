-- Base de datos para P2ACT06_SessionBDServletsCalifs_JuniorG
-- Se usa una base propia (calificaciones) para no alterar el esquema
-- de db_registros que usa el proyecto 003_Ejemplo_Form_Servlet.

CREATE DATABASE IF NOT EXISTS calificaciones
    CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE calificaciones;

-- --------------------------------------------------------
-- usuarios: cuentas de acceso a la app.
--   validar -> 1 cuando el correo fue confirmado con el código enviado
--   status  -> pendiente | activo | rechazado, lo decide el profesor (admin)
--   Solo los usuarios con es_admin = 1 pueden iniciar sesión en la app.
-- --------------------------------------------------------
CREATE TABLE usuarios (
    usuario        VARCHAR(50)  NOT NULL,
    clave          VARCHAR(100) NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    correo         VARCHAR(150) NOT NULL,
    validar        TINYINT(1)   NOT NULL DEFAULT 0,
    status         VARCHAR(20)  NOT NULL DEFAULT 'pendiente',
    es_admin       TINYINT(1)   NOT NULL DEFAULT 0,
    fecha_registro DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usuario),
    UNIQUE KEY uq_usuarios_correo (correo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- alumnos: roster de estudiantes (independiente de la tabla usuarios/login).
--   correo/clave son opcionales, capturados desde el panel de administrador
--   (correo institucional @utrng.edu.mx obligatorio para poder validarlo).
--   validar -> 1 cuando ese correo fue confirmado con el código de verificación.
--   status  -> pendiente | activo | rechazado, lo decide el profesor (admin).
-- --------------------------------------------------------
CREATE TABLE alumnos (
    matricula      VARCHAR(20)  NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    paterno        VARCHAR(100) NOT NULL,
    materno        VARCHAR(100) DEFAULT '',
    correo         VARCHAR(150) DEFAULT NULL,
    clave          VARCHAR(100) DEFAULT NULL,
    validar        TINYINT(1)   NOT NULL DEFAULT 0,
    status         VARCHAR(20)  NOT NULL DEFAULT 'pendiente',
    fecha_registro DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (matricula),
    UNIQUE KEY uq_alumnos_correo (correo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- materias
-- --------------------------------------------------------
CREATE TABLE materias (
    clave  VARCHAR(20)  NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY (clave)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- calificaciones: una fila por cada combinación alumno-materia
-- --------------------------------------------------------
CREATE TABLE calificaciones (
    id            INT AUTO_INCREMENT,
    matricula     VARCHAR(20) NOT NULL,
    materia_clave VARCHAR(20) NOT NULL,
    p1            DOUBLE NOT NULL DEFAULT 0,
    p2            DOUBLE NOT NULL DEFAULT 0,
    p3            DOUBLE NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uq_alumno_materia (matricula, materia_clave),
    CONSTRAINT fk_calif_alumno  FOREIGN KEY (matricula)     REFERENCES alumnos(matricula)   ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_calif_materia FOREIGN KEY (materia_clave) REFERENCES materias(clave)       ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Datos iniciales
-- --------------------------------------------------------

-- Único usuario con acceso: el profesor / administrador
INSERT INTO usuarios (usuario, clave, nombre, correo, validar, status, es_admin) VALUES
('GerardoRamirez', '030920Admon', 'Administrador', 'juniorgerardoramirez@gmail.com', 1, 'activo', 1);

-- 17 alumnos
INSERT INTO alumnos (matricula, nombre, paterno, materno) VALUES
('A001', 'Juan',      'Pérez',      'López'),
('A002', 'María',     'López',      'García'),
('A003', 'Carlos',    'Hernández',  'Martínez'),
('A004', 'Ana',       'Martínez',   'Rodríguez'),
('A005', 'Luis',      'Gómez',      'Sánchez'),
('A006', 'Sofía',     'Ramírez',    'Cruz'),
('A007', 'Diego',     'Torres',     'Flores'),
('A008', 'Valeria',   'Flores',     'Gómez'),
('A009', 'Miguel',    'Díaz',       'Reyes'),
('A010', 'Fernanda',  'Reyes',      'Morales'),
('A011', 'Jorge',     'Morales',    'Ortiz'),
('A012', 'Camila',    'Ortiz',      'Jiménez'),
('A013', 'Andrés',    'Jiménez',    'Vargas'),
('A014', 'Paola',     'Vargas',     'Castillo'),
('A015', 'Ricardo',   'Castillo',   'Rojas'),
('A016', 'Daniela',   'Rojas',      'Mendoza'),
('A017', 'Emilio',    'Mendoza',    'Silva');

-- 2 materias
INSERT INTO materias (clave, nombre) VALUES
('MAT01', 'Matemáticas'),
('FIS01', 'Física');

-- Genera automáticamente las 34 calificaciones iniciales (17 alumnos x 2 materias),
-- lo mismo que hace el botón "Generar Calificaciones" del panel de administrador.
INSERT INTO calificaciones (matricula, materia_clave, p1, p2, p3)
SELECT a.matricula, m.clave, 0, 0, 0
FROM alumnos a
CROSS JOIN materias m;
