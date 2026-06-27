package ao.unic.ojj.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/erro/*")
public class ErrorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        if (path == null || path.equals("/")) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }

        String codigo = path.replace("/", "");
        String jsp;

        switch (codigo) {
            case "403" -> jsp = "/WEB-INF/views/sistema/403.jsp";
            case "404" -> jsp = "/WEB-INF/views/sistema/404.jsp";
            case "500" -> jsp = "/WEB-INF/views/sistema/500.jsp";
            default -> {
                res.sendRedirect(req.getContextPath() + "/");
                return;
            }
        }

        req.getRequestDispatcher(jsp).forward(req, res);
    }
}
