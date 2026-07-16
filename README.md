# P2ACT06_SessionBDServletsCalifs_JuniorG

Sistema de calificaciones construido con **Java (Servlets + JSP)**, **sesiones HTTP** y
**MySQL** como base de datos. Incluye registro con verificación de correo por código,
un panel de administrador para aprobar solicitudes y captura de calificaciones, y
alta de alumnos con validación de correo institucional.

## Requisitos

- JDK 17 o superior
- Apache Tomcat 10+ (Jakarta EE, paquete `jakarta.servlet.*`)
- MySQL 8+ (o compatible) corriendo en `localhost:3306`
- NetBeans (opcional, el proyecto ya trae `build.xml` y `nbproject/`)

> Nota: este entorno no tiene un servidor Tomcat/MySQL corriendo, por lo que el
> proyecto no pudo ejecutarse ni probarse aquí. Instala los requisitos y sigue los
> pasos de abajo para levantarlo.

## Base de datos

```bash
mysql -u root -p < BD/db_calificaciones.sql
```

Esto crea la base `calificaciones` con las tablas `usuarios`, `alumnos`, `materias`
y `calificaciones`, más el usuario administrador y datos iniciales (17 alumnos,
2 materias). Ajusta usuario/clave en `src/java/conexion/ConexionMySQL.java` si tu
MySQL no usa `root` sin contraseña.

## Instalación y ejecución

```bash
cd P2ACT06_SessionBDServletsCalifs_JuniorG
ant build
ant deploy
```

O bien abre el proyecto en NetBeans y usa **Run** (requiere el servidor Tomcat
registrado en el IDE). Luego abre [http://localhost:8080/P2ACT06_SessionBDServletsCalifs_JuniorG](http://localhost:8080/P2ACT06_SessionBDServletsCalifs_JuniorG)
en tu navegador.

## Flujo de la aplicación

| Página / Servlet          | Contenido                                                    |
|----------------------------|---------------------------------------------------------------|
| `Servlet_Login`             | Inicio de sesión (también página de bienvenida por defecto)  |
| `Servlet_Registro`          | Solicitud de cuenta de usuario, valida usuario/correo únicos |
| `Servlet_Verificar`         | Verificación del correo con código de 6 dígitos               |
| `Servlet_AlumnoRegistro`    | Alta de alumno: busca matrícula, valida correo institucional  |
| `Servlet_Validar`           | Endpoints AJAX de validación (usuario/correo/matrícula)       |
| `Servlet_Admin`             | Panel de administrador: usuarios, alumnos, materias, calificaciones |

Solo los usuarios con `es_admin = 1` y `status = activo` pueden iniciar sesión.
El profesor (admin) aprueba o rechaza solicitudes de usuarios y alumnos desde el
panel de administración.

## Estructura del proyecto

```
P2ACT06_SessionBDServletsCalifs_JuniorG/
├── BD/
│   └── db_calificaciones.sql   # Esquema y datos iniciales de MySQL
├── src/java/
│   ├── conexion/ConexionMySQL.java   # Conexión JDBC
│   ├── control/                      # Servlets (login, registro, verificación, admin)
│   ├── dao/                          # Acceso a datos (Alumno, Usuario, Materia, Calificacion)
│   ├── modelo/                       # POJOs
│   └── util/EnviarCorreo.java        # Envío de código por correo (SMTP)
└── web/
    ├── login.jsp, registro.jsp, verificar_codigo.jsp
    ├── alumno_registro.jsp, admin.jsp
    ├── style.css
    └── WEB-INF/web.xml               # Mapeo de servlets
```

## Correo de verificación

`util/EnviarCorreo.java` envía el código por SMTP. Si no hay credenciales
configuradas, `verificar_codigo.jsp` muestra el código en pantalla como
respaldo (`codigoFallback`) para poder probar el flujo sin correo real.
