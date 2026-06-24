package ao.unic.ojj.controller;

import ao.unic.ojj.dao.CursoDAO;
import ao.unic.ojj.model.Curso;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * GET /admin/cursos → Lista de cursos. POST /admin/cursos → Criar, editar ou
 * eliminar curso.
 *
 * Parâmetros POST: acao → "criar" | "editar" | "eliminar"
 */
@WebServlet("/admin/cursos")
public class GerirCursosServlet extends HttpServlet {

    private final CursoDAO cursoDAO = new CursoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        List<Curso> cursos = cursoDAO.listar();
        req.setAttribute("cursos", cursos);

        // Edição: carregar curso seleccionado
        String idParam = req.getParameter("editar");
        if (idParam != null) {
            Curso c = cursoDAO.buscarPorId(Integer.parseInt(idParam));
            req.setAttribute("cursoEditar", c);
        }

        String mensagem = (String) req.getSession().getAttribute("mensagem");
        if (mensagem != null) {
            req.setAttribute("mensagem", mensagem);
            req.getSession().removeAttribute("mensagem");
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/cursos.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");
        boolean sucesso = false;

        switch (acao != null ? acao : "") {
            case "ADICIONAR":
                Curso novo = new Curso(req.getParameter("nome"), true);
                sucesso = cursoDAO.inserir(novo);
                req.getSession().setAttribute("mensagem",
                        sucesso ? "Curso criado." : "Erro ao criar curso.");
                break;

            case "EDITAR":
                Curso editado = new Curso(
                        Integer.parseInt(req.getParameter("id")),
                        req.getParameter("nome"),
                        "on".equals(req.getParameter("ativo"))
                );
                sucesso = cursoDAO.atualizar(editado);
                req.getSession().setAttribute("mensagem",
                        sucesso ? "Curso actualizado." : "Erro ao actualizar.");
                break;

            case "ELIMINAR":
                sucesso = cursoDAO.eliminar(Integer.parseInt(req.getParameter("id")));
                req.getSession().setAttribute("mensagem",
                        sucesso ? "Curso eliminado." : "Não é possível eliminar — existem turmas associadas.");
                break;
        }

        res.sendRedirect(req.getContextPath() + "/admin/cursos");
    }    
    
}
