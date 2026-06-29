<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gerir Utilizadores — Admin | UNIHELP</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/modal.css">
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
                    <a href="${pageContext.request.contextPath}/admin/utilizadores"         class="sidebar-link active"><i class="bi bi-people"></i> Gerir Utilizadores</a>
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
                            <div class="page-title">Gerir Utilizadores</div>
                            <div class="page-subtitle">Activar, bloquear e consultar contas</div>
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

                    <!-- Lista -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="bi bi-people" style="margin-right:.4rem"></i>Utilizadores
                                <c:if test="${not empty param.q or not empty param.perfil or not empty param.status}">
                                    <span class="tag-filtro"><i class="bi bi-funnel"></i> Filtro activo</span>
                                </c:if>
                            </h3>
                            <span class="tag">${not empty totalUtilizadores ? totalUtilizadores : 0} registo(s)</span>
                            <button type="button" id="btnAbrirFiltros" class="btn btn-primary btn-md" style="gap:.4rem">
                                <i class="bi bi-funnel"></i> Filtrar
                            </button>
                            <button type="button" class="btn btn-primary btn-md" style="gap:.4rem" onclick="window.location = '${pageContext.request.contextPath}/admin/registar-funcionario'">
                                <i class="bi bi-person-badge"></i> Registar Funcionário
                            </button>
                        </div>

                        <div class="table-wrap">
                            <table class="uni-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Nome</th>
                                        <th>Email</th>
                                        <th style="text-align:center">Perfil</th>
                                        <th style="text-align:center">Estado</th>
                                        <th style="text-align:center">Acções</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty utilizadores}">
                                            <tr>
                                                <td colspan="6">
                                                    <div class="empty-state">
                                                        <i class="bi bi-people"></i>
                                                        <h3>Sem resultados</h3>
                                                        <p>Nenhum utilizador encontrado para os filtros seleccionados.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="u" items="${utilizadores}" varStatus="s">
                                                <tr>
                                                    <td class="muted">${s.count}</td>
                                                    <td><strong>${u.nome}</strong></td>
                                                    <td class="muted" style="font-size:.82rem">${u.email}</td>
                                                    <td style="text-align:center">
                                                        <c:choose>
                                                            <c:when test="${u.perfil == 'ADMIN'}">
                                                                <span class="badge badge-accent"><i class="bi bi-shield-check"></i> Admin</span>
                                                            </c:when>
                                                            <c:when test="${u.perfil == 'FUNCIONARIO'}">
                                                                <span class="badge badge-info"><i class="bi bi-briefcase"></i> Funcionário</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-neutral"><i class="bi bi-person"></i> Estudante</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="text-align:center">
                                                        <c:choose>
                                                            <c:when test="${u.status == 'ACTIVO'}">
                                                                <span class="badge badge-success"><i class="bi bi-circle-fill" style="font-size:.45rem"></i> Activo</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-danger"><i class="bi bi-circle-fill" style="font-size:.45rem"></i> Bloqueado</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="actions" style="display:flex;gap:.78em;justify-content:center">
                                                            <c:if test="${u.id != sessionScope.utilizadorLogado.id}">
                                                                <c:choose>
                                                                    <c:when test="${u.status == 'ACTIVO'}">
                                                                        <form action="${pageContext.request.contextPath}/admin/utilizadores" method="post" style="display:inline">
                                                                            <input type="hidden" name="acao" value="bloquear">
                                                                            <input type="hidden" name="id" value="${u.id}">
                                                                            <button type="submit" class="btn btn-outline-danger btn-sm"
                                                                                    data-confirm="Bloquear a conta de ${u.nome}?" title="Bloquear">
                                                                                <i class="bi bi-lock"></i> Bloquear
                                                                            </button>
                                                                        </form>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <form action="${pageContext.request.contextPath}/admin/utilizadores" method="post" style="display:inline">
                                                                            <input type="hidden" name="acao" value="activar">
                                                                            <input type="hidden" name="id" value="${u.id}">
                                                                            <button type="submit" class="btn btn-success btn-sm"
                                                                                    data-confirm="Activar a conta de ${u.nome}?" title="Activar">
                                                                                <i class="bi bi-unlock"></i> Activar
                                                                            </button>
                                                                        </form>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:if>
                                                            <c:if test="${u.id == sessionScope.utilizadorLogado.id}">
                                                                <span class="muted" style="font-size:.82rem">(conta própria)</span>
                                                            </c:if>
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
                    <!-- Modal de Filtros -->
                    <div class="modal-overlay" id="modalFiltros">
                        <div class="modal-box">
                            <div class="modal-header">
                                <h3><i class="bi bi-funnel"></i> Filtrar Utilizadores</h3>
                                <button type="button" class="modal-close" id="btnFecharFiltros">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/admin/utilizadores" method="get">
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label class="form-label" for="filtroQ">Nome ou Email</label>
                                        <input type="text" id="filtroQ" name="q" class="form-control"
                                               placeholder="Pesquisar por nome ou email…" maxlength="100"
                                               value="${param.q}">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="filtroPerfil">Perfil</label>
                                        <select id="filtroPerfil" name="perfil" class="form-control">
                                            <option value="">Todos os perfis</option>
                                            <option value="ADMIN"       ${param.perfil eq 'ADMIN'       ? 'selected' : ''}>Administrador</option>
                                            <option value="FUNCIONARIO" ${param.perfil eq 'FUNCIONARIO' ? 'selected' : ''}>Funcionário</option>
                                            <option value="ESTUDANTE"   ${param.perfil eq 'ESTUDANTE'   ? 'selected' : ''}>Estudante</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="filtroStatus">Estado</label>
                                        <select id="filtroStatus" name="status" class="form-control">
                                            <option value="">Todos os estados</option>
                                            <option value="ACTIVO"    ${param.status eq 'ACTIVO'    ? 'selected' : ''}>Activos</option>
                                            <option value="BLOQUEADO" ${param.status eq 'BLOQUEADO' ? 'selected' : ''}>Bloqueados</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline" onclick="window.location = '${pageContext.request.contextPath}/admin/utilizadores'">
                                        <i class="bi bi-x-circle"></i> Limpar Filtros
                                    </button>
                                    <button type="button" class="btn btn-outline" id="btnCancelarFiltros">Cancelar</button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-search"></i> Aplicar Filtros
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
        <script src="${pageContext.request.contextPath}/assets/scripts/modal.js"></script>
    </body>
</html>
