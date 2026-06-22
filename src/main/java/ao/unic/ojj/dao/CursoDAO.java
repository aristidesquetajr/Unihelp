package ao.unic.ojj.dao;

import ao.unic.ojj.model.Curso;
import ao.unic.ojj.util.ConexaoBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CursoDAO {

    public List<Curso> listarAtivos() {
        String sql = "SELECT * FROM curso WHERE ativo = TRUE ORDER BY nome";
        List<Curso> lista = new ArrayList<>();
        Connection con = null;
        try {
            con = ConexaoBD.getConexao();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[CursoDAO] Erro ao listar activos: " + e.getMessage());
        } finally {
            ConexaoBD.fechar(con);
        }
        return lista;
    }

    private Curso mapRow(ResultSet rs) throws SQLException {
        return new Curso(
                rs.getInt("id"),
                rs.getString("nome"),
                rs.getBoolean("ativo")
        );
    }
}
