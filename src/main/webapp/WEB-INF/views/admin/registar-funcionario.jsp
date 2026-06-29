<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Registar Funcionário — Admin | UNIHELP</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
    </head>
    <body>
        <div class="sidebar-overlay" onclick="toggleSidebar()"></div>

        <div class="wrapper">
            <aside class="sidebar" id="sidebar">
                <div class="sidebar-brand">
                    <div class="brand-logo">UH</div>
                    <div class="brand-text">
                        <strong>UNIHELP</strong>
                    </div>
                </div>

                <nav class="sidebar-nav">
                    <span class="nav-section-label">Painel</span>
                    <a href="${pageContext.request.contextPath}/admin/dashboard"            class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
                    <span class="nav-section-label">Utilizadores</span>
                    <a href="${pageContext.request.contextPath}/admin/utilizadores"         class="sidebar-link"><i class="bi bi-people"></i> Gerir Utilizadores</a>
                    <a href="${pageContext.request.contextPath}/admin/registar-funcionario" class="sidebar-link active"><i class="bi bi-person-badge"></i> Registar Funcionário</a>
                    <span class="nav-section-label">Estrutura Académica</span>
                    <a href="${pageContext.request.contextPath}/admin/cursos"               class="sidebar-link"><i class="bi bi-mortarboard"></i> Cursos</a>
                    <a href="${pageContext.request.contextPath}/admin/disciplinas"          class="sidebar-link"><i class="bi bi-book"></i> Disciplinas</a>
                    <a href="${pageContext.request.contextPath}/admin/turmas"               class="sidebar-link"><i class="bi bi-collection"></i> Turmas</a>
                    <a href="${pageContext.request.contextPath}/admin/periodos"             class="sidebar-link"><i class="bi bi-calendar3"></i> Períodos Letivos</a>
                    <a href="${pageContext.request.contextPath}/admin/inscricoes"           class="sidebar-link"><i class="bi bi-journal-check"></i> Inscrições</a>
                </nav>
            </aside>

            <div class="main-content">
                <header class="topbar">
                    <div class="topbar-left">
                        <button class="btn-sidebar-toggle" onclick="toggleSidebar()">
                            <i class="bi bi-list"></i>
                        </button>
                        <div>
                            <div class="page-title">Registar Funcionário</div>
                            <div class="page-subtitle">Criar nova conta de funcionário</div>
                        </div>
                    </div>
                    <div class="topbar-user">
                        <i class="bi bi-person-circle"></i>
                        <span>${sessionScope.utilizadorLogado.nome}</span>
                        <a href="${pageContext.request.contextPath}/logout"
                           class="btn btn-outline btn-sm"
                           data-confirm="Deseja terminar a sessão?">
                            <i class="bi bi-box-arrow-right"></i>
                        </a>
                    </div>
                </header>

                <main class="page-content">
                    <c:if test="${not empty mensagem}">
                        <c:choose>
                            <c:when test="${mensagem.startsWith('Erro') || mensagem.startsWith('Não')}">
                                <div class="alert alert-danger" data-dismiss>
                                    <i class="bi bi-exclamation-circle-fill"></i><div>${mensagem}</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-success" data-dismiss>
                                    <i class="bi bi-check-circle-fill"></i><div>${mensagem}</div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                    <c:if test="${not empty erro}">
                        <div class="alert alert-danger" data-dismiss>
                            <i class="bi bi-exclamation-circle-fill"></i><div>${erro}</div>
                        </div>
                    </c:if>

                    <div class="card">
                        <div class="card-header">
                            <h3><i class="bi bi-person-badge" style="margin-right:.4rem"></i>Novo Funcionário</h3>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/registar-funcionario"
                                  method="post" data-loading
                                  onsubmit="return validarSenhas()">

                                <div class="form-group">
                                    <label class="form-label" for="nome">Nome Completo <span class="req">*</span></label>
                                    <input type="text" id="nome" name="nome" class="form-control"
                                           value="${not empty dto ? dto.nome : ''}"
                                           maxlength="150" required>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label" for="email">Email <span class="req">*</span></label>
                                        <input type="email" id="email" name="email" class="form-control"
                                               value="${not empty dto ? dto.email : ''}" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="telefone">Telefone <span class="req">*</span></label>
                                        <input type="tel" id="telefone" name="telefone" class="form-control"
                                               value="${not empty dto ? dto.telefone : ''}"
                                               maxlength="20" required>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label" for="senha">Senha <span class="req">*</span></label>
                                        <input type="password" id="senha" name="senha" class="form-control"
                                               minlength="6" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="confirmarSenha">Confirmar Senha <span class="req">*</span></label>
                                        <input type="password" id="confirmarSenha" name="confirmarSenha" class="form-control"
                                               minlength="6" required>
                                        <span class="form-error" id="erroSenha" style="display:none">As senhas não coincidem.</span>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label" for="departamento">Departamento <span class="req">*</span></label>
                                        <input type="text" id="departamento" name="departamento" class="form-control"
                                               value="${not empty dto ? dto.departamento : ''}"
                                               maxlength="100" required>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="cargo">Cargo <span class="req">*</span></label>
                                        <input type="text" id="cargo" name="cargo" class="form-control"
                                               value="${not empty dto ? dto.cargo : ''}"
                                               maxlength="100" required>
                                    </div>
                                </div>

                                <div style="display:flex;gap:.75rem;justify-content:flex-end">
                                    <a href="${pageContext.request.contextPath}/admin/registar-funcionario" class="btn btn-outline">Cancelar</a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-person-check"></i> Registar Funcionário
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
        <script>
                                      function validarSenhas() {
                                          var s1 = document.getElementById('senha').value;
                                          var s2 = document.getElementById('confirmarSenha').value;
                                          var err = document.getElementById('erroSenha');
                                          if (s1 !== s2) {
                                              err.style.display = 'block';
                                              document.getElementById('confirmarSenha').classList.add('invalid');
                                              return false;
                                          }
                                          err.style.display = 'none';
                                          return true;
                                      }
        </script>
    </body>
</html>
