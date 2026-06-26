<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Gerir disciplinas no UNIHELP. Associe disciplinas aos cursos da instituição.">
        <meta name="keywords" content="disciplinas, gestão académica, cursos, UNIHELP">
        <meta property="og:title" content="Gerir Disciplinas — Admin | UNIHELP">
        <meta property="og:description" content="Painel de gestão de disciplinas para administradores.">
        <meta property="og:type" content="website">
        <title>Gerir Disciplinas — Admin | UNIHELP</title>
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
                    <a href="${pageContext.request.contextPath}/admin/cursos"               class="sidebar-link"><i class="bi bi-mortarboard"></i> Cursos</a>
                    <a href="${pageContext.request.contextPath}/admin/disciplinas"          class="sidebar-link active"><i class="bi bi-book"></i> Disciplinas</a>
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
                            <div class="page-title">Gerir Disciplinas</div>
                            <div class="page-subtitle">Adicionar, editar e eliminar disciplinas</div>
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
                    <c:if test="${not empty erro}">
                        <div class="alert alert-danger" data-dismiss>
                            <i class="bi bi-exclamation-circle-fill"></i><div>${erro}</div>
                        </div>
                    </c:if>

                    <div style="display:grid;grid-template-columns:1fr 340px;gap:1.25rem;align-items:start;">

                        <!-- Lista -->
                        <div class="card">
                            <div class="card-header">
                                <h3><i class="bi bi-book" style="margin-right:.4rem"></i>Disciplinas Registadas</h3>
                                <span class="tag">${not empty disciplinas ? disciplinas.size() : 0} registo(s)</span>
                            </div>

                            <div class="table-wrap">
                                <table class="uni-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Nome</th>
                                            <th>Código</th>
                                            <th style="text-align:center">Acções</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty disciplinas}">
                                                <tr>
                                                    <td colspan="5">
                                                        <div class="empty-state">
                                                            <i class="bi bi-book"></i>
                                                            <h3>Sem disciplinas</h3>
                                                            <p>Adicione a primeira disciplina usando o formulário.</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="d" items="${disciplinas}" varStatus="s">
                                                    <tr>
                                                        <td class="muted">${s.count}</td>
                                                        <td><strong>${d.nome}</strong></td>
                                                        <td><span class="badge badge-neutral">${d.codigo}</span></td>
                                                        <td>
                                                            <div class="actions" style="display:flex;gap:.78em;justify-content:center">
                                                                <button type="button" class="btn btn-outline btn-sm" title="Editar"
                                                                        onclick="preencherForm('${d.id}','${d.nome}','${d.codigo}')">
                                                                    <i class="bi bi-pencil"></i>
                                                                </button>
                                                                <form action="${pageContext.request.contextPath}/admin/disciplinas" method="post" style="display:inline">
                                                                    <input type="hidden" name="acao" value="eliminar">
                                                                    <input type="hidden" name="id" value="${d.id}">
                                                                    <button type="submit" class="btn btn-outline-danger btn-sm" title="Eliminar"
                                                                            data-confirm="Eliminar a disciplina '${d.nome}'?">
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
                                <h3 id="formTitulo"><i class="bi bi-plus-circle" style="margin-right:.4rem"></i>Adicionar Disciplina</h3>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/admin/disciplinas" method="post" data-loading id="formDisc">
                                    <input type="hidden" name="acao" id="discAcao" value="criar">
                                    <input type="hidden" name="id"    id="discId"   value="">

                                    <div class="form-group">
                                        <label class="form-label" for="nome">Nome da Disciplina <span class="req">*</span></label>
                                        <input type="text" id="nome" name="nome" class="form-control"
                                               placeholder="Ex: Programação IV" maxlength="100" required>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="codigo">Código <span class="req">*</span></label>
                                        <input type="text" id="codigo" name="codigo" class="form-control"
                                               placeholder="Ex: PR4" maxlength="20" required>
                                    </div>

                                    <div style="display:flex;gap:.6rem">
                                        <button type="submit" class="btn btn-primary" style="flex:1;justify-content:center">
                                            <i class="bi bi-save" id="btnIcone"></i> <span id="btnTexto">Adicionar</span>
                                        </button>
                                        <button type="button" class="btn btn-outline" onclick="resetForm()" title="Limpar">
                                            <i class="bi bi-x-circle"></i>
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
            function preencherForm(id, nome, codigo) {
                document.getElementById('discAcao').value = 'editar';
                document.getElementById('discId').value   = id;
                document.getElementById('nome').value     = nome;
                document.getElementById('codigo').value   = codigo;
               
                document.getElementById('formTitulo').innerHTML = '<i class="bi bi-pencil" style="margin-right:.4rem"></i>Editar Disciplina';
                document.getElementById('btnTexto').textContent = 'Guardar Alterações';
                document.getElementById('nome').focus();
            }
            function resetForm() {
                document.getElementById('discAcao').value = 'criar';
                document.getElementById('discId').value   = '';
                document.getElementById('formDisc').reset();
                document.getElementById('formTitulo').innerHTML = '<i class="bi bi-plus-circle" style="margin-right:.4rem"></i>Adicionar Disciplina';
                document.getElementById('btnTexto').textContent = 'Adicionar';
            }
        </script>
    </body>
</html>
