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

import ao.unic.ojj.dto.NotaDetalheDTO;
import ao.unic.ojj.model.Nota;
import ao.unic.ojj.util.ConexaoBD;

/**
 *
 * @author kashiki
 */
public class NotaDAO {

    private static final String SQL_DTO = """
        SELECT n.id, n.valor, n.tipo,
            d.nome AS nomeDisciplina, d.codigo AS codigoDisciplina,
            pl.anoLetivo, pl.semestre
        FROM nota n
        JOIN disciplina   d  ON n.idDisciplina    = d.id
        JOIN periodoLetivo pl ON n.idPeriodoLetivo = pl.id
    """;

    public boolean inserir(Nota n) {
        String sql = "INSERT INTO nota (idEstudante, idDisciplina, idPeriodoLetivo, valor, tipo) "
                + "VALUES (?,?,?,?,?)";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, n.getIdEstudante());
            ps.setInt(2, n.getIdDisciplina());
            ps.setInt(3, n.getIdPeriodoLetivo());
            ps.setDouble(4, n.getValor());
            ps.setString(5, n.getTipo().name());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[NotaDAO] Erro ao inserir: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public Nota buscarPorId(int id) {
        String sql = "SELECT * FROM nota WHERE id=?";
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
            System.err.println("[NotaDAO] Erro ao buscar por id: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public List<NotaDetalheDTO> listarDetalhesPorEstudante(int idEstudante) {
        String sql = SQL_DTO
                + "WHERE n.idEstudante=? "
                + "ORDER BY pl.anoLetivo DESC, pl.semestre DESC, d.nome";
        return executarQueryDTO(sql, idEstudante, -1);
    }

    public List<NotaDetalheDTO> listarDetalhesPorEstudanteEPeriodo(
            int idEstudante, int idPeriodoLetivo) {
        String sql = SQL_DTO
                + "WHERE n.idEstudante=? AND n.idPeriodoLetivo=? "
                + "ORDER BY d.nome, n.tipo";
        return executarQueryDTO(sql, idEstudante, idPeriodoLetivo);
    }

    public List<Nota> listarPorEstudante(int idEstudante) {
        String sql = "SELECT * FROM nota WHERE idEstudante=? ORDER BY idPeriodoLetivo DESC";
        List<Nota> lista = new ArrayList<>();
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
            System.err.println("[NotaDAO] Erro ao listar por estudante: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public List<Nota> listarPorDisciplinaEPeriodo(int idDisciplina, int idPeriodoLetivo) {
        String sql = "SELECT * FROM nota WHERE idDisciplina=? AND idPeriodoLetivo=? "
                + "ORDER BY idEstudante, tipo";
        List<Nota> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idDisciplina);
            ps.setInt(2, idPeriodoLetivo);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[NotaDAO] Erro ao listar por disciplina e período: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public boolean atualizar(Nota n) {
        String sql = "UPDATE nota SET valor=?, tipo=? WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDouble(1, n.getValor());
            ps.setString(2, n.getTipo().name());
            ps.setInt(3, n.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[NotaDAO] Erro ao atualizar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM nota WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[NotaDAO] Erro ao eliminar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    private List<NotaDetalheDTO> executarQueryDTO(String sql, int idEstudante, int idPeriodo) {
        List<NotaDetalheDTO> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idEstudante);
            if (idPeriodo > 0) {
                ps.setInt(2, idPeriodo);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRowDTO(rs));
            }
        } catch (SQLException e) {
            System.err.println("[NotaDAO] Erro na query DTO: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    private Nota mapRow(ResultSet rs) throws SQLException {
        return new Nota(
                rs.getInt("id"),
                rs.getInt("idEstudante"),
                rs.getInt("idDisciplina"),
                rs.getInt("idPeriodoLetivo"),
                rs.getDouble("valor"),
                Nota.Tipo.valueOf(rs.getString("tipo"))
        );
    }

    private NotaDetalheDTO mapRowDTO(ResultSet rs) throws SQLException {
        NotaDetalheDTO dto = new NotaDetalheDTO();
        dto.setIdNota(rs.getInt("id"));
        dto.setNomeDisciplina(rs.getString("nomeDisciplina"));
        dto.setCodigoDisciplina(rs.getString("codigoDisciplina"));
        dto.setAnoLetivo(rs.getString("anoLetivo"));
        dto.setSemestre(rs.getInt("semestre"));
        dto.setValor(rs.getDouble("valor"));
        dto.setTipo(Nota.Tipo.valueOf(rs.getString("tipo")));
        return dto;
    }
}
