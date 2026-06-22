package ao.unic.ojj.dao;

import ao.unic.ojj.model.Turma;
import ao.unic.ojj.util.ConexaoBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TurmaDAO {

    public Turma buscarPorId(int id) {
        String sql = "SELECT * FROM turma WHERE id=?";
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
            System.err.println("[TurmaDAO] Erro ao buscar por id: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public List<Turma> listar() {
        String sql = "SELECT * FROM turma ORDER BY nome";
        List<Turma> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[TurmaDAO] Erro ao listar: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    private Turma mapRow(ResultSet rs) throws SQLException {
        return new Turma(
                rs.getInt("id"),
                rs.getString("nome"),
                rs.getInt("idCurso"),
                rs.getInt("idPeriodoLetivo"),
                rs.getString("sala"),
                rs.getInt("anoAcademico")
        );
    }
}
