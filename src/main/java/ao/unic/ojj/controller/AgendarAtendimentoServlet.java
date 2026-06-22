package ao.unic.ojj.controller;

import ao.unic.ojj.dao.AtendimentoDAO;
import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.model.Atendimento;
import ao.unic.ojj.model.Estudante;
import ao.unic.ojj.model.Utilizador;
import ao.unic.ojj.util.SessaoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeParseException;
import java.util.Date;

/**
 * GET /estudante/agendar → Formulário de agendamento. POST /estudante/agendar →
 * Submete o agendamento.
 *
 * Regra de negócio: máximo de 10 atendimentos por dia.
 */
@WebServlet("/estudante/agendar")
public class AgendarAtendimentoServlet extends HttpServlet {

    private static final int LIMITE_DIARIO = 10;
    private static final LocalTime HORA_INICIO = LocalTime.of(7, 0);
    private static final LocalTime HORA_FIM = LocalTime.of(18, 0);
    private static final ZoneId ZONA_LOCAL = ZoneId.of("Africa/Luanda");

    private final AtendimentoDAO atendimentoDAO = new AtendimentoDAO();
    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        forwardFormulario(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String data = req.getParameter("data");
        String hora = req.getParameter("hora");
        String descricao = req.getParameter("descricao");

        // Validação dos campos
        if (data == null || data.isBlank()
                || hora == null || hora.isBlank()
                || descricao == null || descricao.isBlank()) {
            req.setAttribute("erro", "Preencha todos os campos obrigatórios.");
            forwardFormulario(req, res);
            return;
        }

        LocalDateTime dataHora;
        try {
            dataHora = LocalDateTime.parse(data + "T" + hora);
        } catch (DateTimeParseException e) {
            req.setAttribute("erro", "Formato de data inválido.");
            forwardFormulario(req, res);
            return;
        }

        LocalTime horaAgendada = dataHora.toLocalTime();
        if (horaAgendada.isBefore(HORA_INICIO) || horaAgendada.isAfter(HORA_FIM)) {
            req.setAttribute("erro", "O atendimento deve ser agendado entre as 07h00 e as 18h00.");
            forwardFormulario(req, res);
            return;
        }

        // Verificar data no passado
        if (dataHora.isBefore(LocalDateTime.now(ZONA_LOCAL))) {
            req.setAttribute("erro", "A data não pode ser no passado.");
            forwardFormulario(req, res);
            return;
        }

        Date dataAgendada = Date.from(dataHora.atZone(ZONA_LOCAL).toInstant());

        // Verificar limite diário
        int totalDia = atendimentoDAO.contarPorData(dataAgendada);
        if (totalDia >= LIMITE_DIARIO) {
            req.setAttribute("erro", "Não há vagas disponíveis para o dia seleccionado. "
                    + "Escolha outra data.");
            forwardFormulario(req, res);
            return;
        }

        // Criar o atendimento
        Utilizador u = SessaoUtil.getUtilizador(req);
        if (u == null) {
            res.sendRedirect(req.getContextPath() + "/login?timeout=1");
            return;
        }

        Estudante e = estudanteDAO.buscarPorIdUtilizador(u.getId());
        if (e == null) {
            req.setAttribute("erro", "Não foi encontrado um registo de estudante para este utilizador.");
            forwardFormulario(req, res);
            return;
        }

        Atendimento atendimento = new Atendimento(e.getId(), dataAgendada, descricao);
        boolean sucesso = atendimentoDAO.inserir(atendimento);

        if (sucesso) {
            req.getSession().setAttribute("sucesso",
                    "Atendimento agendado com sucesso! Aguarde a confirmação.");
            res.sendRedirect(req.getContextPath() + "/estudante/atendimentos");
        } else {
            req.setAttribute("erro", "Erro ao agendar. Tente novamente.");
            forwardFormulario(req, res);
        }
    }

    private void forwardFormulario(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setAttribute("dataMin", LocalDateTime.now(ZONA_LOCAL).toLocalDate().toString());
        req.getRequestDispatcher("/WEB-INF/views/estudante/agendar.jsp").forward(req, res);
    }
}
