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
import ao.unic.ojj.model.Inscricao;
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
            SELECT 
              e.id, u.nome, u.email, e.numeroEstudante,
              c.nome AS curso, t.nome AS turma,
              t.sala, t.anoAcademico, pl.anoLetivo, u.status,
              i.estado AS estadoInscricao
            FROM estudante e
            JOIN utilizador u ON e.idUtilizador = u.id
            LEFT JOIN inscricao i ON i.idEstudante = e.id 
              AND i.id = (
                SELECT id FROM inscricao 
                WHERE idEstudante = e.id 
                ORDER BY dataInscricao DESC 
                LIMIT 1
              )
            LEFT JOIN turma t ON i.idTurma = t.id
            LEFT JOIN curso c ON t.idCurso = c.id
            LEFT JOIN periodoLetivo pl ON t.idPeriodoLetivo = pl.id
            WHERE e.id = ?
            """;
        
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idEstudante);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                EstudanteDetalheDTO dto = mapRowDTO(rs);
                
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
    
    public List<EstudanteDetalheDTO> listarEstudantesDetalhes() {
        return pesquisarEstudantesDetalhes(null, null);
    }

    public List<EstudanteDetalheDTO> pesquisarEstudantesDetalhes(String q, Integer cursoId) {
        StringBuilder sql = new StringBuilder("""
            SELECT 
              e.id, u.nome, u.email, e.numeroEstudante,
              c.nome AS curso, t.nome AS turma,
              t.sala, t.anoAcademico, pl.anoLetivo, u.status,
              i.estado AS estadoInscricao
            FROM estudante e
            JOIN utilizador u ON e.idUtilizador = u.id
            LEFT JOIN inscricao i ON i.idEstudante = e.id 
              AND i.id = (
                SELECT id FROM inscricao 
                WHERE idEstudante = e.id 
                ORDER BY dataInscricao DESC 
                LIMIT 1
              )
            LEFT JOIN turma t ON i.idTurma = t.id
            LEFT JOIN curso c ON t.idCurso = c.id
            LEFT JOIN periodoLetivo pl ON t.idPeriodoLetivo = pl.id
            WHERE 1=1
        """);
        List<Object> params = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            sql.append(" AND (u.nome LIKE ? OR e.numeroEstudante LIKE ?)");
            String like = "%" + q.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (cursoId != null) {
            sql.append(" AND t.idCurso = ?");
            params.add(cursoId);
        }

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();

            List<EstudanteDetalheDTO> list = new ArrayList<>();

            while (rs.next()) {
                EstudanteDetalheDTO dto = mapRowDTO(rs);
                dto.setTelefones(buscarTelefonesPorEstudante(dto.getId(), con));
                list.add(dto);
            }

            return list;

        } catch (SQLException e) {
            System.err.println("[EstudanteDAO] Erro ao pesquisar estudantes: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
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
    
    private EstudanteDetalheDTO mapRowDTO(ResultSet rs) throws SQLException {
        EstudanteDetalheDTO dto = new EstudanteDetalheDTO(
                rs.getInt("id"),
                rs.getString("nome"),
                rs.getString("email"),
                rs.getString("numeroEstudante"),
                rs.getString("curso"),
                rs.getString("turma"),
                rs.getString("sala"),
                rs.getInt("anoAcademico"),
                rs.getString("anoLetivo")
        );
        
        dto.setStatus(Utilizador.Status.valueOf(rs.getString("status")));
        dto.setEstadoInscricao(Inscricao.Estado.valueOf(rs.getString("estadoInscricao")));
        
        return dto;
    }
}
