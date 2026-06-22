package ao.unic.ojj.controller;

import ao.unic.ojj.dao.AtendimentoDAO;
import ao.unic.ojj.dto.AtendimentoDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * GET /funcionario/agenda → Atendimentos CONFIRMADOS do dia. Suporta filtro por
 * data via parâmetro ?data=yyyy-MM-dd
 */
@WebServlet("/funcionario/agenda")
public class AgendaServlet extends HttpServlet {

    private final AtendimentoDAO atendimentoDAO = new AtendimentoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat labelFormat = new SimpleDateFormat("EEEE, dd/MM/yyyy", Locale.forLanguageTag("pt-AO"));
        String dataParam = req.getParameter("data");
        Date data = new Date();  // hoje por omissão

        if (dataParam != null && !dataParam.isBlank()) {
            try {
                data = inputFormat.parse(dataParam);
            } catch (ParseException e) {
                req.setAttribute("erro", "Formato de data inválido.");
            }
        }

        List<AtendimentoDTO> atendimentos = atendimentoDAO.listarConfirmadosPorDataDTO(data);
        Calendar anterior = Calendar.getInstance();
        anterior.setTime(data);
        anterior.add(Calendar.DATE, -1);

        Calendar proxima = Calendar.getInstance();
        proxima.setTime(data);
        proxima.add(Calendar.DATE, 1);

        req.setAttribute("atendimentos", atendimentos);
        req.setAttribute("dataSelecionada", inputFormat.format(data));
        req.setAttribute("dataAnterior", inputFormat.format(anterior.getTime()));
        req.setAttribute("dataProxima", inputFormat.format(proxima.getTime()));
        req.setAttribute("labelData", labelFormat.format(data));
        req.setAttribute("totalDia", atendimentos.size());

        String sucesso = (String) req.getSession().getAttribute("sucesso");
        if (sucesso != null) {
            req.setAttribute("sucesso", sucesso);
            req.getSession().removeAttribute("sucesso");
        }

        String erro = (String) req.getSession().getAttribute("erro");
        if (erro != null) {
            req.setAttribute("erro", erro);
            req.getSession().removeAttribute("erro");
        }

        req.getRequestDispatcher("/WEB-INF/views/funcionario/agenda.jsp").forward(req, res);
    }
}
