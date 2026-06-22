/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import ao.unic.ojj.model.Telefone;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.util.ConexaoBD;

/**
 *
 * @author kashiki
 */
public class TelefoneDAO {

    private Connection con;
    private final UtilizadorDAO utilizadorDAO;

    public TelefoneDAO(UtilizadorDAO utilizadorDAO) {
        this.utilizadorDAO = utilizadorDAO;
    }

    public boolean inserir(Telefone t) {
        String sql = "INSERT INTO telefone (numero, idUtilizador) VALUES (?, ?)";

        Utilizador u = utilizadorDAO.buscarPorId(t.getIdUtilizador());

        if (u == null) {
            System.err.println("[TelefoneDAO] Erro: Utilizador nao existe.");
            return false;
        }

        Connection con = null;

        try {
            con = ConexaoBD.getConexao();

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, t.getNumero());
            ps.setInt(2, t.getIdUtilizador());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[TelefoneDAO] Erro ao inserir: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public void inserir(Telefone t, Connection con) {
        String sql = "INSERT INTO telefone (numero, idUtilizador) VALUES (?, ?)";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, t.getNumero());
            ps.setInt(2, t.getIdUtilizador());

            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[TelefoneDAO] Erro ao inserir: " + e.getMessage());
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
            }
        }
    }

    public List<Telefone> listarPorUtilizador(int idUtilizador) {
        String sql = "SELECT * FROM telefone WHERE idUtilizador = ?";

        List<Telefone> lista = new ArrayList<>();

        Utilizador u = utilizadorDAO.buscarPorId(idUtilizador);

        if (u == null) {
            System.err.println("[TelefoneDAO] Erro: Utilizador nao existe.");
            return lista;
        }

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idUtilizador);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[TelefoneDAO] Erro ao listar: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM telefone WHERE id=?";

        Utilizador u = utilizadorDAO.buscarPorId(id);

        if (u == null) {
            System.err.println("[TelefoneDAO] Erro: Utilizador nao existe.");
            return false;
        }

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[TelefoneDAO] Erro ao eliminar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    private Telefone mapRow(ResultSet rs) throws SQLException {
        return new Telefone(
                rs.getInt("id"),
                rs.getString("numero"),
                rs.getInt("idUtilizador")
        );
    }
}
