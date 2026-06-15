package ao.unic.ojj.controller;

import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.util.SessaoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * GET /login → Mostra o formulário de login. POST /login → Processa as
 * credenciais e cria a sessão.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Se já estiver logado, redireciona para o dashboard
        if (SessaoUtil.isLogado(req)) {
            res.sendRedirect(req.getContextPath()
                    + "/" + SessaoUtil.getDashboard(SessaoUtil.getUtilizador(req)));
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        // Validação básica dos campos
        if (email == null || email.isBlank() || senha == null || senha.isBlank()) {
            req.setAttribute("erro", "Preencha o email e a senha.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, res);
            return;
        }

        // Autenticação na base de dados
        Utilizador utilizador = utilizadorDAO.autenticar(email.trim(), senha);

        if (utilizador == null) {
            req.setAttribute("erro", "Email ou senha incorrectos. Verifique os seus dados.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, res);
            return;
        }

        // Verificar se a conta está bloqueada
        if (Utilizador.Status.BLOQUEADO.equals(utilizador.getStatus())) {
            req.setAttribute("erro", "A sua conta está bloqueada. Contacte o administrador.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, res);
            return;
        }

        // Guardar na sessão e redirecionar para o dashboard correcto
        SessaoUtil.guardar(req, utilizador);
        res.sendRedirect(req.getContextPath()
                + "/" + SessaoUtil.getDashboard(utilizador));
    }
}
