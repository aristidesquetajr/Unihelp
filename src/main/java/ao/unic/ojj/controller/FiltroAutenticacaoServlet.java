/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.controller;

import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.util.SessaoUtil;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Filtro de autenticação e autorização.
 *
 * Intercepta TODOS os pedidos ao servidor e verifica: 1. Se o utilizador está
 * logado (excepto rotas públicas) 2. Se o perfil do utilizador tem acesso à
 * rota pedida
 *
 * Rotas públicas (sem login necessário): / → landing page /login → página de
 * login /logout → encerrar sessão /assets/ → ficheiros estáticos (CSS, JS)
 *
 * Regras de perfil: /estudante/* → apenas ESTUDANTE /funcionario/* → apenas
 * FUNCIONARIO /admin/* → apenas ADMIN
 *
 * @author kashiki
 */
@WebFilter("/*")
public class FiltroAutenticacaoServlet implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        DispatcherType dispatcherType = request.getDispatcherType();
        if (dispatcherType == DispatcherType.FORWARD || dispatcherType == DispatcherType.ERROR) {
            chain.doFilter(req, res);
            return;
        }

        String uri = request.getRequestURI();
        String ctx = request.getContextPath();

        if (isRotaPublica(uri, ctx)) {
            chain.doFilter(req, res);
            return;
        }

        Utilizador utilizador = SessaoUtil.getUtilizador(request);
        if (utilizador == null) {
            if (eRotaProtegida(uri, ctx)) {
                response.sendRedirect(ctx + "/login");
                return;
            }

            chain.doFilter(req, res);
            return;
        }

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

        chain.doFilter(req, res);
    }

    private boolean isRotaPublica(String uri, String ctx) {
        return uri.equals(ctx + "/")
                || uri.equals(ctx + "/login")
                || uri.equals(ctx + "/logout")
                || uri.startsWith(ctx + "/assets/")
                || uri.startsWith(ctx + "/erro/");
    }

    private boolean eRotaProtegida(String uri, String ctx) {
        return uri.startsWith(ctx + "/estudante/")
                || uri.startsWith(ctx + "/funcionario/")
                || uri.startsWith(ctx + "/admin/");
    }
}
