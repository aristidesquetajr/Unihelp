/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.util;

import ao.unic.ojj.model.Utilizador;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Utilitário de sessão.
 * Centraliza toda a lógica de verificação de login e perfil.
 * Usado em todos os Servlets para não repetir código.
 *
 * @author kashiki
 */
public class SessaoUtil {

    public static final String CHAVE_UTILIZADOR = "utilizadorLogado";

    private SessaoUtil() {}

    // ─────────────────────────────────────────
    //  GUARDAR utilizador na sessão após login
    // ─────────────────────────────────────────

    public static void guardar(HttpServletRequest req, Utilizador u) {
        req.getSession().setAttribute(CHAVE_UTILIZADOR, u);
    }

    // ─────────────────────────────────────────
    //  OBTER utilizador da sessão
    // ─────────────────────────────────────────

    public static Utilizador getUtilizador(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (Utilizador) session.getAttribute(CHAVE_UTILIZADOR);
    }

    // ─────────────────────────────────────────
    //  VERIFICAÇÕES de estado e perfil
    // ─────────────────────────────────────────

    public static boolean isLogado(HttpServletRequest req) {
        return getUtilizador(req) != null;
    }

    public static boolean isEstudante(HttpServletRequest req) {
        Utilizador u = getUtilizador(req);
        return u != null && Utilizador.Perfil.ESTUDANTE.equals(u.getPerfil());
    }

    public static boolean isFuncionario(HttpServletRequest req) {
        Utilizador u = getUtilizador(req);
        return u != null && Utilizador.Perfil.FUNCIONARIO.equals(u.getPerfil());
    }

    public static boolean isAdmin(HttpServletRequest req) {
        Utilizador u = getUtilizador(req);
        return u != null && Utilizador.Perfil.ADMIN.equals(u.getPerfil());
    }

    // ─────────────────────────────────────────
    //  INVALIDAR sessão no logout
    // ─────────────────────────────────────────

    public static void invalidar(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
    }

    // ─────────────────────────────────────────
    //  REDIRECIONAR para dashboard correcto
    //  conforme o perfil do utilizador
    // ─────────────────────────────────────────

    public static String getDashboard(Utilizador u) {
        return switch (u.getPerfil()) {
            case ESTUDANTE -> "estudante/dashboard";
            case FUNCIONARIO -> "funcionario/dashboard";
            case ADMIN -> "admin/dashboard";
            default -> "login";
        };
    }
}
