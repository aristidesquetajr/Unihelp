<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Registar novo estudante no UNIHELP. Adicione informações académicas e pessoais de forma simples e segura.">
        <meta name="keywords" content="registar estudante, novo estudante, inscrição, UNIHELP, funcionário">
        <meta property="og:title" content="Registar Estudante — UNIHELP">
        <meta property="og:description" content="Formulário para registar novo estudante no sistema académico.">
        <meta property="og:type" content="website">
        <title>Registar Estudante | UNIHELP</title>
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
                    <span class="nav-section-label">Menu Principal</span>
                    <a href="${pageContext.request.contextPath}/funcionario/dashboard" class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/funcionario/pendentes" class="sidebar-link"><i class="bi bi-hourglass-split"></i> Atendimentos Pendentes</a>
                    <a href="${pageContext.request.contextPath}/funcionario/agenda" class="sidebar-link"><i class="bi bi-calendar2-week"></i> Agenda do Dia</a>

                    <span class="nav-section-label">Estudantes</span>
                    <a href="${pageContext.request.contextPath}/funcionario/estudantes" class="sidebar-link"><i class="bi bi-people"></i> Lista de Estudantes</a>
                    <a href="${pageContext.request.contextPath}/funcionario/registar-estudante" class="sidebar-link active"><i class="bi bi-person-plus"></i> Registar Estudante</a>
                    <a href="${pageContext.request.contextPath}/funcionario/lancar-nota" class="sidebar-link"><i class="bi bi-pencil-square"></i> Lançar Nota</a>
                </nav>
            </aside>

            <div class="main-content">
                <header class="topbar">
                    <div class="topbar-left">
                        <button class="btn-sidebar-toggle" onclick="toggleSidebar()">
                            <i class="bi bi-list"></i>
                        </button>
                        <div>
                            <div class="page-title">Registar Estudante</div>
                            <div class="page-subtitle">Criar conta e número académico</div>
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
                    <div class="section-header">
                        <div>
                            <h2 style="font-size:1.1rem;font-weight:800">Novo Estudante</h2>
                            <p class="muted text-sm">Dados obrigatórios para acesso inicial ao sistema.</p>
                        </div>
                    </div>

                    <c:if test="${not empty sucesso}">
                        <div class="alert alert-success" data-dismiss>
                            <i class="bi bi-check-circle-fill"></i><div>${sucesso}</div>
                        </div>
                    </c:if>
                    <c:if test="${not empty erro}">
                        <div class="alert alert-danger" data-dismiss>
                            <i class="bi bi-exclamation-circle-fill"></i><div>${erro}</div>
                        </div>
                    </c:if>

                    <div class="registration-form-shell">
                        <div class="card">
                            <div class="card-header">
                                <h3><i class="bi bi-person-vcard" style="margin-right:.4rem"></i>Dados do Estudante</h3>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/funcionario/registar-estudante"
                                      method="post"
                                      data-loading>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label" for="nome">Nome Completo <span class="req">*</span></label>
                                            <input type="text"
                                                   id="nome"
                                                   name="nome"
                                                   class="form-control"
                                                   value="${dto.nome}"
                                                   maxlength="150"
                                                   autocomplete="name"
                                                   required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label" for="numeroEstudante">Número de Estudante <span class="req">*</span></label>
                                            <input type="text"
                                                   id="numeroEstudante"
                                                   name="numeroEstudante"
                                                   class="form-control"
                                                   value="${dto.numeroEstudante}"
                                                   maxlength="30"
                                                   autocomplete="off"
                                                   required>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label" for="email">Email <span class="req">*</span></label>
                                            <input type="email"
                                                   id="email"
                                                   name="email"
                                                   class="form-control"
                                                   value="${dto.email}"
                                                   autocomplete="email"
                                                   required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label" for="telefone">Telefone</label>
                                            <input type="tel"
                                                   id="telefone"
                                                   name="telefone"
                                                   class="form-control"
                                                   value="${dto.telefone}"
                                                   maxlength="20"
                                                   autocomplete="tel">
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label" for="idPeriodoLetivo">Ano Letivo <span class="req">*</span></label>
                                            <select id="idPeriodoLetivo"
                                                    name="idPeriodoLetivo"
                                                    class="form-control"
                                                    required>
                                                <option value="">Selecionar ano letivo</option>
                                                <c:forEach var="p" items="${periodos}">
                                                    <option value="${p.id}" ${dto.idPeriodoLetivo == p.id ? 'selected' : ''}>
                                                        ${p.anoLetivo} - ${p.semestre}.º semestre
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label" for="idCurso">Curso <span class="req">*</span></label>
                                            <select id="idCurso"
                                                    name="idCurso"
                                                    class="form-control"
                                                    required>
                                                <option value="">Selecionar curso</option>
                                                <c:forEach var="c" items="${cursos}">
                                                    <option value="${c.id}" ${dto.idCurso == c.id ? 'selected' : ''}>
                                                        ${c.nome}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="idTurma">Turma <span class="req">*</span></label>
                                        <select id="idTurma"
                                                name="idTurma"
                                                class="form-control"
                                                required>
                                            <option value="">Selecionar turma</option>
                                            <c:forEach var="t" items="${turmas}">
                                                <option value="${t.id}"
                                                        data-curso="${t.idCurso}"
                                                        data-periodo="${t.idPeriodoLetivo}"
                                                        ${dto.idTurma == t.id ? 'selected' : ''}>
                                                    ${t.nome} - ${t.anoAcademico}.º ano<c:if test="${not empty t.sala}"> - Sala ${t.sala}</c:if>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label" for="senha">Senha <span class="req">*</span></label>
                                            <input type="password"
                                                   id="senha"
                                                   name="senha"
                                                   class="form-control"
                                                   minlength="6"
                                                   autocomplete="new-password"
                                                   required>
                                            <span class="form-hint">Mínimo de 6 caracteres.</span>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label" for="confirmarSenha">Confirmar Senha <span class="req">*</span></label>
                                            <input type="password"
                                                   id="confirmarSenha"
                                                   name="confirmarSenha"
                                                   class="form-control"
                                                   minlength="6"
                                                   autocomplete="new-password"
                                                   required>
                                        </div>
                                    </div>

                                    <div class="form-actions">
                                        <a href="${pageContext.request.contextPath}/funcionario/registar-estudante" class="btn btn-outline">
                                            Limpar
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-person-check"></i> Registar Estudante
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                    </div>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
        <script>
            (function () {
                var periodo = document.getElementById('idPeriodoLetivo');
                var curso = document.getElementById('idCurso');
                var turma = document.getElementById('idTurma');

                function filtrarTurmas() {
                    var periodoId = periodo.value;
                    var cursoId = curso.value;
                    Array.prototype.forEach.call(turma.options, function (opt) {
                        if (!opt.value) {
                            opt.hidden = false;
                            return;
                        }
                        var visivel = (!periodoId || opt.dataset.periodo === periodoId)
                                && (!cursoId || opt.dataset.curso === cursoId);
                        opt.hidden = !visivel;
                    });
                    if (turma.selectedOptions.length && turma.selectedOptions[0].hidden) {
                        turma.value = '';
                    }
                }

                periodo.addEventListener('change', filtrarTurmas);
                curso.addEventListener('change', filtrarTurmas);
                filtrarTurmas();
            }());
        </script>
    </body>
</html>
