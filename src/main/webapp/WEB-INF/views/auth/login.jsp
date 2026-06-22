<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Faça login na plataforma UNIHELP para aceder ao seu painel académico. Sistema seguro de gestão escolar para estudantes e funcionários.">
        <meta name="keywords" content="login, autenticação, UNIHELP, sistema académico, gestão escolar">
        <meta property="og:title" content="Entrar — UNIHELP">
        <meta property="og:description" content="Aceda ao seu painel académico através da autenticação segura do UNIHELP.">
        <meta property="og:type" content="website">
        <title>Entrar — UNIHELP | OJJ</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/login.css">
    </head>
    <body>

        <div class="login-card">

            <a href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="UNIHELP Logo" class="logo">
                <h2>UNIHELP </h2>
            </a>

            <%-- Mensagem de erro vinda do LoginServlet --%>
            <c:if test="${not empty erro}">
                <div class="alert alert-danger" data-dismiss>
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <div>${erro}</div>
                </div>
            </c:if>

            <%-- Mensagem de sessão expirada --%>
            <c:if test="${param.timeout == '1'}">
                <div class="alert alert-warning" data-dismiss>
                    <i class="bi bi-clock"></i>
                    <div>A sua sessão expirou. Por favor, faça login novamente.</div>
                </div>
            </c:if>

            <%-- Mensagem de logout bem-sucedido --%>
            <c:if test="${param.logout == '1'}">
                <div class="alert alert-info" data-dismiss>
                    <i class="bi bi-check-circle"></i>
                    <div>Sessão terminada com sucesso.</div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login"
                  method="post"
                  data-loading>

                <input
                    type="email"
                    id="email"
                    name="email"
                    class="form-control"
                    placeholder="Email"
                    value="${not empty param.email ? param.email : ''}"
                    required
                    autofocus
                    />

                <div class="password-wrapper">
                    <input
                        type="password"
                        id="senha"
                        name="senha"
                        class="form-control password-input"
                        placeholder="Senha"
                        required
                        >
                    <button
                        type="button"
                        onclick="toggleSenha()"
                        class="password-toggle"
                        tabindex="-1"
                        >
                        <i class="bi bi-eye" id="icone-olho"></i>
                    </button>
                </div>

                <button type="submit" class="btn btn-primary btn-full btn-lg">
                    <i class="bi bi-box-arrow-in-right"></i> Entrar
                </button>
            </form>

            <a href="${pageContext.request.contextPath}/" class="link">Esqueci a senha</a>
        </div>

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
        <script>
                            function toggleSenha() {
                                var inp = document.getElementById('senha');
                                var ico = document.getElementById('icone-olho');
                                if (inp.type === 'password') {
                                    inp.type = 'text';
                                    ico.className = 'bi bi-eye-slash';
                                } else {
                                    inp.type = 'password';
                                    ico.className = 'bi bi-eye';
                                }
                            }
        </script>
    </body>
</html>
