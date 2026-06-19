package ao.unic.ojj.controller;

import ao.unic.ojj.dao.AtendimentoDAO;
import ao.unic.ojj.dao.FuncionarioDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.model.Funcionario;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.util.SessaoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/funcionario/atendimento/acao")
public class FuncionarioAtendimentoAcaoServlet extends HttpServlet {

    private final AtendimentoDAO atendimentoDAO = new AtendimentoDAO();
    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final FuncionarioDAO funcionarioDAO = new FuncionarioDAO(utilizadorDAO);

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Utilizador utilizador = SessaoUtil.getUtilizador(req);
        if (utilizador == null) {
            res.sendRedirect(req.getContextPath() + "/login?timeout=1");
            return;
        }

        Funcionario funcionario = funcionarioDAO.buscarPorIdUtilizador(utilizador.getId());
        if (funcionario == null) {
            req.getSession().setAttribute("erro", "Não foi encontrado um registo de funcionário para este utilizador.");
            res.sendRedirect(urlOrigem(req));
            return;
        }

        String idParam = req.getParameter("idAtendimento");
        String accao = req.getParameter("accao");
        if (idParam == null || idParam.isBlank() || accao == null || accao.isBlank()) {
            req.getSession().setAttribute("erro", "Pedido inválido. Tente novamente.");
            res.sendRedirect(urlOrigem(req));
            return;
        }

        if ("REJEITAR".equals(accao)) {
            res.sendRedirect(req.getContextPath() + "/funcionario/aprovacao?id=" + idParam);
            return;
        }

        try {
            int idAtendimento = Integer.parseInt(idParam);
            boolean sucesso = switch (accao) {
                case "APROVAR" -> atendimentoDAO.aprovar(idAtendimento, funcionario.getId());
                default -> false;
            };

            if (sucesso) {
                req.getSession().setAttribute("sucesso", "Atendimento actualizado com sucesso.");
            } else {
                req.getSession().setAttribute("erro", "Não foi possível actualizar o atendimento.");
            }
        } catch (NumberFormatException ex) {
            req.getSession().setAttribute("erro", "Identificador de atendimento inválido.");
        }

        res.sendRedirect(urlOrigem(req));
    }

    private String urlOrigem(HttpServletRequest req) {
        String origem = req.getParameter("origem");
        if ("pendentes".equals(origem)) {
            return req.getContextPath() + "/funcionario/pendentes";
        }
        return req.getContextPath() + "/funcionario/dashboard";
    }
}
