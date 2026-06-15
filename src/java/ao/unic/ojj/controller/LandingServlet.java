package ao.unic.ojj.controller;

import ao.unic.ojj.util.SessaoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * GET / → Mostra a landing page. Se o utilizador já estiver logado, redireciona
 * para o seu dashboard.
 */
@WebServlet("/")
public class LandingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Se já estiver logado, não mostra a landing — vai para o dashboard
        if (SessaoUtil.isLogado(req)) {
            res.sendRedirect(req.getContextPath()
                    + "/" + SessaoUtil.getDashboard(SessaoUtil.getUtilizador(req)));
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/landing.jsp").forward(req, res);
    }
}
