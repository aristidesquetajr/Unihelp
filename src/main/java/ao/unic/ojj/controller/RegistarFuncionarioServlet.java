package ao.unic.ojj.controller;

import ao.unic.ojj.dao.FuncionarioDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.RegistoFuncionarioDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * GET /admin/registar-funcionario → Formulário de registo. POST
 * /admin/registar-funcionario → Submete o registo.
 */
@WebServlet("/admin/registar-funcionario")
public class RegistarFuncionarioServlet extends HttpServlet {

    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final FuncionarioDAO funcionarioDAO = new FuncionarioDAO(utilizadorDAO);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/admin/registar-funcionario.jsp")
                .forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        RegistoFuncionarioDTO dto = new RegistoFuncionarioDTO();
        dto.setNome(req.getParameter("nome"));
        dto.setEmail(req.getParameter("email"));
        dto.setSenha(req.getParameter("senha"));
        dto.setConfirmarSenha(req.getParameter("confirmarSenha"));
        dto.setDepartamento(req.getParameter("departamento"));
        dto.setCargo(req.getParameter("cargo"));
        dto.setTelefone(req.getParameter("telefone"));

        if (!dto.isCamposValidos()) {
            req.setAttribute("erro", "Preencha todos os campos obrigatórios.");
            req.setAttribute("dto", dto);
            doGet(req, res);
            return;
        }
        if (!dto.isSenhasIguais()) {
            req.setAttribute("erro", "As senhas não coincidem.");
            req.setAttribute("dto", dto);
            doGet(req, res);
            return;
        }
        if (utilizadorDAO.buscarPorEmail(dto.getEmail(), 0) != null) {
            req.setAttribute("erro", "Já existe um utilizador com este email.");
            req.setAttribute("dto", dto);
            doGet(req, res);
            return;
        }

        boolean sucesso = funcionarioDAO.registar(dto);

        if (sucesso) {
            req.getSession().setAttribute("mensagem", "Funcionário registado com sucesso!");
            res.sendRedirect(req.getContextPath() + "/admin/utilizadores");
        } else {
            req.setAttribute("erro", "Erro ao registar. Tente novamente.");
            doGet(req, res);
        }
    }
}
