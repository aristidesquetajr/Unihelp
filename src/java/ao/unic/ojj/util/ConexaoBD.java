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

    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    private static final String URL = "jdbc:mysql://localhost:3306/db_unihelp"
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=Africa/Luanda"
            + "&characterEncoding=UTF-8";

    private static final String USUARIO = "root";
    private static final String SENHA = "";

    static {
        try {
            Class.forName(DRIVER);
            System.out.println("[ConexaoBD] Driver MySQL carregado com sucesso.");
        } catch (ClassNotFoundException e) {
            System.err.println("[ConexaoBD] ERRO: Driver MySQL não encontrado.");
            System.err.println("            Verifique se o mysql-connector-j.jar está nas Libraries.");
            throw new RuntimeException("Driver JDBC não encontrado.", e);
        }
    }

    private ConexaoBD() {
    }

    public static Connection getConexao() {
        try {
            Connection con = DriverManager.getConnection(URL, USUARIO, SENHA);
            System.out.println("[ConexaoBD] Ligacao estabelecida com sucesso.");
            return con;
        } catch (SQLException e) {
            System.err.println("[ConexaoBD] ERRO ao ligar à base de dados: " + e.getMessage());
            System.err.println("            Verifique se o MySQL (XAMPP) esta a correr.");
            throw new RuntimeException("Não foi possível ligar à base de dados.", e);
        }
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

    public static boolean testarConexao() {
        Connection con = null;
        try {
            con = getConexao();
            return con != null && !con.isClosed();
        } catch (SQLException e) {
            return false;
        } finally {
            fechar(con);
        }
    }

    public static void main(String[] args) {
        System.out.println("A testar ligacao a base de dados...");

        if (testarConexao()) {
            System.out.println("Ligacao bem sucedida! O sistema esta pronto.");
        } else {
            System.out.println("Falha na ligação. Verifique as configuracoes.");
        }
    }

}
