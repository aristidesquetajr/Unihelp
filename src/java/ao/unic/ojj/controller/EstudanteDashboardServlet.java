package ao.unic.ojj.controller;

import ao.unic.ojj.dao.AtendimentoDAO;
import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.AtendimentoDTO;
import ao.unic.ojj.model.Estudante;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.util.SessaoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * GET /estudante/dashboard → Painel principal do estudante. Mostra: inscrição
 * activa, próximos atendimentos e notas recentes.
 */
@WebServlet("/estudante/dashboard")
public class EstudanteDashboardServlet extends HttpServlet {

    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);
    private final AtendimentoDAO atendimentoDAO = new AtendimentoDAO();

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
            req.getRequestDispatcher("/WEB-INF/views/estudante/dashboard.jsp").forward(req, res);
            return;
        }

        List<AtendimentoDTO> atendimentos = atendimentoDAO.listarPorEstudanteDTO(e.getId());

        req.setAttribute("atendimentos", atendimentos);
        req.setAttribute("contPendentes", atendimentos.stream().filter(AtendimentoDTO::isPendente).count());
        req.setAttribute("contConfirmados", atendimentos.stream().filter(AtendimentoDTO::isConfirmado).count());

        req.getRequestDispatcher("/WEB-INF/views/estudante/dashboard.jsp").forward(req, res);
    }
}
