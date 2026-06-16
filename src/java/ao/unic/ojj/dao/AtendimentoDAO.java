/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dao;

import ao.unic.ojj.dto.AtendimentoDTO;
import ao.unic.ojj.model.Atendimento;
import ao.unic.ojj.util.ConexaoBD;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author kashiki
 */
public class AtendimentoDAO {

    private Connection con;

    private static final String SQL_DTO = """
        SELECT a.id, a.dataAgendada, a.descricao, a.estado, a.motivoRejeicao,
        u.nome AS nomeEstudante, e.numeroEstudante,
        uf.nome AS nomeFuncionario
        FROM atendimento a
        JOIN estudante e  ON a.idEstudante   = e.id
        JOIN utilizador u ON e.idUtilizador  = u.id
        LEFT JOIN funcionario f  ON a.idFuncionario = f.id
        LEFT JOIN utilizador uf  ON f.idUtilizador  = uf.id
    """;

    public boolean inserir(Atendimento a) {
        String sql = "INSERT INTO atendimento (idEstudante, dataAgendada, descricao, estado) "
                + "VALUES (?,?,?,'PENDENTE')";

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, a.getIdEstudante());
            ps.setTimestamp(2, new Timestamp(a.getDataAgendada().getTime()));
            ps.setString(3, a.getDescricao());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[AtendimentoDAO] Erro ao inserir: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public Atendimento buscarPorId(int id) {
        String sql = "SELECT * FROM atendimento WHERE id=?";

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("[AtendimentoDAO] Erro ao buscar por id: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public List<AtendimentoDTO> listarPendentesDTO() {
        String sql = SQL_DTO + "WHERE a.estado='PENDENTE' ORDER BY a.dataAgendada ASC";
        return executarQueryDTO(sql, null);
    }

    public List<AtendimentoDTO> listarPorDataDTO(java.util.Date data) {
        String sql = SQL_DTO + "WHERE DATE(a.dataAgendada)=? ORDER BY a.dataAgendada ASC";
        return executarQueryDTO(sql, data);
    }

    public List<AtendimentoDTO> listarPorEstudanteDTO(int idEstudante) {
        String sql = SQL_DTO + "WHERE a.idEstudante=? ORDER BY a.dataAgendada DESC";
        Connection con = null;
        List<AtendimentoDTO> lista = new ArrayList<>();
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idEstudante);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRowDTO(rs));
            }
        } catch (SQLException e) {
            System.err.println("[AtendimentoDAO] Erro ao listar por estudante DTO: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public List<Atendimento> listarPorEstudante(int idEstudante) {
        String sql = "SELECT * FROM atendimento WHERE idEstudante=? ORDER BY dataAgendada DESC";
        List<Atendimento> lista = new ArrayList<>();
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
            System.err.println("[AtendimentoDAO] Erro ao listar por estudante: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public int contarPorData(java.util.Date data) {
        String sql = "SELECT COUNT(*) FROM atendimento "
                + "WHERE DATE(dataAgendada)=? AND estado IN ('PENDENTE','CONFIRMADO')";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(data.getTime()));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("[AtendimentoDAO] Erro ao contar por data: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return 0;
    }

    public boolean aprovar(int id, int idFuncionario) {
        String sql = "UPDATE atendimento SET estado='CONFIRMADO', idFuncionario=? WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idFuncionario);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[AtendimentoDAO] Erro ao aprovar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public boolean rejeitar(int id, int idFuncionario, String motivoRejeicao) {
        String sql = "UPDATE atendimento SET estado='REJEITADO', idFuncionario=?, "
                + "motivoRejeicao=? WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idFuncionario);
            ps.setString(2, motivoRejeicao);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[AtendimentoDAO] Erro ao rejeitar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM atendimento WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[AtendimentoDAO] Erro ao eliminar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    private List<AtendimentoDTO> executarQueryDTO(String sql, java.util.Date data) {
        List<AtendimentoDTO> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            if (data != null) {
                ps.setDate(1, new java.sql.Date(data.getTime()));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRowDTO(rs));
            }
        } catch (SQLException e) {
            System.err.println("[AtendimentoDAO] Erro na query DTO: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    private Atendimento mapRow(ResultSet rs) throws SQLException {
        Atendimento a = new Atendimento();
        a.setId(rs.getInt("id"));
        a.setIdEstudante(rs.getInt("idEstudante"));
        a.setIdFuncionario(rs.getInt("idFuncionario"));
        a.setDataAgendada(rs.getTimestamp("dataAgendada"));
        a.setDescricao(rs.getString("descricao"));
        a.setEstado(Atendimento.Estado.valueOf(rs.getString("estado")));
        a.setMotivoRejeicao(rs.getString("motivoRejeicao"));
        return a;
    }

    private AtendimentoDTO mapRowDTO(ResultSet rs) throws SQLException {
        AtendimentoDTO dto = new AtendimentoDTO();
        dto.setIdAtendimento(rs.getInt("id"));
        dto.setNomeEstudante(rs.getString("nomeEstudante"));
        dto.setNumeroEstudante(rs.getString("numeroEstudante"));
        dto.setNomeFuncionario(rs.getString("nomeFuncionario"));
        dto.setDataAgendada(rs.getTimestamp("dataAgendada"));
        dto.setDescricao(rs.getString("descricao"));
        dto.setEstado(Atendimento.Estado.valueOf(rs.getString("estado")));
        dto.setMotivoRejeicao(rs.getString("motivoRejeicao"));
        return dto;
    }
}
