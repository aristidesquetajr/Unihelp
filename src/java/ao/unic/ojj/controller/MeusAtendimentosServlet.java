package ao.unic.ojj.controller;

import ao.unic.ojj.dao.AtendimentoDAO;
import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.AtendimentoDTO;
import ao.unic.ojj.model.Atendimento;
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
 * GET /estudante/atendimentos → Histórico de atendimentos do estudante.
 */
@WebServlet("/estudante/atendimentos")
public class MeusAtendimentosServlet extends HttpServlet {

    private final AtendimentoDAO atendimentoDAO = new AtendimentoDAO();
    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String estado = req.getParameter("estado");

        Utilizador u = SessaoUtil.getUtilizador(req);
        if (u == null) {
            res.sendRedirect(req.getContextPath() + "/login?timeout=1");
            return;
        }

        Estudante e = estudanteDAO.buscarPorIdUtilizador(u.getId());
        if (e == null) {
            req.setAttribute("erro", "Não foi encontrado um registo de estudante para este utilizador.");
            req.setAttribute("atendimentos", List.of());
            req.setAttribute("totalAtendimentos", 0);
            req.getRequestDispatcher("/WEB-INF/views/estudante/atendimentos.jsp")
                    .forward(req, res);
            return;
        }

        List<AtendimentoDTO> atendimentos = atendimentoDAO.listarPorEstudanteDTO(e.getId());
        List<AtendimentoDTO> atendimentosFiltrados = atendimentos;

        req.setAttribute("contPendentes", atendimentos.stream().filter(AtendimentoDTO::isPendente).count());
        req.setAttribute("contConfirmados", atendimentos.stream().filter(AtendimentoDTO::isConfirmado).count());
        req.setAttribute("contRejeitados", atendimentos.stream().filter(AtendimentoDTO::isRejeitado).count());

        if (estado != null && (estado.equals(Atendimento.Estado.CONFIRMADO.name()) || estado.equals(Atendimento.Estado.PENDENTE.name()) || estado.equals(Atendimento.Estado.REJEITADO.name()))) {
            atendimentosFiltrados = atendimentos.stream().filter(a -> {
                return a.getEstado().name().equals(estado);
            }).toList();
        }

        req.setAttribute("atendimentos", atendimentosFiltrados);
        req.setAttribute("totalAtendimentos", atendimentosFiltrados.size());

        // Mensagem de sucesso após agendamento (vem da sessão)
        String sucesso = (String) req.getSession().getAttribute("sucesso");
        if (sucesso != null) {
            req.setAttribute("sucesso", sucesso);
            req.getSession().removeAttribute("sucesso");
        }

        req.getRequestDispatcher("/WEB-INF/views/estudante/atendimentos.jsp")
                .forward(req, res);
    }
}
