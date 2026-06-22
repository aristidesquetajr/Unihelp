package ao.unic.ojj.controller;

import ao.unic.ojj.dao.CursoDAO;
import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.PeriodoLetivoDAO;
import ao.unic.ojj.dao.TurmaDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.RegistoEstudanteDTO;
import ao.unic.ojj.model.Turma;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * GET /funcionario/registar-estudante → Formulário de registo. POST
 * /funcionario/registar-estudante → Submete o registo.
 */
@WebServlet("/funcionario/registar-estudante")
public class RegistarEstudanteServlet extends HttpServlet {

    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);
    private final CursoDAO cursoDAO = new CursoDAO();
    private final PeriodoLetivoDAO periodoLetivoDAO = new PeriodoLetivoDAO();
    private final TurmaDAO turmaDAO = new TurmaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String sucesso = (String) req.getSession().getAttribute("sucesso");
        if (sucesso != null) {
            req.setAttribute("sucesso", sucesso);
            req.getSession().removeAttribute("sucesso");
        }

        carregarOpcoes(req);
        req.getRequestDispatcher("/WEB-INF/views/funcionario/registar-estudante.jsp")
                .forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        RegistoEstudanteDTO dto = new RegistoEstudanteDTO();
        dto.setNome(limpar(req.getParameter("nome")));
        dto.setEmail(limpar(req.getParameter("email")));
        dto.setSenha(req.getParameter("senha"));
        dto.setConfirmarSenha(req.getParameter("confirmarSenha"));
        dto.setNumeroEstudante(limpar(req.getParameter("numeroEstudante")));
        dto.setTelefone(limpar(req.getParameter("telefone")));
        dto.setIdPeriodoLetivo(parseInt(req.getParameter("idPeriodoLetivo")));
        dto.setIdCurso(parseInt(req.getParameter("idCurso")));
        dto.setIdTurma(parseInt(req.getParameter("idTurma")));

        // Validações
        if (!dto.isCamposValidos()) {
            forwardComErro(req, res, dto, "Preencha todos os campos obrigatórios.");
            return;
        }

        if (dto.getSenha().length() < 6) {
            forwardComErro(req, res, dto, "A senha deve ter pelo menos 6 caracteres.");
            return;
        }

        if (!dto.isSenhasIguais()) {
            forwardComErro(req, res, dto, "As senhas não coincidem.");
            return;
        }

        // Verificar se o email já existe
        if (utilizadorDAO.buscarPorEmail(dto.getEmail(), 0) != null) {
            forwardComErro(req, res, dto, "Já existe um utilizador com este email.");
            return;
        }

        if (estudanteDAO.existeNumeroEstudante(dto.getNumeroEstudante())) {
            forwardComErro(req, res, dto, "Já existe um estudante com este número.");
            return;
        }

        Turma turma = turmaDAO.buscarPorId(dto.getIdTurma());
        if (turma == null
                || turma.getIdCurso() != dto.getIdCurso()
                || turma.getIdPeriodoLetivo() != dto.getIdPeriodoLetivo()) {
            forwardComErro(req, res, dto, "Seleccione uma turma compatível com o curso e ano letivo.");
            return;
        }

        boolean sucesso = estudanteDAO.registar(dto);

        if (sucesso) {
            req.getSession().setAttribute("sucesso",
                    "Estudante registado com sucesso!");
            res.sendRedirect(req.getContextPath() + "/funcionario/registar-estudante");
        } else {
            forwardComErro(req, res, dto, "Erro ao registar o estudante. Tente novamente.");
        }
    }

    private void forwardComErro(HttpServletRequest req, HttpServletResponse res,
            RegistoEstudanteDTO dto, String mensagem) throws ServletException, IOException {
        req.setAttribute("erro", mensagem);
        req.setAttribute("dto", dto);
        carregarOpcoes(req);
        req.getRequestDispatcher("/WEB-INF/views/funcionario/registar-estudante.jsp")
                .forward(req, res);
    }

    private void carregarOpcoes(HttpServletRequest req) {
        req.setAttribute("cursos", cursoDAO.listarAtivos());
        req.setAttribute("periodos", periodoLetivoDAO.listar());
        req.setAttribute("turmas", turmaDAO.listar());
    }

    private int parseInt(String valor) {
        try {
            return valor == null || valor.isBlank() ? 0 : Integer.parseInt(valor);
        } catch (NumberFormatException ex) {
            return 0;
        }
    }

    private String limpar(String valor) {
        return valor == null ? null : valor.trim();
    }
}
