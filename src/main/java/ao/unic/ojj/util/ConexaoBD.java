/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author kashiki
 */
public class ConexaoBD {

    private static final String DEFAULT_HOST = "localhost";
    private static final String DEFAULT_PORT = "3306";
    private static final String DEFAULT_DB = "db_unihelp";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "";

    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    private static final String USUARIO = "root";
    private static final String SENHA = "";

    private ConexaoBD() {
    }

    private static String getEnvOrDefault(String chave, String valorPadrao) {
        String valor = System.getenv(chave);
        return (valor != null && !valor.isBlank()) ? valor.trim() : valorPadrao;
    }

    private static String construirUrl() {
        String host = getEnvOrDefault("DB_HOST", DEFAULT_HOST);
        String port = getEnvOrDefault("DB_PORT", DEFAULT_PORT);
        String db = getEnvOrDefault("DB_NAME", DEFAULT_DB);

        boolean ambienteRemoto = !"localhost".equalsIgnoreCase(host)
                && !"127.0.0.1".equals(host);

        StringBuilder url = new StringBuilder("jdbc:mysql://")
                .append(host).append(":").append(port).append("/").append(db)
                .append("?serverTimezone=UTC")
                .append("&useUnicode=true&characterEncoding=UTF-8");

        if (ambienteRemoto) {
            // Exigido por provedores como o Aiven
            url.append("&useSSL=true")
                    .append("&requireSSL=true")
                    .append("&verifyServerCertificate=false");
        } else {
            // XAMPP local normalmente não tem SSL configurado
            url.append("&useSSL=false")
                    .append("&allowPublicKeyRetrieval=true");
        }

        return url.toString();
    }

    public static Connection getConexao() throws SQLException {
        try {
            Class.forName(DRIVER_CLASS);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver JDBC do MySQL (mysql-connector-j) não encontrado no classpath.", e);
        }

        String url = construirUrl();
        String utilizador = getEnvOrDefault("DB_USER", DEFAULT_USER);
        String senha = getEnvOrDefault("DB_PASS", DEFAULT_PASS);

        return DriverManager.getConnection(url, utilizador, senha);
    }

    public static void fechar(Connection con) {
        if (con != null) {
            try {
                con.close();
                System.out.println("[ConexaoBD] Ligacao fechada com sucesso.");
            } catch (SQLException e) {
                System.err.println("[ConexaoBD] ERRO ao fechar ligacao: " + e.getMessage());
            }
        }
    }
}
