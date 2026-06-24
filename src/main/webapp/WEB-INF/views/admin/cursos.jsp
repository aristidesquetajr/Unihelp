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
        <title>Gerir Cursos — Admin | UNIHELP</title>
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
                    <a href="${pageContext.request.contextPath}/admin/registar-funcionario" class="sidebar-link"><i class="bi bi-person-badge"></i> Registar Funcionário</a>
                    <span class="nav-section-label">Estrutura Académica</span>
                    <a href="${pageContext.request.contextPath}/admin/cursos"               class="sidebar-link active"><i class="bi bi-mortarboard"></i> Cursos</a>
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
                            <div class="page-title">Gerir Cursos</div>
                            <div class="page-subtitle">Adicionar, editar e eliminar cursos</div>
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
                            <i class="bi bi-check-circle-fill"></i>
                            <p>${sucesso}</p>
                        </div>
                    </c:if>

                    <c:if test="${not empty erro}">
                        <div class="alert alert-danger" data-dismiss>
                            <i class="bi bi-exclamation-circle-fill"></i>
                            <p>${erro}</p>
                        </div>
                    </c:if>

                    <div style="display:grid;grid-template-columns:1fr 340px;gap:1.25rem;align-items:start;">

                        <!-- Lista -->
                        <div class="card">
                            <div class="card-header">
                                <h3><i class="bi bi-mortarboard" style="margin-right:.4rem"></i>Cursos Registados</h3>
                                <span class="tag">${not empty cursos ? cursos.size() : 0} registo(s)</span>
                            </div>
                            <div class="table-wrap">
                                <table class="uni-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Nome</th>
                                            <th>Ativo</th>
                                            <th style="text-align:center">Acções</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty cursos}">
                                                <tr>
                                                    <td colspan="4">
                                                        <div class="empty-state">
                                                            <i class="bi bi-mortarboard"></i>
                                                            <h3>Sem cursos</h3>
                                                            <p>Adicione o primeiro curso usando o formulário.</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="c" items="${cursos}" varStatus="s">
                                                    <tr>
                                                        <td class="muted">${s.count}</td>
                                                        <td><strong>${c.nome}</strong></td>
                                                        <td>
                                                            <form action="${pageContext.request.contextPath}/admin/cursos" method="post" style="display:inline">
                                                                <input type="hidden" name="acao" value="ATIVO">
                                                                <input type="hidden" name="id" value="${c.id}">
                                                                <input type="checkbox" name="ativo" id="ativo" ${c.ativo ? 'checked' : ''}/>
                                                            </form>
                                                        </td>
                                                        <td>
                                                            <div class="actions" style="display:flex;gap:.78em;justify-content:center">
                                                                <button type="button" class="btn btn-outline btn-sm" title="Editar"
                                                                        onclick="preencherForm('${c.id}', '${c.nome}')">
                                                                    <i class="bi bi-pencil"></i>
                                                                </button>
                                                                <form action="${pageContext.request.contextPath}/admin/cursos" method="post" style="display:inline">
                                                                    <input type="hidden" name="acao" value="ELIMINAR">
                                                                    <input type="hidden" name="id" value="${c.id}">
                                                                    <button type="submit" class="btn btn-outline-danger btn-sm" title="Eliminar"
                                                                            data-confirm="Eliminar o curso '${c.nome}'?">
                                                                        <i class="bi bi-trash"></i>
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Formulário -->
                        <div class="card" style="position:sticky;top:calc(var(--topbar-h) + 1rem)">
                            <div class="card-header">
                                <h3 id="formTitulo"><i class="bi bi-plus-circle" style="margin-right:.4rem"></i>Adicionar Curso</h3>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/admin/cursos" method="post" data-loading id="formCurso">
                                    <input type="hidden" name="acao" id="acao" value="ADICIONAR">
                                    <input type="hidden" name="id" id="cursoId" value="">

                                    <div class="form-group">
                                        <label class="form-label" for="nome">Nome <span class="req">*</span></label>
                                        <input type="text" id="nome" name="nome" class="form-control" placeholder="Ex: Engenharia Informática" maxlength="100" required>
                                    </div>

                                    <div style="display:flex;gap:.6rem">
                                        <button type="submit" class="btn btn-primary" style="flex:1;justify-content:center">
                                            <i class="bi bi-save" id="btnIcone"></i> <span id="btnTexto">Adicionar</span>
                                        </button>
                                        <button type="button" class="btn btn-outline" onclick="resetForm()" title="Limpar"><i class="bi bi-x-circle"></i></button>
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
                                            function preencherForm(id, nome) {
                                                document.getElementById('acao').value = 'EDITAR';
                                                document.getElementById('cursoId').value = id;
                                                document.getElementById('nome').value = nome;
                                                document.getElementById('formTitulo').innerHTML = '<i class="bi bi-pencil" style="margin-right:.4rem"></i>Editar Curso';
                                                document.getElementById('btnTexto').textContent = 'Guardar Alterações';
                                                document.getElementById('nome').focus();
                                            }
                                            function resetForm() {
                                                document.getElementById('acao').value = 'ADICIONAR';
                                                document.getElementById('cursoId').value = '';
                                                document.getElementById('formCurso').reset();
                                                document.getElementById('formTitulo').innerHTML = '<i class="bi bi-plus-circle" style="margin-right:.4rem"></i>Adicionar Curso';
                                                document.getElementById('btnTexto').textContent = 'Adicionar';
                                            }
        </script>
    </body>
</html>
