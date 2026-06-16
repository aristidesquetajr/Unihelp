package ao.unic.ojj.controller;

import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.EstudanteDetalheDTO;
import ao.unic.ojj.model.Estudante;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.util.SessaoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * GET /estudante/perfil → Exibe o perfil detalhado do estudante logado.
 */
@WebServlet("/estudante/perfil")
public class EstudantePerfilServlet extends HttpServlet {

    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Utilizador u = SessaoUtil.getUtilizador(req);
        if (u == null) {
            res.sendRedirect(req.getContextPath() + "/login?timeout=1");
            return;
        }

        Estudante e = estudanteDAO.buscarPorIdUtilizador(u.getId());
        if (e == null) {
            req.setAttribute("erro", "Não foi encontrado um registo de estudante para este utilizador.");
            req.getRequestDispatcher("/WEB-INF/views/estudante/perfil.jsp").forward(req, res);
            return;
        }

        EstudanteDetalheDTO estudante = estudanteDAO.buscarDetalhesPorId(e.getId());

        req.setAttribute("estudante", estudante);
        req.getRequestDispatcher("/WEB-INF/views/estudante/perfil.jsp").forward(req, res);
    }
}
