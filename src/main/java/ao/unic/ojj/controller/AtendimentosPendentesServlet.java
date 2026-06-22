package ao.unic.ojj.controller;

import ao.unic.ojj.dao.AtendimentoDAO;
import ao.unic.ojj.dto.AtendimentoDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * GET /funcionario/pendentes → Lista de atendimentos PENDENTES.
 */
@WebServlet("/funcionario/pendentes")
public class AtendimentosPendentesServlet extends HttpServlet {

    private final AtendimentoDAO atendimentoDAO = new AtendimentoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        List<AtendimentoDTO> pendentes = atendimentoDAO.listarPendentesDTO();
        req.setAttribute("pendentes", pendentes);
        req.setAttribute("atendimentos", pendentes);
        req.setAttribute("contPendentes", pendentes.size());

        String sucesso = (String) req.getSession().getAttribute("sucesso");
        if (sucesso != null) {
            req.setAttribute("sucesso", sucesso);
            req.getSession().removeAttribute("sucesso");
        }

        String erro = (String) req.getSession().getAttribute("erro");
        if (erro != null) {
            req.setAttribute("erro", erro);
            req.getSession().removeAttribute("erro");
        }

        req.getRequestDispatcher("/WEB-INF/views/funcionario/pendentes.jsp")
           .forward(req, res);
    }
}
