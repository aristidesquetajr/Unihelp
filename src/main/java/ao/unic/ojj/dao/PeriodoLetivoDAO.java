/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dao;

import ao.unic.ojj.model.PeriodoLetivo;
import ao.unic.ojj.util.ConexaoBD;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author kashiki
 */
public class PeriodoLetivoDAO {

    public boolean inserir(PeriodoLetivo p) {
        String sql = "INSERT INTO periodoLetivo (anoLetivo, semestre, dataInicio, dataFim, ativo) "
                   + "VALUES (?,?,?,?,?)";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString (1, p.getAnoLetivo());
            ps.setInt    (2, p.getSemestre());
            ps.setDate   (3, new java.sql.Date(p.getDataInicio().getTime()));
            ps.setDate   (4, new java.sql.Date(p.getDataFim().getTime()));
            ps.setBoolean(5, p.isAtivo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[PeriodoLetivoDAO] Erro ao inserir: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    public PeriodoLetivo buscarPorId(int id) {
        String sql = "SELECT * FROM periodoLetivo WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[PeriodoLetivoDAO] Erro ao buscar por id: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    /** Retorna o período lectivo actualmente activo */
    public PeriodoLetivo buscarAtivo() {
        String sql = "SELECT * FROM periodoLetivo WHERE ativo = TRUE LIMIT 1";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[PeriodoLetivoDAO] Erro ao buscar activo: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return null;
    }

    public List<PeriodoLetivo> listar() {
        String sql = "SELECT * FROM periodoLetivo ORDER BY anoLetivo DESC, semestre DESC";
        List<PeriodoLetivo> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[PeriodoLetivoDAO] Erro ao listar: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }
    
        public List<PeriodoLetivo> listarUnique() {
        String sql = "SELECT id, DISTINCT(anoLetivo) FROM `periodoLetivo` ORDER BY anoLetivo DESC";
        List<PeriodoLetivo> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[PeriodoLetivoDAO] Erro ao listar: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    public boolean atualizar(PeriodoLetivo p) {
        String sql = "UPDATE periodoLetivo SET anoLetivo=?, semestre=?, "
                   + "dataInicio=?, dataFim=?, ativo=? WHERE id=?";
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString (1, p.getAnoLetivo());
            ps.setInt    (2, p.getSemestre());
            ps.setDate   (3, new java.sql.Date(p.getDataInicio().getTime()));
            ps.setDate   (4, new java.sql.Date(p.getDataFim().getTime()));
            ps.setBoolean(5, p.isAtivo());
            ps.setInt    (6, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[PeriodoLetivoDAO] Erro ao atualizar: " + e.getMessage());
            return false;
        } finally {
            ConexaoBD.fechar(con);
        }
    }

    private PeriodoLetivo mapRow(ResultSet rs) throws SQLException {
        return new PeriodoLetivo(
            rs.getInt    ("id"),
            rs.getString ("anoLetivo"),
            rs.getInt    ("semestre"),
            rs.getDate   ("dataInicio"),
            rs.getDate   ("dataFim"),
            rs.getBoolean("ativo")
        );
    }
}
