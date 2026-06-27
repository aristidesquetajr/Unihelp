package ao.unic.ojj.controller;

import ao.unic.ojj.dao.CursoDAO;
import ao.unic.ojj.dao.PeriodoLetivoDAO;
import ao.unic.ojj.dao.TurmaDAO;
import ao.unic.ojj.dto.TurmaDTO;
import ao.unic.ojj.model.Curso;
import ao.unic.ojj.model.PeriodoLetivo;
import ao.unic.ojj.model.Turma;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * GET /admin/turmas → Lista de turmas. POST /admin/turmas → Criar, editar ou
 * eliminar turma.
 */
@WebServlet("/admin/turmas")
public class GerirTurmasServlet extends HttpServlet {

    private final TurmaDAO turmaDAO = new TurmaDAO();
    private final CursoDAO cursoDAO = new CursoDAO();
    private final PeriodoLetivoDAO periodoDAO = new PeriodoLetivoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String filtroNome = req.getParameter("nome");
        String cursoParam = req.getParameter("idCurso");
        String periodoParam = req.getParameter("idPeriodoLetivo");

        Integer idCurso = null;
        Integer idPeriodoLetivo = null;
        try {
            idCurso = Integer.valueOf(cursoParam);
        } catch (NumberFormatException ignored) {
        }
        try {
            idPeriodoLetivo = Integer.valueOf(periodoParam);
        } catch (NumberFormatException ignored) {
        }

        List<TurmaDTO> turmas;
        if (filtroNome != null || idCurso != null || idPeriodoLetivo != null) {
            turmas = turmaDAO.pesquisar(filtroNome, idCurso, idPeriodoLetivo);
        } else {
            turmas = turmaDAO.listar();
        }

        List<Curso> cursos = cursoDAO.listarAtivos();
        List<PeriodoLetivo> periodos = periodoDAO.listar();

        req.setAttribute("turmas", turmas);
        req.setAttribute("cursos", cursos);
        req.setAttribute("periodos", periodos);

        String idParam = req.getParameter("editar");
        if (idParam != null) {
            req.setAttribute("turmaEditar",
                    turmaDAO.buscarPorId(Integer.parseInt(idParam)));
        }

        String mensagem = (String) req.getSession().getAttribute("mensagem");
        if (mensagem != null) {
            req.setAttribute("mensagem", mensagem);
            req.getSession().removeAttribute("mensagem");
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/turmas.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");
        boolean sucesso;

        switch (acao != null ? acao : "") {
            case "criar" -> {
                sucesso = turmaDAO.inserir(new Turma(
                        req.getParameter("nome"),
                        Integer.parseInt(req.getParameter("idCurso")),
                        Integer.parseInt(req.getParameter("idPeriodoLetivo")),
                        req.getParameter("sala"),
                        Integer.parseInt(req.getParameter("anoAcademico"))
                ));
                req.getSession().setAttribute("mensagem",
                        sucesso ? "Turma criada." : "Erro ao criar turma.");
            }

            case "editar" -> {
                sucesso = turmaDAO.atualizar(new Turma(
                        Integer.parseInt(req.getParameter("id")),
                        req.getParameter("nome"),
                        Integer.parseInt(req.getParameter("idCurso")),
                        Integer.parseInt(req.getParameter("idPeriodoLetivo")),
                        req.getParameter("sala"),
                        Integer.parseInt(req.getParameter("anoAcademico"))
                ));
                req.getSession().setAttribute("mensagem",
                        sucesso ? "Turma actualizada." : "Erro ao actualizar.");
            }

            case "eliminar" -> {
                sucesso = turmaDAO.eliminar(Integer.parseInt(req.getParameter("id")));
                req.getSession().setAttribute("mensagem",
                        sucesso ? "Turma eliminada." : "Não é possível eliminar — existem inscrições associadas.");
            }
        }

        res.sendRedirect(req.getContextPath() + "/admin/turmas");
    }
}
