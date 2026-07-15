package dao;

import conexion.ConexionMySQL;
import modelo.Materia;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOMateria {

    public List<Materia> listar() {
        List<Materia> lista = new ArrayList<>();
        String sql = "SELECT clave, nombre FROM materias ORDER BY clave";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Materia m = new Materia();
                m.setClave(rs.getString("clave"));
                m.setNombre(rs.getString("nombre"));
                lista.add(m);
            }
        } catch (SQLException ex) {
            System.err.println("Error al listar materias: " + ex.getMessage());
        }
        return lista;
    }

    public boolean agregar(Materia m) {
        String sql = "INSERT INTO materias (clave, nombre) VALUES (?, ?)";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, m.getClave());
            ps.setString(2, m.getNombre());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error al agregar materia: " + ex.getMessage());
        }
        return false;
    }

    public boolean eliminar(String clave) {
        String sql = "DELETE FROM materias WHERE clave = ?";
        try (Connection con = ConexionMySQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, clave);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error al eliminar materia: " + ex.getMessage());
        }
        return false;
    }
}
