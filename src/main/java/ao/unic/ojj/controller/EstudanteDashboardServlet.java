package ao.unic.ojj.controller;

import ao.unic.ojj.dao.AtendimentoDAO;
import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.InscricaoDAO;
import ao.unic.ojj.dao.NotaDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.AtendimentoDTO;
import ao.unic.ojj.dto.InscricaoDetalheDTO;
import ao.unic.ojj.dto.NotaDetalheDTO;
import ao.unic.ojj.model.BoletimPeriodo;
import ao.unic.ojj.model.Estudante;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.util.BoletimNotasUtil;
import ao.unic.ojj.util.SessaoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

/**
 * GET /estudante/dashboard → Painel principal do estudante. Mostra: inscrição
 * activa, próximos atendimentos e notas recentes.
 */
@WebServlet("/estudante/dashboard")
public class EstudanteDashboardServlet extends HttpServlet {

    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);
    private final AtendimentoDAO atendimentoDAO = new AtendimentoDAO();
    private final InscricaoDAO inscricaoDAO = new InscricaoDAO();
    private final NotaDAO notaDAO = new NotaDAO();

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
            req.getRequestDispatcher("/WEB-INF/views/estudante/dashboard.jsp").forward(req, res);
            return;
        }

        List<AtendimentoDTO> atendimentos = atendimentoDAO.listarPorEstudanteDTO(e.getId());
        List<InscricaoDetalheDTO> inscricoes = inscricaoDAO.listarDetalhesPorEstudante(e.getId());
        List<NotaDetalheDTO> notas = notaDAO.listarDetalhesPorEstudante(e.getId());
        List<BoletimPeriodo> boletimPeriodos = BoletimNotasUtil.agruparPorPeriodoEDisciplina(notas);

        InscricaoDetalheDTO inscricaoActiva = inscricoes.stream()
                .filter(InscricaoDetalheDTO::isActivo)
                .findFirst()
                .orElse(null);

        Date agora = new Date();
        AtendimentoDTO proximoAtendimento = atendimentos.stream()
                .filter(a -> a.getDataAgendada() != null && !a.getDataAgendada().before(agora))
                .filter(a -> a.isPendente() || a.isConfirmado())
                .min(Comparator.comparing(AtendimentoDTO::getDataAgendada))
                .orElse(null);

        List<AtendimentoDTO> ultimosAtendimentos = atendimentos.stream()
                .limit(5)
                .toList();

        req.setAttribute("inscricaoActiva", inscricaoActiva);
        req.setAttribute("proximoAtendimento", proximoAtendimento);
        req.setAttribute("atendimentos", ultimosAtendimentos);
        req.setAttribute("contPendentes", atendimentos.stream().filter(AtendimentoDTO::isPendente).count());
        req.setAttribute("contConfirmados", atendimentos.stream().filter(AtendimentoDTO::isConfirmado).count());
        req.setAttribute("mediaGeral", BoletimNotasUtil.mediaGeral(boletimPeriodos));
        req.setAttribute("totalDisciplinas", BoletimNotasUtil.contarDisciplinas(boletimPeriodos));
        req.setAttribute("disciplinasEmRisco", BoletimNotasUtil.contarEmRisco(boletimPeriodos));

        req.getRequestDispatcher("/WEB-INF/views/estudante/dashboard.jsp").forward(req, res);
    }
}
