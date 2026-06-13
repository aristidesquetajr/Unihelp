/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.util;

import ao.unic.ojj.model.Utilizador;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Filtro de autenticação e autorização.
 *
 * Intercepta TODOS os pedidos ao servidor e verifica:
 *  1. Se o utilizador está logado (excepto rotas públicas)
 *  2. Se o perfil do utilizador tem acesso à rota pedida
 *
 * Rotas públicas (sem login necessário):
 *   /        → landing page
 *   /login   → página de login
 *   /logout  → encerrar sessão
 *   /assets/ → ficheiros estáticos (CSS, JS)
 *
 * Regras de perfil:
 *   /estudante/*   → apenas ESTUDANTE
 *   /funcionario/* → apenas FUNCIONARIO
 *   /admin/*       → apenas ADMIN
 *
 * @author kashiki
 */
@WebFilter("/*")
public class FiltroAutenticacao implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        String ctx = request.getContextPath();

        // ── Rotas sempre permitidas ────────────────────────
        if (isRotaPublica(uri, ctx)) {
            chain.doFilter(req, res);
            return;
        }

        // ── Verificar se está logado ───────────────────────
        Utilizador utilizador = SessaoUtil.getUtilizador(request);
        if (utilizador == null) {
            response.sendRedirect(ctx + "/login");
            return;
        }

        // ── Verificar autorização por perfil ───────────────
        String perfil = utilizador.getPerfil().name();

        if (uri.contains("/estudante/") && !perfil.equals("ESTUDANTE")) {
            response.sendRedirect(ctx + "/erro/403");
            return;
        }
        if (uri.contains("/funcionario/") && !perfil.equals("FUNCIONARIO")) {
            response.sendRedirect(ctx + "/erro/403");
            return;
        }
        if (uri.contains("/admin/") && !perfil.equals("ADMIN")) {
            response.sendRedirect(ctx + "/erro/403");
            return;
        }

        // ── Tudo certo — continua ──────────────────────────
        chain.doFilter(req, res);
    }

    private boolean isRotaPublica(String uri, String ctx) {
        return uri.equals(ctx + "/")
            || uri.equals(ctx + "/login")
            || uri.equals(ctx + "/logout")
            || uri.startsWith(ctx + "/assets/")
            || uri.startsWith(ctx + "/erro/");
    }
}
