package dao;

import conexion.ConexionMySQL;
import modelo.Alumno;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOAlumno {

    public List<Alumno> listar() {
        List<Alumno> lista = new ArrayList<>();
        String sql = "SELECT matricula, nombre, paterno, materno, correo, clave, validar, status, " +
                     "DATE_FORMAT(fecha_registro,'%d/%m/%Y %H:%i') AS fecha " +
                     "FROM alumnos ORDER BY paterno, materno, nombre";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Alumno a = new Alumno();
                a.setMatricula(rs.getString("matricula"));
                a.setNombre(rs.getString("nombre"));
                a.setPaterno(rs.getString("paterno"));
                a.setMaterno(rs.getString("materno"));
                a.setCorreo(rs.getString("correo"));
                a.setClave(rs.getString("clave"));
                a.setValidar(rs.getBoolean("validar"));
                a.setStatus(rs.getString("status"));
                a.setFechaRegistro(rs.getString("fecha"));
                lista.add(a);
            }
        } catch (SQLException ex) {
            System.err.println("Error al listar alumnos: " + ex.getMessage());
        }
        return lista;
    }

    public boolean agregar(Alumno a) {
        String sql = "INSERT INTO alumnos (matricula, nombre, paterno, materno, correo, clave, validar, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, 'pendiente')";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, a.getMatricula());
            ps.setString(2, a.getNombre());
            ps.setString(3, a.getPaterno());
            ps.setString(4, a.getMaterno());
            ps.setString(5, a.getCorreo()  != null && !a.getCorreo().isEmpty()  ? a.getCorreo()  : null);
            ps.setString(6, a.getClave()   != null && !a.getClave().isEmpty()   ? a.getClave()   : null);
            ps.setBoolean(7, a.isValidar());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error al agregar alumno: " + ex.getMessage());
        }
        return false;
    }

    public boolean existeCorreo(String correo) {
        String sql = "SELECT 1 FROM alumnos WHERE correo = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo);
            return ps.executeQuery().next();
        } catch (SQLException ex) {
            System.err.println("Error al verificar correo de alumno: " + ex.getMessage());
        }
        return false;
    }

    /** Busca al alumno por su matrícula (para el autorregistro de correo). */
    public Alumno buscarPorMatricula(String matricula) {
        String sql = "SELECT matricula, nombre, paterno, materno, correo, validar, status FROM alumnos WHERE matricula = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, matricula);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Alumno a = new Alumno();
                a.setMatricula(rs.getString("matricula"));
                a.setNombre(rs.getString("nombre"));
                a.setPaterno(rs.getString("paterno"));
                a.setMaterno(rs.getString("materno"));
                a.setCorreo(rs.getString("correo"));
                a.setValidar(rs.getBoolean("validar"));
                a.setStatus(rs.getString("status"));
                return a;
            }
        } catch (SQLException ex) {
            System.err.println("Error al buscar alumno por matrícula: " + ex.getMessage());
        }
        return null;
    }

    /** Guarda el correo ya verificado del alumno y deja su solicitud pendiente de aprobación. */
    public boolean actualizarCorreo(String matricula, String correo) {
        String sql = "UPDATE alumnos SET correo = ?, validar = 1, status = 'pendiente' WHERE matricula = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo);
            ps.setString(2, matricula);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error al actualizar correo del alumno: " + ex.getMessage());
        }
        return false;
    }

    public boolean aceptar(String matricula) {
        return cambiarStatus(matricula, "activo");
    }

    public boolean rechazar(String matricula) {
        return cambiarStatus(matricula, "rechazado");
    }

    private boolean cambiarStatus(String matricula, String status) {
        String sql = "UPDATE alumnos SET status = ? WHERE matricula = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, matricula);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error al actualizar status del alumno: " + ex.getMessage());
        }
        return false;
    }

    public boolean eliminar(String matricula) {
        String sql = "DELETE FROM alumnos WHERE matricula = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, matricula);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error al eliminar alumno: " + ex.getMessage());
        }
        return false;
    }
}
