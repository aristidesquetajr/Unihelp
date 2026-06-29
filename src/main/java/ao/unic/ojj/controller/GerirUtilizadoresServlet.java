package ao.unic.ojj.controller;

import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.model.Utilizador;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * GET /admin/utilizadores → Lista todos os utilizadores. POST
 * /admin/utilizadores?acao= → Bloquear ou activar utilizador.
 *
 * Parâmetros POST: acao → "bloquear" ou "activar" id → id do utilizador
 */
@WebServlet("/admin/utilizadores")
public class GerirUtilizadoresServlet extends HttpServlet {

    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String q = req.getParameter("q");
        String perfil = req.getParameter("perfil");
        String status = req.getParameter("status");

        List<Utilizador> utilizadores;
        if (q != null || perfil != null || status != null) {
            utilizadores = utilizadorDAO.pesquisar(q, perfil, status);
        } else {
            utilizadores = utilizadorDAO.listar();
        }

        req.setAttribute("utilizadores", utilizadores);
        req.setAttribute("totalUtilizadores", utilizadores.size());

        String mensagem = (String) req.getSession().getAttribute("mensagem");
        if (mensagem != null) {
            req.setAttribute("mensagem", mensagem);
            req.getSession().removeAttribute("mensagem");
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/utilizadores.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");
        String idStr = req.getParameter("id");

        if (acao == null || idStr == null) {
            res.sendRedirect(req.getContextPath() + "/admin/utilizadores");
            return;
        }

        int id = Integer.parseInt(idStr);
        boolean sucesso;

        if ("bloquear".equals(acao)) {
            sucesso = utilizadorDAO.alterarStatus(id, Utilizador.Status.BLOQUEADO);
            req.getSession().setAttribute("mensagem",
                    sucesso ? "Utilizador bloqueado." : "Erro ao bloquear.");
        } else if ("activar".equals(acao)) {
            sucesso = utilizadorDAO.alterarStatus(id, Utilizador.Status.ACTIVO);
            req.getSession().setAttribute("mensagem",
                    sucesso ? "Utilizador activado." : "Erro ao activar.");
        }

        res.sendRedirect(req.getContextPath() + "/admin/utilizadores");
    }
}
