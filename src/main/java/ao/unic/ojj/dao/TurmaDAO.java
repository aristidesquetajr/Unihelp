package ao.unic.ojj.dao;

import ao.unic.ojj.dto.TurmaDTO;
import ao.unic.ojj.model.Turma;
import ao.unic.ojj.util.ConexaoBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TurmaDAO {

    public boolean inserir(Turma t) {
        String sql = "INSERT INTO turma (nome, idCurso, idPeriodoLetivo, sala, anoAcademico) "
                + "VALUES (?,?,?,?,?)";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, t.getNome());
            ps.setInt(2, t.getIdCurso());
            ps.setInt(3, t.getIdPeriodoLetivo());
            ps.setString(4, t.getSala());
            ps.setInt(5, t.getAnoAcademico());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[TurmaDAO] Erro ao inserir: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

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

    public List<TurmaDTO> listar() {
        String sql = "SELECT t.*, c.nome AS nomeCurso, "
                + "CONCAT(pl.semestre, 'º Semestre ', pl.anoLetivo) AS nomePeriodo "
                + "FROM turma t "
                + "LEFT JOIN curso c ON t.idCurso = c.id "
                + "LEFT JOIN periodoLetivo pl ON t.idPeriodoLetivo = pl.id "
                + "ORDER BY pl.anoLetivo desc, pl.semestre desc, t.nome";
        List<TurmaDTO> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRowDTO(rs));
            }
        } catch (SQLException e) {
            System.err.println("[TurmaDAO] Erro ao listar: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public boolean atualizar(Turma t) {
        String sql = "UPDATE turma SET nome=?, idCurso=?, idPeriodoLetivo=?, sala=?, anoAcademico=? WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, t.getNome());
            ps.setInt(2, t.getIdCurso());
            ps.setInt(3, t.getIdPeriodoLetivo());
            ps.setString(4, t.getSala());
            ps.setInt(5, t.getAnoAcademico());
            ps.setInt(6, t.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[TurmaDAO] Erro ao atualizar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public List<TurmaDTO> pesquisar(String nome, Integer idCurso, Integer idPeriodoLetivo) {
        StringBuilder sql = new StringBuilder(
                "SELECT t.*, c.nome AS nomeCurso, "
                + "CONCAT(pl.semestre, 'º Semestre ', pl.anoLetivo) AS nomePeriodo "
                + "FROM turma t "
                + "LEFT JOIN curso c ON t.idCurso = c.id "
                + "LEFT JOIN periodoLetivo pl ON t.idPeriodoLetivo = pl.id "
                + "WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        if (nome != null && !nome.trim().isEmpty()) {
            sql.append(" AND t.nome LIKE ?");
            params.add("%" + nome.trim() + "%");
        }
        if (idCurso != null) {
            sql.append(" AND t.idCurso = ?");
            params.add(idCurso);
        }
        if (idPeriodoLetivo != null) {
            sql.append(" AND t.idPeriodoLetivo = ?");
            params.add(idPeriodoLetivo);
        }

        sql.append(" ORDER BY pl.anoLetivo desc, pl.semestre desc, t.nome, c.nome");
        List<TurmaDTO> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRowDTO(rs));
            }
        } catch (SQLException e) {
            System.err.println("[TurmaDAO] Erro ao pesquisar: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM turma WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[TurmaDAO] Erro ao eliminar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
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

    private TurmaDTO mapRowDTO(ResultSet rs) throws SQLException {
        return new TurmaDTO(
                rs.getInt("id"),
                rs.getString("nome"),
                rs.getInt("idCurso"),
                rs.getInt("idPeriodoLetivo"),
                rs.getString("sala"),
                rs.getInt("anoAcademico"),
                rs.getString("nomeCurso"),
                rs.getString("nomePeriodo")
        );
    }
}
