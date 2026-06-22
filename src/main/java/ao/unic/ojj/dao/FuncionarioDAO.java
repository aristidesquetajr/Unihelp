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

import ao.unic.ojj.dto.RegistoFuncionarioDTO;
import ao.unic.ojj.model.Funcionario;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.model.Utilizador.Perfil;
import ao.unic.ojj.util.ConexaoBD;

/**
 *
 * @author kashiki
 */
public class FuncionarioDAO {

    private Connection con;
    private final UtilizadorDAO utilizadorDAO;

    public FuncionarioDAO(UtilizadorDAO utilizadorDAO) {
        this.utilizadorDAO = utilizadorDAO;
    }

    public boolean registar(RegistoFuncionarioDTO dto) {
        try {
            con = ConexaoBD.getConexao();
            con.setAutoCommit(false);

            Utilizador utilizador = new Utilizador(
                    dto.getNome(), dto.getEmail(), dto.getSenha(), Perfil.FUNCIONARIO,
                    Utilizador.Status.ACTIVO
            );

            int idUtilizador = utilizadorDAO.inserir(utilizador, con);

            String sql = """
                INSERT INTO funcionario (idUtilizador, departamento, cargo)
                VALUES (?,?,?)
            """;

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idUtilizador);
            ps.setString(2, dto.getDepartamento());
            ps.setString(3, dto.getCargo());
            ps.executeUpdate();

            if (dto.getTelefone() != null && !dto.getTelefone().isBlank()) {
                String sqlTel = "INSERT INTO telefone (numero, idUtilizador) VALUES (?,?)";
                PreparedStatement psTel = con.prepareStatement(sqlTel);
                psTel.setString(1, dto.getTelefone());
                psTel.setInt(2, idUtilizador);
                psTel.executeUpdate();
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("[FuncionarioDAO] Erro ao registar: " + e.getMessage());
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

    public Funcionario buscarPorId(int id) {
        String sql = "SELECT * FROM funcionario WHERE id=?";

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("[FuncionarioDAO] Erro ao buscar por id: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public Funcionario buscarPorIdUtilizador(int idUtilizador) {
        String sql = "SELECT * FROM funcionario WHERE idUtilizador=?";

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idUtilizador);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("[FuncionarioDAO] Erro ao buscar por idUtilizador: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public List<Funcionario> listar() {
        String sql = "SELECT * FROM funcionario";
        List<Funcionario> lista = new ArrayList<>();

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[FuncionarioDAO] Erro ao listar: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public boolean atualizar(Funcionario f) {
        String sql = "UPDATE funcionario SET departamento=?, cargo=? WHERE id=?";

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, f.getDepartamento());
            ps.setString(2, f.getCargo());
            ps.setInt(3, f.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[FuncionarioDAO] Erro ao atualizar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM funcionario WHERE id=?";

        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[FuncionarioDAO] Erro ao eliminar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    private Funcionario mapRow(ResultSet rs) throws SQLException {
        return new Funcionario(
                rs.getInt("id"),
                rs.getInt("idUtilizador"),
                rs.getString("departamento"),
                rs.getString("cargo")
        );
    }
}
