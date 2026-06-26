package ao.unic.ojj.controller;

import ao.unic.ojj.dao.PeriodoLetivoDAO;
import ao.unic.ojj.model.PeriodoLetivo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/admin/periodos")
public class GerirPeriodosServlet extends HttpServlet {

    private final PeriodoLetivoDAO periodoDAO = new PeriodoLetivoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        List<PeriodoLetivo> periodos = periodoDAO.listar();
        req.setAttribute("periodos", periodos);

        String mensagem = (String) req.getSession().getAttribute("mensagem");
        if (mensagem != null) {
            req.setAttribute("mensagem", mensagem);
            req.getSession().removeAttribute("mensagem");
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/periodos.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");
        boolean sucesso = false;

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            if ("criar".equals(acao)) {
                PeriodoLetivo p = new PeriodoLetivo(
                    req.getParameter("anoLetivo"),
                    Integer.parseInt(req.getParameter("semestre")),
                    sdf.parse(req.getParameter("dataInicio")),
                    sdf.parse(req.getParameter("dataFim")),
                    req.getParameter("ativo") != null
                );
                sucesso = periodoDAO.inserir(p);
                req.getSession().setAttribute("mensagem",
                    sucesso ? "Período criado." : "Erro ao criar período.");

            } else if ("editar".equals(acao)) {
                PeriodoLetivo p = new PeriodoLetivo(
                    Integer.parseInt(req.getParameter("id")),
                    req.getParameter("anoLetivo"),
                    Integer.parseInt(req.getParameter("semestre")),
                    sdf.parse(req.getParameter("dataInicio")),
                    sdf.parse(req.getParameter("dataFim")),
                    req.getParameter("ativo") != null
                );
                sucesso = periodoDAO.atualizar(p);
                req.getSession().setAttribute("mensagem",
                    sucesso ? "Período actualizado." : "Erro ao actualizar período.");

            } else if ("eliminar".equals(acao)) {
                sucesso = periodoDAO.eliminar(Integer.parseInt(req.getParameter("id")));
                req.getSession().setAttribute("mensagem",
                    sucesso ? "Período eliminado." : "Erro ao eliminar período.");

            } else if ("activar".equals(acao)) {
                List<PeriodoLetivo> todos = periodoDAO.listar();
                for (PeriodoLetivo p : todos) {
                    p.setAtivo(false);
                    periodoDAO.atualizar(p);
                }
                PeriodoLetivo alvo = periodoDAO.buscarPorId(Integer.parseInt(req.getParameter("id")));
                alvo.setAtivo(true);
                sucesso = periodoDAO.atualizar(alvo);
                req.getSession().setAttribute("mensagem",
                    sucesso ? "Período activado." : "Erro ao activar.");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("mensagem", "Erro: " + e.getMessage());
        }

        res.sendRedirect(req.getContextPath() + "/admin/periodos");
    }
}
