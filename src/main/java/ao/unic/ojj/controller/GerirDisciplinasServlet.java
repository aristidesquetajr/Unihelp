package ao.unic.ojj.controller;

import ao.unic.ojj.dao.DisciplinaDAO;
import ao.unic.ojj.model.Disciplina;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/disciplinas")
public class GerirDisciplinasServlet extends HttpServlet {

    private final DisciplinaDAO disciplinaDAO = new DisciplinaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        List<Disciplina> disciplinas = disciplinaDAO.listar();
        req.setAttribute("disciplinas", disciplinas);

        String mensagem = (String) req.getSession().getAttribute("mensagem");
        if (mensagem != null) {
            req.setAttribute("mensagem", mensagem);
            req.getSession().removeAttribute("mensagem");
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/disciplinas.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");
        boolean sucesso;

        switch (acao != null ? acao : "") {
            case "criar" -> {
                sucesso = disciplinaDAO.inserir(new Disciplina(
                        req.getParameter("nome"),
                        req.getParameter("codigo")
                ));
                req.getSession().setAttribute("mensagem",
                        sucesso ? "Disciplina criada." : "Erro ao criar disciplina.");
            }

            case "editar" -> {
                sucesso = disciplinaDAO.atualizar(new Disciplina(
                        Integer.parseInt(req.getParameter("id")),
                        req.getParameter("nome"),
                        req.getParameter("codigo")
                ));
                req.getSession().setAttribute("mensagem",
                        sucesso ? "Disciplina actualizada." : "Erro ao actualizar disciplina.");
            }

            case "eliminar" -> {
                sucesso = disciplinaDAO.eliminar(Integer.parseInt(req.getParameter("id")));
                req.getSession().setAttribute("mensagem",
                        sucesso ? "Disciplina eliminada." : "Não é possível eliminar — existem notas associadas.");
            }
        }

        res.sendRedirect(req.getContextPath() + "/admin/disciplinas");
    }
}
