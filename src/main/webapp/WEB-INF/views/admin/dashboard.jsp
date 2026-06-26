<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Dashboard do Administrador no UNIHELP. Gerencie utilizadores, cursos, disciplinas, turmas.">
        <meta name="keywords" content="dashboard admin, atendimentos, agenda, gestão, UNIHELP, sistema académico">
        <meta property="og:title" content="Dashboard Administrador — UNIHELP">
        <meta property="og:description" content="Painel de gestão para administradores com controlo total do sistema.">
        <meta property="og:type" content="website">
        <title>Dashboard — Admin | UNIHELP</title>
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard"            class="sidebar-link active"><i class="bi bi-speedometer2"></i> Dashboard</a>
                    <span class="nav-section-label">Utilizadores</span>
                    <a href="${pageContext.request.contextPath}/admin/utilizadores"         class="sidebar-link"><i class="bi bi-people"></i> Gerir Utilizadores</a>
                    <a href="${pageContext.request.contextPath}/admin/registar-funcionario" class="sidebar-link"><i class="bi bi-person-badge"></i> Registar Funcionário</a>
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
                            <div class="page-title">Dashboard</div>
                            <div class="page-subtitle">Painel de Administração</div>
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

                    <c:if test="${not empty sucesso}">
                        <div class="alert alert-success" data-dismiss>
                            <i class="bi bi-check-circle-fill"></i><div>${sucesso}</div>
                        </div>
                    </c:if>

                    <div class="stats-grid" style="grid-template-columns:repeat(3, minmax(0, 1fr));">
                        <div class="stat-card">
                            <div class="stat-icon primary"><i class="bi bi-people"></i></div>
                            <div><div class="stat-value">${not empty totalUtilizadores ? totalUtilizadores : 0}</div><div class="stat-label">Utilizadores</div></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon info"><i class="bi bi-person-badge"></i></div>
                            <div><div class="stat-value">${not empty totalEstudantes ? totalEstudantes : 0}</div><div class="stat-label">Estudantes</div></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon accent"><i class="bi bi-briefcase"></i></div>
                            <div><div class="stat-value">${not empty totalFuncionarios ? totalFuncionarios : 0}</div><div class="stat-label">Funcionários</div></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon success"><i class="bi bi-mortarboard"></i></div>
                            <div><div class="stat-value">${not empty totalCursos ? totalCursos : 0}</div><div class="stat-label">Cursos</div></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon warning"><i class="bi bi-book"></i></div>
                            <div><div class="stat-value">${not empty contDisciplinas ? contDisciplinas : 0}</div><div class="stat-label">Disciplinas</div></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon danger"><i class="bi bi-journal-check"></i></div>
                            <div>
                                <div>${not empty periodoAtivo ? periodoAtivo.anoLetivo : ''}</div>
                                <div class="stat-label">Ano lectivo</div>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3><i class="bi bi-lightning" style="margin-right:.4rem"></i>Acções Rápidas</h3>
                        </div>
                        <div class="card-body">
                            <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:.75rem">
                                <a href="${pageContext.request.contextPath}/admin/utilizadores"         class="btn btn-outline-primary btn-full"><i class="bi bi-people"></i> Gerir Utilizadores</a>
                                <a href="${pageContext.request.contextPath}/admin/registar-funcionario" class="btn btn-outline-primary btn-full"><i class="bi bi-person-badge"></i> Registar Funcionário</a>
                                <a href="${pageContext.request.contextPath}/admin/cursos"               class="btn btn-outline-primary btn-full"><i class="bi bi-mortarboard"></i> Gerir Cursos</a>
                                <a href="${pageContext.request.contextPath}/admin/disciplinas"          class="btn btn-outline-primary btn-full"><i class="bi bi-book"></i> Gerir Disciplinas</a>
                                <a href="${pageContext.request.contextPath}/admin/turmas"               class="btn btn-outline-primary btn-full"><i class="bi bi-collection"></i> Gerir Turmas</a>
                                <a href="${pageContext.request.contextPath}/admin/periodos"             class="btn btn-outline-primary btn-full"><i class="bi bi-calendar3"></i> Períodos Letivos</a>
                                <a href="${pageContext.request.contextPath}/admin/inscricoes"           class="btn btn-outline-primary btn-full"><i class="bi bi-journal-check"></i> Gerir Inscrições</a>
                            </div>
                        </div>
                    </div>

                </main>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
    </body>
</html>
