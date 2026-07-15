package dao;

import conexion.ConexionMySQL;
import modelo.Calificacion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOCalificacion {

    public List<Calificacion> listar() {
        List<Calificacion> lista = new ArrayList<>();
        String sql = "SELECT c.id, c.matricula, c.materia_clave, c.p1, c.p2, c.p3, " +
                     "CONCAT(a.nombre, ' ', a.paterno, IF(a.materno IS NULL OR a.materno = '', '', CONCAT(' ', a.materno))) AS alumno_nombre, " +
                     "m.nombre AS materia_nombre " +
                     "FROM calificaciones c " +
                     "JOIN alumnos  a ON a.matricula = c.matricula " +
                     "JOIN materias m ON m.clave     = c.materia_clave " +
                     "ORDER BY a.paterno, a.materno, a.nombre, m.clave";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Calificacion c = new Calificacion();
                c.setId(rs.getInt("id"));
                c.setMatricula(rs.getString("matricula"));
                c.setMateriaClave(rs.getString("materia_clave"));
                c.setAlumnoNombre(rs.getString("alumno_nombre"));
                c.setMateriaNombre(rs.getString("materia_nombre"));
                c.setP1(rs.getDouble("p1"));
                c.setP2(rs.getDouble("p2"));
                c.setP3(rs.getDouble("p3"));
                lista.add(c);
            }
        } catch (SQLException ex) {
            System.err.println("Error al listar calificaciones: " + ex.getMessage());
        }
        return lista;
    }

    /** Inserta una fila de calificación (p1=p2=p3=0) por cada par alumno-materia que aún no exista. */
    public int generarFaltantes() {
        String sql = "INSERT INTO calificaciones (matricula, materia_clave, p1, p2, p3) " +
                     "SELECT a.matricula, m.clave, 0, 0, 0 " +
                     "FROM alumnos a CROSS JOIN materias m " +
                     "WHERE NOT EXISTS (" +
                     "  SELECT 1 FROM calificaciones c " +
                     "  WHERE c.matricula = a.matricula AND c.materia_clave = m.clave" +
                     ")";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            return ps.executeUpdate();
        } catch (SQLException ex) {
            System.err.println("Error al generar calificaciones: " + ex.getMessage());
        }
        return 0;
    }

    public boolean actualizar(int id, double p1, double p2, double p3) {
        String sql = "UPDATE calificaciones SET p1 = ?, p2 = ?, p3 = ? WHERE id = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, p1);
            ps.setDouble(2, p2);
            ps.setDouble(3, p3);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error al actualizar calificación: " + ex.getMessage());
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM calificaciones WHERE id = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error al eliminar calificación: " + ex.getMessage());
        }
        return false;
    }
}
