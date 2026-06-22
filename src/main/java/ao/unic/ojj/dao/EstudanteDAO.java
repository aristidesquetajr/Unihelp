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
import java.util.Date;
import java.util.List;

import ao.unic.ojj.dto.EstudanteDetalheDTO;
import ao.unic.ojj.dto.RegistoEstudanteDTO;
import ao.unic.ojj.model.Estudante;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.model.Utilizador.Perfil;
import ao.unic.ojj.util.ConexaoBD;

/**
 *
 * @author kashiki
 */
public class EstudanteDAO {

    private Connection con;
    private final UtilizadorDAO utilizadorDAO;

    public EstudanteDAO(UtilizadorDAO utilizadorDAO) {
        this.utilizadorDAO = utilizadorDAO;
    }

    public boolean registar(RegistoEstudanteDTO dto) {
        try {
            con = ConexaoBD.getConexao();
            con.setAutoCommit(false);

            Utilizador utilizador = new Utilizador(
                    dto.getNome(), dto.getEmail(), dto.getSenha(), Perfil.ESTUDANTE,
                    Utilizador.Status.ACTIVO
            );

            int idUtilizador = utilizadorDAO.inserir(utilizador, con);

            String sql = "INSERT INTO estudante (idUtilizador, numeroEstudante) VALUES (?,?)";

            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            ps.setInt(1, idUtilizador);
            ps.setString(2, dto.getNumeroEstudante());
            ps.executeUpdate();

            ResultSet rsEstudante = ps.getGeneratedKeys();
            if (!rsEstudante.next()) {
                throw new SQLException("Falha ao obter id do Estudante.");
            }
            int idEstudante = rsEstudante.getInt(1);

            if (dto.getTelefone() != null && !dto.getTelefone().isBlank()) {
                String sqlTel = "INSERT INTO telefone (numero, idUtilizador) VALUES (?,?)";

                PreparedStatement psTel = con.prepareStatement(sqlTel);
                psTel.setString(1, dto.getTelefone());
                psTel.setInt(2, idUtilizador);
                psTel.executeUpdate();
            }

            String sqlInscricao = """
                INSERT INTO inscricao (idEstudante, idTurma, dataInscricao, estado)
                VALUES (?,?,?,?)
            """;

            PreparedStatement psInscricao = con.prepareStatement(sqlInscricao);
            psInscricao.setInt(1, idEstudante);
            psInscricao.setInt(2, dto.getIdTurma());
            psInscricao.setDate(3, new java.sql.Date(new Date().getTime()));
            psInscricao.setString(4, "ACTIVO");
            psInscricao.executeUpdate();

            con.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("[EstudanteDAO] Erro ao registar: " + e.getMessage());
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
            }
            return false;
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                }
            } catch (SQLException e) {
            }
            ConexaoBD.fechar(con);
        }
    }

    public boolean existeNumeroEstudante(String numeroEstudante) {
        String sql = "SELECT 1 FROM estudante WHERE numeroEstudante=? LIMIT 1";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, numeroEstudante);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.err.println("[EstudanteDAO] Erro ao verificar número de estudante: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public EstudanteDetalheDTO buscarDetalhesPorId(int idEstudante) {
        String sql = """
            SELECT u.nome, u.email, e.numeroEstudante,
            c.nome AS curso, t.nome AS turma,
            t.sala, t.anoAcademico, pl.anoLetivo
            FROM estudante e
            JOIN utilizador u      ON e.idUtilizador  = u.id
            LEFT JOIN inscricao i  ON i.idEstudante  = e.id AND i.estado = 'ACTIVO'
            LEFT JOIN turma t      ON i.idTurma       = t.id
            LEFT JOIN curso c      ON t.idCurso       = c.id
            LEFT JOIN periodoLetivo pl ON t.idPeriodoLetivo = pl.id
            WHERE e.id = ?
            """;

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idEstudante);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                EstudanteDetalheDTO dto = new EstudanteDetalheDTO();
                dto.setNome(rs.getString("nome"));
                dto.setEmail(rs.getString("email"));
                dto.setNumeroEstudante(rs.getString("numeroEstudante"));
                dto.setNomeCurso(rs.getString("curso"));
                dto.setNomeTurma(rs.getString("turma"));
                dto.setSala(rs.getString("sala"));
                dto.setAnoAcademico(rs.getInt("anoAcademico"));
                dto.setAnoLetivo(rs.getString("anoLetivo"));

                dto.setTelefones(buscarTelefonesPorEstudante(idEstudante, con));
                return dto;
            }

        } catch (SQLException e) {
            System.err.println("[EstudanteDAO] Erro ao buscar detalhes: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public Estudante buscarPorId(int id) {
        String sql = "SELECT * FROM estudante WHERE id=?";

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("[EstudanteDAO] Erro ao buscar por id: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public Estudante buscarPorIdUtilizador(int idUtilizador) {
        String sql = "SELECT * FROM estudante WHERE idUtilizador=?";

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idUtilizador);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("[EstudanteDAO] Erro ao buscar por idUtilizador: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public List<Estudante> listar() {
        String sql = "SELECT * FROM estudante";
        List<Estudante> lista = new ArrayList<>();

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[EstudanteDAO] Erro ao listar: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM estudante WHERE id=?";

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[EstudanteDAO] Erro ao eliminar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    private List<String> buscarTelefonesPorEstudante(int idEstudante, Connection con)
            throws SQLException {

        String sql = """
            SELECT t.numero FROM telefone t
            JOIN estudante e ON t.idUtilizador = e.idUtilizador
            WHERE e.id = ?
        """;

        List<String> lista = new ArrayList<>();

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idEstudante);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            lista.add(rs.getString("numero"));
        }

        return lista;
    }

    private Estudante mapRow(ResultSet rs) throws SQLException {
        return new Estudante(
                rs.getInt("id"),
                rs.getInt("idUtilizador"),
                rs.getString("numeroEstudante")
        );
    }
}
