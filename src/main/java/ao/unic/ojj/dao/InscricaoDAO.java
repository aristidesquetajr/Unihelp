/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dao;

import ao.unic.ojj.dto.InscricaoDetalheDTO;
import ao.unic.ojj.model.Inscricao;
import ao.unic.ojj.util.ConexaoBD;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author kashiki
 */
public class InscricaoDAO {

    private static final String SQL_DTO = """
        SELECT i.id, i.dataInscricao, i.estado,
            t.nome AS nomeTurma, t.sala, t.anoAcademico,
            c.nome AS nomeCurso,
            pl.anoLetivo, pl.semestre
        FROM inscricao i
        JOIN turma        t  ON i.idTurma          = t.id
        JOIN curso        c  ON t.idCurso           = c.id
        JOIN periodoLetivo pl ON t.idPeriodoLetivo  = pl.id
    """;

    public boolean inserir(Inscricao i) {
        String sql = "INSERT INTO inscricao (idEstudante, idTurma, dataInscricao, estado) "
                + "VALUES (?,?,?,?)";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, i.getIdEstudante());
            ps.setInt(2, i.getIdTurma());
            ps.setDate(3, new java.sql.Date(i.getDataInscricao().getTime()));
            ps.setString(4, i.getEstado().name());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[InscricaoDAO] Erro ao inserir: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public Inscricao buscarPorId(int id) {
        String sql = "SELECT * FROM inscricao WHERE id=?";
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
            System.err.println("[InscricaoDAO] Erro ao buscar por id: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public List<InscricaoDetalheDTO> listarDetalhesPorEstudante(int idEstudante) {
        String sql = SQL_DTO
                + "WHERE i.idEstudante=? "
                + "ORDER BY pl.anoLetivo DESC, pl.semestre DESC";
        List<InscricaoDetalheDTO> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idEstudante);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRowDTO(rs));
            }
        } catch (SQLException e) {
            System.err.println("[InscricaoDAO] Erro ao listar detalhes: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public List<Inscricao> listarPorEstudante(int idEstudante) {
        String sql = "SELECT * FROM inscricao WHERE idEstudante=? ORDER BY dataInscricao DESC";
        List<Inscricao> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idEstudante);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[InscricaoDAO] Erro ao listar por estudante: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public Inscricao buscarAtivaPorEstudante(int idEstudante) {
        String sql = "SELECT * FROM inscricao WHERE idEstudante=? AND estado='ACTIVO' LIMIT 1";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idEstudante);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("[InscricaoDAO] Erro ao buscar activa: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public List<Inscricao> listarPorTurma(int idTurma) {
        String sql = "SELECT * FROM inscricao WHERE idTurma=?";
        List<Inscricao> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idTurma);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[InscricaoDAO] Erro ao listar por turma: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public boolean atualizarEstado(int id, Inscricao.Estado estado) {
        String sql = "UPDATE inscricao SET estado=? WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, estado.name());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[InscricaoDAO] Erro ao atualizar estado: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM inscricao WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[InscricaoDAO] Erro ao eliminar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    private Inscricao mapRow(ResultSet rs) throws SQLException {
        return new Inscricao(
                rs.getInt("id"),
                rs.getInt("idEstudante"),
                rs.getInt("idTurma"),
                rs.getDate("dataInscricao"),
                Inscricao.Estado.valueOf(rs.getString("estado"))
        );
    }

    private InscricaoDetalheDTO mapRowDTO(ResultSet rs) throws SQLException {
        InscricaoDetalheDTO dto = new InscricaoDetalheDTO();
        dto.setIdInscricao(rs.getInt("id"));
        dto.setDataInscricao(rs.getDate("dataInscricao"));
        dto.setEstado(Inscricao.Estado.valueOf(rs.getString("estado")));
        dto.setNomeTurma(rs.getString("nomeTurma"));
        dto.setSala(rs.getString("sala"));
        dto.setAnoAcademico(rs.getInt("anoAcademico"));
        dto.setNomeCurso(rs.getString("nomeCurso"));
        dto.setAnoLetivo(rs.getString("anoLetivo"));
        dto.setSemestre(rs.getInt("semestre"));
        return dto;
    }
}
