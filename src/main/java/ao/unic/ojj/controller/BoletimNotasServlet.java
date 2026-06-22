package ao.unic.ojj.controller;

import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.NotaDAO;
import ao.unic.ojj.dao.PeriodoLetivoDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.NotaDetalheDTO;
import ao.unic.ojj.model.BoletimPeriodo;
import ao.unic.ojj.model.Estudante;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.model.PeriodoLetivo;
import ao.unic.ojj.util.BoletimNotasUtil;
import ao.unic.ojj.util.SessaoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * GET /estudante/notas → Boletim de notas do estudante. Suporta filtro por
 * período lectivo via parâmetro ?periodo=X
 */
@WebServlet("/estudante/boletim")
public class BoletimNotasServlet extends HttpServlet {

    private final NotaDAO notaDAO = new NotaDAO();
    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);
    private final PeriodoLetivoDAO periodoLetivoDAO = new PeriodoLetivoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Utilizador u = SessaoUtil.getUtilizador(req);
        if (u == null) {
            res.sendRedirect(req.getContextPath() + "/login?timeout=1");
            return;
        }

        Estudante e = estudanteDAO.buscarPorIdUtilizador(u.getId());
        if (e == null) {
            req.setAttribute("erro", "Não foi encontrado um registo de estudante para este utilizador.");
            req.setAttribute("notas", List.of());
            req.setAttribute("periodos", periodoLetivoDAO.listar());
            req.getRequestDispatcher("/WEB-INF/views/estudante/boletim.jsp").forward(req, res);
            return;
        }

        List<PeriodoLetivo> periodos = periodoLetivoDAO.listar();

        String periodoParam = req.getParameter("periodoId");
        String disciplinaParam = req.getParameter("disciplina");
        List<NotaDetalheDTO> notas;

        if (periodoParam != null && !periodoParam.isBlank()) {
            try {
                int idPeriodo = Integer.parseInt(periodoParam);
                notas = notaDAO.listarDetalhesPorEstudanteEPeriodo(e.getId(), idPeriodo);
                req.setAttribute("periodoFiltrado", idPeriodo);
            } catch (NumberFormatException ex) {
                notas = notaDAO.listarDetalhesPorEstudante(e.getId());
                req.setAttribute("erro", "Período inválido. Foram apresentadas todas as notas.");
            }
        } else {
            notas = notaDAO.listarDetalhesPorEstudante(e.getId());
        }

        List<String> disciplinas = BoletimNotasUtil.listarDisciplinas(notas);

        if (disciplinaParam != null && !disciplinaParam.isBlank()) {
            notas = notas.stream()
                    .filter(n -> disciplinaParam.equals(n.getNomeDisciplina()))
                    .toList();
            req.setAttribute("disciplinaFiltrada", disciplinaParam);
        }

        List<BoletimPeriodo> boletimPeriodos = BoletimNotasUtil.agruparPorPeriodoEDisciplina(notas);

        req.setAttribute("notas", notas);
        req.setAttribute("boletimPeriodos", boletimPeriodos);
        req.setAttribute("totalNotas", notas.size());
        req.setAttribute("mediaGeral", BoletimNotasUtil.mediaGeral(boletimPeriodos));
        req.setAttribute("disciplinas", disciplinas);
        req.setAttribute("periodos", periodos);
        req.getRequestDispatcher("/WEB-INF/views/estudante/boletim.jsp").forward(req, res);
    }
}
