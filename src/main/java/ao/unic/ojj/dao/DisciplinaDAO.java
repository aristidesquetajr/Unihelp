package ao.unic.ojj.dao;

import ao.unic.ojj.model.Disciplina;
import ao.unic.ojj.util.ConexaoBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class DisciplinaDAO {

    public boolean inserir(Disciplina d) {
        String sql = "INSERT INTO disciplina (nome, codigo) VALUES (?,?)";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, d.getNome());
            ps.setString(2, d.getCodigo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[DisciplinaDAO] Erro ao inserir: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public Disciplina buscarPorId(int id) {
        String sql = "SELECT * FROM disciplina WHERE id=?";
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
            System.err.println("[DisciplinaDAO] Erro ao buscar por id: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public List<Disciplina> listar() {
        String sql = "SELECT * FROM disciplina";

        List<Disciplina> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[DisciplinaDAO] Erro ao listar: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public boolean atualizar(Disciplina d) {
        String sql = "UPDATE disciplina SET nome=?, codigo=? WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, d.getNome());
            ps.setString(2, d.getCodigo());

            ps.setInt(3, d.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[DisciplinaDAO] Erro ao atualizar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM disciplina WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[DisciplinaDAO] Erro ao eliminar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    private Disciplina mapRow(ResultSet rs) throws SQLException {
        return new Disciplina(
                rs.getInt("id"),
                rs.getString("nome"),
                rs.getString("codigo")
        );
    }
}
