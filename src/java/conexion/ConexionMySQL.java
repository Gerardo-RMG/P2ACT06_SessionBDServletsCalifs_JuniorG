package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionMySQL {

    private static final String URL    = "jdbc:mysql://localhost:3306/calificaciones";
    private static final String USUARIO = "root";
    private static final String CLAVE   = "";

    public static Connection getConexion() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            throw new SQLException("Driver MySQL no encontrado. Verifica el JAR en WEB-INF/lib", ex);
        }
        return DriverManager.getConnection(URL, USUARIO, CLAVE);
    }
}
