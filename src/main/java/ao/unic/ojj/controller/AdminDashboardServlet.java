package ao.unic.ojj.controller;

import ao.unic.ojj.dao.CursoDAO;
import ao.unic.ojj.dao.DisciplinaDAO;
import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.FuncionarioDAO;
import ao.unic.ojj.dao.PeriodoLetivoDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.model.PeriodoLetivo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * GET /admin/dashboard → Painel do administrador com visão geral do sistema.
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);
    private final FuncionarioDAO funcionarioDAO = new FuncionarioDAO(utilizadorDAO);
    private final CursoDAO cursoDAO = new CursoDAO();
    private final DisciplinaDAO disciplinaDAO = new DisciplinaDAO();
    private final PeriodoLetivoDAO periodoDAO = new PeriodoLetivoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        PeriodoLetivo periodoAtivo = periodoDAO.buscarAtivo();

        req.setAttribute("totalUtilizadores", utilizadorDAO.listar().size());
        req.setAttribute("totalEstudantes", estudanteDAO.listar().size());
        req.setAttribute("totalFuncionarios", funcionarioDAO.listar().size());
        req.setAttribute("totalCursos", cursoDAO.listarAtivos().size());
        req.setAttribute("contDisciplinas", disciplinaDAO.listar().size());
        req.setAttribute("periodoAtivo", periodoAtivo);
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, res);
    }
}
