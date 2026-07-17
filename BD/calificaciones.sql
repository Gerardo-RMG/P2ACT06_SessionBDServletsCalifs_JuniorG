
CREATE TABLE `alumnos` (
  `matricula` varchar (20)  NOT NULL,
  `nombre`    varchar (100) NOT NULL,
  `paterno`   varchar (100) NOT NULL,
  `materno`   varchar (100) DEFAULT '',
  `correo`    varchar (150) DEFAULT NULL,
  `clave` varchar (100) DEFAULT NULL,
  `validar` tinyint (1) NOT NULL DEFAULT 0,
  `status` varchar (20) NOT NULL DEFAULT 'pendiente',
  `fecha_registro` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `alumnos`
--

INSERT INTO `alumnos` (`matricula`, `nombre`, `paterno`, `materno`, `correo`, `clave`, `validar`, `status`, `fecha_registro`) VALUES
('57191900150_i', 'Junior Gerardo ', 'Ramirez', 'Galindo', '57191900150_i@utrng.edu.mx', '030920qwer', 1, 'pendiente', '2026-07-14 16:26:56'),
('57221900108_i', 'Marco Antonio', 'De Aquino', 'Vargas', '57221900108_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('572319000104_i', 'Axel Andres', 'Trinidad', 'Jimenez', '572319000104_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900067_i', 'Mario', 'Cuevas', 'Garcia', '57231900067_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900069_i', 'Emmanuel', 'Flores', 'Esteban', '57231900069_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900070_i', 'Vicente Tadeo', 'Gabriel', 'Gonzalez', '57231900070_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900072_i', 'Isai', 'Gutierrez', 'Zamudio', '57231900072_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900075_i', 'Victor', 'Jaimes', 'Vazquez', '57231900075_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900076_i', 'Rosalinda', 'Moreno', 'Hernandez', '57231900076_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900081_i', 'Iris Gabriela', 'Torres', 'Diaz', '57231900081_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900086_i', 'Paola Yareni', 'Bello', 'Calixto', '57231900086_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900095_i', 'Deyanira', 'Pascualeño', 'Tlacotempa', '57231900095_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900096_i', 'Axel Uriel', 'Ramos', 'Lopez', '57231900096_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900099_i', 'Alma Delia', 'Sanchez', 'Juarez', '57231900099_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900100_i', 'Alex Javier', 'Santos', 'Nava', '57231900100_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900101_i', 'Francisco Javier', 'Silverio', 'Cuesta', '57231900101_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28'),
('57231900102_i', 'Jessica Edith', 'Torito', 'Casarrubias', '57231900102_i@utrng.edu.mx', NULL, 0, 'pendiente', '2026-07-15 08:02:28');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificaciones`
--

CREATE TABLE `calificaciones` (
  `id` int(11) NOT NULL,
  `matricula` varchar(20) NOT NULL,
  `materia_clave` varchar(20) NOT NULL,
  `p1` double NOT NULL DEFAULT 0,
  `p2` double NOT NULL DEFAULT 0,
  `p3` double NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `calificaciones`
--

INSERT INTO `calificaciones` (`id`, `matricula`, `materia_clave`, `p1`, `p2`, `p3`) VALUES
(64, '57191900150_i', '001', 9, 9, 8),
(65, '57191900150_i', '002', 9, 8, 8.1),
(66, '572319000104_i', '001', 10, 9, 10),
(67, '572319000104_i', '002', 9, 9, 10),
(68, '57231900067_i', '001', 10, 9, 10),
(69, '57231900067_i', '002', 9, 9, 10),
(70, '57231900069_i', '001', 10, 9, 10),
(71, '57231900069_i', '002', 10, 9, 10),
(72, '57231900070_i', '001', 10, 9, 10),
(73, '57231900070_i', '002', 9, 10, 8),
(74, '57231900072_i', '001', 10, 9, 10),
(75, '57231900072_i', '002', 9, 10, 8),
(76, '57231900075_i', '001', 10, 9, 10),
(77, '57231900075_i', '002', 10, 9, 8),
(78, '57231900076_i', '001', 10, 9, 10),
(79, '57231900076_i', '002', 10, 10, 8),
(80, '57231900081_i', '001', 10, 9, 10),
(81, '57231900081_i', '002', 9, 9, 8),
(82, '57231900086_i', '001', 9, 9, 9),
(83, '57231900086_i', '002', 10, 9, 9),
(84, '57231900095_i', '001', 10, 9, 10),
(85, '57231900095_i', '002', 10, 10, 10),
(86, '57231900096_i', '001', 10, 9, 10),
(87, '57231900096_i', '002', 9, 9, 9),
(88, '57231900099_i', '001', 10, 9, 10),
(89, '57231900099_i', '002', 9, 9, 8),
(90, '57231900100_i', '001', 10, 9, 10),
(91, '57231900100_i', '002', 9, 9, 8),
(92, '57231900101_i', '001', 10, 9, 10),
(93, '57231900101_i', '002', 10, 9, 8),
(94, '57231900102_i', '001', 10, 9, 10),
(95, '57231900102_i', '002', 9, 9, 8),
(96, '57221900108_i', '001', 10, 9, 10),
(97, '57221900108_i', '002', 10, 9, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materias`
--

CREATE TABLE `materias` (
  `clave` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `materias`
--

INSERT INTO `materias` (`clave`, `nombre`) VALUES
('001', 'Desarrollo Web Integral'),
('002', 'Desarrollo para Dispositivos Inteligentes');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `usuario` varchar(50) NOT NULL,
  `clave` varchar(100) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `validar` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(20) NOT NULL DEFAULT 'pendiente',
  `es_admin` tinyint(1) NOT NULL DEFAULT 0,
  `fecha_registro` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`usuario`, `clave`, `nombre`, `correo`, `validar`, `status`, `es_admin`, `fecha_registro`) VALUES
('GerardoRamirez', '030920Admon', 'Administrador', 'juniorgerardoramirez@gmail.com', 1, 'activo', 1, '2026-07-13 17:35:01');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alumnos`
--
ALTER TABLE `alumnos`
  ADD PRIMARY KEY (`matricula`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_alumno_materia` (`matricula`,`materia_clave`),
  ADD KEY `fk_calif_materia` (`materia_clave`);

--
-- Indices de la tabla `materias`
--
ALTER TABLE `materias`
  ADD PRIMARY KEY (`clave`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`usuario`),
  ADD UNIQUE KEY `uq_usuarios_correo` (`correo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD CONSTRAINT `fk_calif_alumno` FOREIGN KEY (`matricula`) REFERENCES `alumnos` (`matricula`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_calif_materia` FOREIGN KEY (`materia_clave`) REFERENCES `materias` (`clave`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
