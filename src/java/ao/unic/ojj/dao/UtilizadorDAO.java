/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.util.ConexaoBD;

/**
 *
 * @author kashiki
 */
public class UtilizadorDAO {

    private Connection con;

    public int inserir(Utilizador u, Connection con) {
        String sql = """
                INSERT INTO utilizador (nome, email, senha, perfil, status)
                VALUES (?,?,?,?,?)
            """;

        try {

            PreparedStatement ps = con.prepareStatement(
                    sql, Statement.RETURN_GENERATED_KEYS
            );

            ps.setString(1, u.getNome());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getSenha());
            ps.setString(4, u.getPerfil().name());
            ps.setString(5, u.getStatus().name());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();

            if (!rs.next()) {
                throw new SQLException("Falha ao obter id do Utilizador.");
            }

            int idUtilizador = rs.getInt(1);

            return idUtilizador;
        } catch (SQLException e) {
            System.err.println("[UtilizadorDAO] Erro ao inserir: " + e.getMessage());
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
            }
            return 0;
        }
    }

    public Utilizador autenticar(String email, String senha) {
        String sql = """
            SELECT * FROM utilizador
            WHERE email = ? AND senha = md5(?) AND status = 'ACTIVO'
	    """;

        try {
            con = ConexaoBD.getConexao();

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, senha);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("[UtilizadorDAO] Erro ao autenticar: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public Utilizador buscarPorId(int id) {
        String sql = "SELECT * FROM utilizador WHERE id = ?";

        Connection con = null;

        try {
            con = ConexaoBD.getConexao();

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("[UtilizadorDAO] Erro ao buscar por id: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public Utilizador buscarPorEmail(String email, int exceptoId) {
        String sql = "SELECT * FROM utilizador WHERE email = ? AND id != ?";

        try {
            con = ConexaoBD.getConexao();

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setInt(2, exceptoId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("[UtilizadorDAO] Erro ao buscar por email: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public List<Utilizador> listar() {
        String sql = "SELECT * FROM utilizador ORDER BY nome";

        List<Utilizador> lista = new ArrayList<>();

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[UtilizadorDAO] Erro ao listar: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }

        return lista;
    }

    public boolean alterarNomeEmail(Utilizador u) {
        String sql = "UPDATE utilizador SET nome=?, email=? WHERE id=?";

        Utilizador utilizadorIdValido = this.buscarPorId(u.getId());

        if (utilizadorIdValido == null) {
            System.err.println("[UtilizadorDAO] erro: ID invalido");
            return false;
        }

        Utilizador utilizadorEmail = buscarPorEmail(u.getEmail(), u.getId());

        if (utilizadorEmail != null) {
            System.err.println("[UtilizadorDAO] Erro: Email ja existe.");
            return false;
        }

        try {
            con = ConexaoBD.getConexao();

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, u.getNome());
            ps.setString(2, u.getEmail());
            ps.setInt(3, u.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UtilizadorDAO] Erro ao atualizar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public boolean alterarStatus(int id, Utilizador.Status status) {
        String sql = "UPDATE utilizador SET status=? WHERE id=?";

        Utilizador utilizadorIdValido = this.buscarPorId(id);

        if (utilizadorIdValido == null) {
            System.err.println("[UtilizadorDAO] erro: ID invalido");
            return false;
        }

        try {
            con = ConexaoBD.getConexao();

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status.name());
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UtilizadorDAO] Erro ao alterar status: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM utilizador WHERE id=?";

        Utilizador utilizadorIdValido = this.buscarPorId(id);

        if (utilizadorIdValido == null) {
            System.err.println("[UtilizadorDAO] erro: ID invalido");
            return false;
        }

        try {
            con = ConexaoBD.getConexao();

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UtilizadorDAO] Erro ao eliminar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    private Utilizador mapRow(ResultSet rs) throws SQLException {
        return new Utilizador(
                rs.getInt("id"),
                rs.getString("nome"),
                rs.getString("email"),
                rs.getString("senha"),
                Utilizador.Perfil.valueOf(rs.getString("perfil")),
                Utilizador.Status.valueOf(rs.getString("status"))
        );
    }
}
