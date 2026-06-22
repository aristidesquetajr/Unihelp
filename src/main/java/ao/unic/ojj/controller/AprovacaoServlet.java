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

/**
 * POST /funcionario/aprovacao → Aprova ou rejeita um atendimento.
 *
 * Parâmetros esperados: idAtendimento → id do atendimento acao → "aprovar" ou
 * "rejeitar" motivo → texto obrigatório quando acao = "rejeitar"
 */
@WebServlet("/funcionario/aprovacao")
public class AprovacaoServlet extends HttpServlet {

    private final AtendimentoDAO atendimentoDAO = new AtendimentoDAO();
    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final FuncionarioDAO funcionarioDAO = new FuncionarioDAO(utilizadorDAO);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        String idParam = req.getParameter("id");
        AtendimentoDTO atendimento = null;
        if (idParam == null || idParam.isBlank()) {
            req.setAttribute("erro", "Identificador de atendimento não informado.");
        } else {
            try {
                int id = Integer.parseInt(idParam);
                atendimento = atendimentoDAO.buscarPorIdDTO(id);
            } catch (NumberFormatException ex) {
                req.setAttribute("erro", "Identificador de atendimento inválido.");
            }
        }

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

        req.setAttribute("atendimento", atendimento);
        req.getRequestDispatcher("/WEB-INF/views/funcionario/aprovacao.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idStr = primeiroNaoVazio(req.getParameter("idAtendimento"), req.getParameter("id"));
        String acao = primeiroNaoVazio(req.getParameter("acao"), req.getParameter("accao"));

        if (idStr == null || acao == null) {
            res.sendRedirect(req.getContextPath() + "/funcionario/pendentes");
            return;
        }

        // Obter o funcionário logado
        Utilizador u = SessaoUtil.getUtilizador(req);
        if (u == null) {
            res.sendRedirect(req.getContextPath() + "/login?timeout=1");
            return;
        }

        Funcionario f = funcionarioDAO.buscarPorIdUtilizador(u.getId());
        if (f == null) {
            req.getSession().setAttribute("erro", "Não foi encontrado um registo de funcionário para este utilizador.");
            res.sendRedirect(req.getContextPath() + "/funcionario/aprovacao?id=" + idStr);
            return;
        }

        int idAtendimento;
        try {
            idAtendimento = Integer.parseInt(idStr);
        } catch (NumberFormatException ex) {
            req.getSession().setAttribute("erro", "Identificador de atendimento inválido.");
            res.sendRedirect(req.getContextPath() + "/funcionario/pendentes");
            return;
        }

        boolean sucesso = false;
        String acaoNormalizada = acao.trim().toLowerCase();

        if ("aprovar".equals(acaoNormalizada)) {
            sucesso = atendimentoDAO.aprovar(idAtendimento, f.getId());
            req.getSession().setAttribute(sucesso ? "sucesso" : "erro", sucesso
                    ? "Atendimento confirmado com sucesso."
                    : "Erro ao confirmar o atendimento.");

        } else if ("rejeitar".equals(acaoNormalizada)) {
            String motivo = primeiroNaoVazio(req.getParameter("motivo"), req.getParameter("observacao"));
            if (motivo == null || motivo.isBlank()) {
                req.getSession().setAttribute("erro",
                        "Indique o motivo da rejeição.");
                res.sendRedirect(req.getContextPath() + "/funcionario/aprovacao?id=" + idAtendimento);
                return;
            }
            sucesso = atendimentoDAO.rejeitar(idAtendimento, f.getId(), motivo);
            req.getSession().setAttribute(sucesso ? "sucesso" : "erro", sucesso
                    ? "Atendimento rejeitado."
                    : "Erro ao rejeitar o atendimento.");

        } else {
            req.getSession().setAttribute("erro", "Acção inválida.");
        }

        res.sendRedirect(req.getContextPath() + "/funcionario/pendentes");
    }

    private String primeiroNaoVazio(String principal, String alternativa) {
        if (principal != null && !principal.isBlank()) {
            return principal;
        }
        if (alternativa != null && !alternativa.isBlank()) {
            return alternativa;
        }
        return null;
    }
}
