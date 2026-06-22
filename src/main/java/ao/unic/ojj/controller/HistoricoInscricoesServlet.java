package ao.unic.ojj.controller;

import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.InscricaoDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.InscricaoDetalheDTO;
import ao.unic.ojj.model.Estudante;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.util.SessaoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * GET /estudante/inscricoes → Histórico de inscrições do estudante.
 */
@WebServlet("/estudante/inscricoes")
public class HistoricoInscricoesServlet extends HttpServlet {

    private final InscricaoDAO inscricaoDAO = new InscricaoDAO();
    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String estado = req.getParameter("estado");

        Utilizador u = SessaoUtil.getUtilizador(req);
        if (u == null) {
            res.sendRedirect(req.getContextPath() + "/login?timeout=1");
            return;
        }

        Estudante e = estudanteDAO.buscarPorIdUtilizador(u.getId());
        if (e == null) {
            req.setAttribute("erro", "Não foi encontrado um registo de estudante para este utilizador.");
            req.setAttribute("inscricoes", List.of());
            req.setAttribute("totalInscricoes", 0);
            req.getRequestDispatcher("/WEB-INF/views/estudante/inscricoes.jsp").forward(req, res);
            return;
        }

        List<InscricaoDetalheDTO> inscricoes = inscricaoDAO.listarDetalhesPorEstudante(e.getId());
        List<InscricaoDetalheDTO> inscricoesFiltradas = inscricoes;

        if (estado != null && !estado.isEmpty()) {
            switch (estado) {
                case "ACTIVO" ->
                    inscricoesFiltradas = inscricoes.stream().filter(InscricaoDetalheDTO::isActivo).toList();
                case "CONCLUIDO" ->
                    inscricoesFiltradas = inscricoes.stream().filter(InscricaoDetalheDTO::isConcluido).toList();
                case "TRANCADO" ->
                    inscricoesFiltradas = inscricoes.stream().filter(InscricaoDetalheDTO::isTrancado).toList();
                default ->
                    inscricoesFiltradas = inscricoes;
            }
        }

        InscricaoDetalheDTO inscricaoActiva = inscricoes.stream()
                .filter(InscricaoDetalheDTO::isActivo)
                .findFirst()
                .orElse(null);

        req.setAttribute("inscricoes", inscricoesFiltradas);
        req.setAttribute("inscricaoActiva", inscricaoActiva);
        req.setAttribute("totalInscricoes", inscricoesFiltradas.size());

        req.getRequestDispatcher("/WEB-INF/views/estudante/inscricoes.jsp").forward(req, res);
    }
}
