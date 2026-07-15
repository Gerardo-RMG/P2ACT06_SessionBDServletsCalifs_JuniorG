package dao;

import conexion.ConexionMySQL;
import modelo.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOUsuario {

    /** Solo concede acceso a cuentas de administrador ya validadas y activas. */
    public Usuario validarLogin(String usuario, String clave) {
        String sql = "SELECT usuario, clave, nombre, correo, validar, status, es_admin " +
                     "FROM usuarios WHERE usuario = ? AND clave = ? " +
                     "AND es_admin = 1 AND validar = 1 AND status = 'activo'";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario);
            ps.setString(2, clave);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (SQLException ex) {
            System.err.println("Error al validar usuario: " + ex.getMessage());
        }
        return null;
    }

    public boolean existeUsuario(String usuario) {
        String sql = "SELECT 1 FROM usuarios WHERE usuario = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario);
            return ps.executeQuery().next();
        } catch (SQLException ex) {
            System.err.println("Error al verificar usuario: " + ex.getMessage());
        }
        return false;
    }

    public boolean existeCorreo(String correo) {
        String sql = "SELECT 1 FROM usuarios WHERE correo = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo);
            return ps.executeQuery().next();
        } catch (SQLException ex) {
            System.err.println("Error al verificar correo: " + ex.getMessage());
        }
        return false;
    }

    /** Registra la solicitud ya con el correo verificado; queda pendiente de aprobación. */
    public boolean registrar(Usuario u) {
        String sql = "INSERT INTO usuarios (usuario, clave, nombre, correo, validar, status, es_admin) " +
                     "VALUES (?, ?, ?, ?, 1, 'pendiente', 0)";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getUsuario());
            ps.setString(2, u.getClave());
            ps.setString(3, u.getNombre());
            ps.setString(4, u.getCorreo());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error al registrar usuario: " + ex.getMessage());
        }
        return false;
    }

    /** Devuelve las solicitudes/cuentas (sin administradores) para la bandeja del profesor. */
    public List<Usuario> obtenerTodos() {
        String sql = "SELECT usuario, nombre, correo, validar, status, es_admin, " +
                     "DATE_FORMAT(fecha_registro,'%d/%m/%Y %H:%i') AS fecha " +
                     "FROM usuarios WHERE es_admin = 0 ORDER BY fecha_registro DESC";
        List<Usuario> lista = new ArrayList<>();
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setUsuario(rs.getString("usuario"));
                u.setNombre(rs.getString("nombre"));
                u.setCorreo(rs.getString("correo"));
                u.setValidar(rs.getBoolean("validar"));
                u.setStatus(rs.getString("status"));
                u.setEsAdmin(rs.getBoolean("es_admin"));
                u.setFechaRegistro(rs.getString("fecha"));
                lista.add(u);
            }
        } catch (SQLException ex) {
            System.err.println("Error al obtener usuarios: " + ex.getMessage());
        }
        return lista;
    }

    public boolean aceptar(String usuario) {
        return cambiarStatus(usuario, "activo");
    }

    public boolean rechazar(String usuario) {
        return cambiarStatus(usuario, "rechazado");
    }

    private boolean cambiarStatus(String usuario, String status) {
        String sql = "UPDATE usuarios SET status = ? WHERE usuario = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, usuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error al actualizar status: " + ex.getMessage());
        }
        return false;
    }

    public boolean eliminar(String usuario) {
        String sql = "DELETE FROM usuarios WHERE usuario = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error al eliminar usuario: " + ex.getMessage());
        }
        return false;
    }

    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setUsuario(rs.getString("usuario"));
        u.setClave(rs.getString("clave"));
        u.setNombre(rs.getString("nombre"));
        u.setCorreo(rs.getString("correo"));
        u.setValidar(rs.getBoolean("validar"));
        u.setStatus(rs.getString("status"));
        u.setEsAdmin(rs.getBoolean("es_admin"));
        return u;
    }
}
