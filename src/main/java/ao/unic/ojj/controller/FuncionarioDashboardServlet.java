package ao.unic.ojj.controller;

import ao.unic.ojj.dao.AtendimentoDAO;
import ao.unic.ojj.dao.FuncionarioDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.AtendimentoDTO;
import ao.unic.ojj.model.Funcionario;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.util.SessaoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

/**
 * GET /funcionario/dashboard → Painel do funcionário. Mostra: pendentes, agenda
 * do dia e contadores.
 */
@WebServlet("/funcionario/dashboard")
public class FuncionarioDashboardServlet extends HttpServlet {

    private final AtendimentoDAO atendimentoDAO = new AtendimentoDAO();
    private final UtilizadorDAO utlizadorDAO = new UtilizadorDAO();
    private final FuncionarioDAO funcionarioDAO = new FuncionarioDAO(utlizadorDAO);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Utilizador u = SessaoUtil.getUtilizador(req);
        if (u == null) {
            res.sendRedirect(req.getContextPath() + "/login?timeout=1");
            return;
        }

        Funcionario funcionario = funcionarioDAO.buscarPorIdUtilizador(u.getId());
        if (funcionario == null) {
            req.setAttribute("erro", "Não foi encontrado um registo de funcionário para este utilizador.");
            req.getRequestDispatcher("/WEB-INF/views/funcionario/dashboard.jsp").forward(req, res);
            return;
        }

        List<AtendimentoDTO> pendentes = atendimentoDAO.listarPendentesDTO();

        Date agora = new Date();
        List<AtendimentoDTO> agendaHoje = atendimentoDAO.listarPorDataDTO(agora);

        AtendimentoDTO proximoAtendimento = agendaHoje.stream()
                .filter(a -> a.getDataAgendada() != null && !a.getDataAgendada().before(agora))
                .filter(a -> a.isPendente() || a.isConfirmado())
                .min(Comparator.comparing(AtendimentoDTO::getDataAgendada))
                .orElse(null);

        List<AtendimentoDTO> pendentesResumo = pendentes.stream()
                .limit(5)
                .toList();
        
        req.setAttribute("pendentesResumo", pendentesResumo);
        req.setAttribute("agendaHoje", agendaHoje);
        req.setAttribute("proximoAtendimento", proximoAtendimento);
        req.setAttribute("contPendentes", pendentes.size());
        req.setAttribute("contConfirmadosHoje", agendaHoje.stream().filter(AtendimentoDTO::isConfirmado).count());
        req.setAttribute("contRejeitadosHoje", agendaHoje.stream().filter(AtendimentoDTO::isRejeitado).count());
        req.setAttribute("contTotalHoje", agendaHoje.size());
        req.setAttribute("totalPendentes", pendentes.size());
        req.setAttribute("totalHoje", agendaHoje.size());

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

        req.getRequestDispatcher("/WEB-INF/views/funcionario/dashboard.jsp").forward(req, res);
    }
}
