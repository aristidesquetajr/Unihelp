<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Entrar — UNIHELP | OJJ</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
    </head>
    <body>

        <div class="auth-page">
            <div class="auth-card">

                <!-- ── Cabeçalho ── -->
                <div class="auth-header">
                    <div class="auth-logo">UH</div>
                    <h1>UNIHELP</h1>
                    <p>Instituição OJJ &mdash; Área Restrita</p>
                </div>

                <!-- ── Corpo ── -->
                <div class="auth-body">

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

                    <!-- Formulário -->
                    <form action="${pageContext.request.contextPath}/login"
                          method="post"
                          data-loading>

                        <div class="form-group">
                            <label class="form-label" for="email">
                                Endereço de Email <span class="req">*</span>
                            </label>
                            <input
                                type="email"
                                id="email"
                                name="email"
                                class="form-control"
                                placeholder="utilizador@ojj.ao"
                                value="${not empty param.email ? param.email : ''}"
                                required
                                autofocus
                                >
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="senha">
                                Senha <span class="req">*</span>
                            </label>
                            <div style="position:relative">
                                <input
                                    type="password"
                                    id="senha"
                                    name="senha"
                                    class="form-control"
                                    placeholder="••••••••"
                                    required
                                    style="padding-right:2.5rem"
                                    >
                                <button
                                    type="button"
                                    onclick="toggleSenha()"
                                    style="position:absolute;right:.6rem;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:var(--text-muted);font-size:1rem;line-height:1;padding:.2rem"
                                    tabindex="-1"
                                    >
                                    <i class="bi bi-eye" id="icone-olho"></i>
                                </button>
                            </div>
                        </div>

                        <div style="margin-top:1.5rem">
                            <button type="submit" class="btn btn-primary btn-full btn-lg">
                                <i class="bi bi-box-arrow-in-right"></i> Entrar
                            </button>
                        </div>

                    </form>

                    <!-- Voltar -->
                    <div style="text-align:center;margin-top:1.25rem">
                        <a href="${pageContext.request.contextPath}"
                           style="font-size:.82rem;color:var(--text-muted)">
                            <i class="bi bi-arrow-left"></i> Voltar à página inicial
                        </a>
                    </div>

                </div><!-- /auth-body -->
            </div><!-- /auth-card -->
        </div><!-- /auth-page -->

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
