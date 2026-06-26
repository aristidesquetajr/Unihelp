<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c"   uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Gerir períodos letivos no UNIHELP. Crie, edite e active semestres académicos.">
        <meta name="keywords" content="períodos letivos, semestres, calendário académico, UNIHELP">
        <meta property="og:title" content="Períodos Letivos — Admin | UNIHELP">
        <meta property="og:description" content="Painel de gestão de períodos letivos para administradores.">
        <meta property="og:type" content="website">
        <title>Períodos Letivos — Admin | UNIHELP</title>
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
                    <a href="${pageContext.request.contextPath}/admin/disciplinas"          class="sidebar-link"><i class="bi bi-book"></i> Disciplinas</a>
                    <a href="${pageContext.request.contextPath}/admin/turmas"               class="sidebar-link"><i class="bi bi-collection"></i> Turmas</a>
                    <a href="${pageContext.request.contextPath}/admin/periodos"             class="sidebar-link active"><i class="bi bi-calendar3"></i> Períodos Letivos</a>
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
                            <div class="page-title">Períodos Letivos</div>
                            <div class="page-subtitle">Gerir anos e semestres académicos</div>
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
                            <c:when test="${mensagem.startsWith('Erro')}">
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

                    <div style="display:grid;grid-template-columns:1fr;gap:1.25rem;align-items:start">

                        <!-- Formulário -->
                        <div class="card" style="position:sticky;top:calc(var(--topbar-h) + 1rem)">
                            <div class="card-header">
                                <h3 id="formTitulo"><i class="bi bi-plus-circle" style="margin-right:.4rem"></i>Adicionar Período</h3>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/admin/periodos" method="post" data-loading id="formPer">
                                    <input type="hidden" name="acao" id="perAcao" value="criar">
                                    <input type="hidden" name="id"    id="perId"  value="">
                                    
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label" for="anoLetivo">Ano Letivo <span class="req">*</span></label>
                                            <input type="text" id="anoLetivo" name="anoLetivo" class="form-control"
                                                   placeholder="Ex: 2025/2026" maxlength="20" required>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label" for="semestre">Semestre <span class="req">*</span></label>
                                            <select id="semestre" name="semestre" class="form-control" required>
                                                <option value="">— Seleccione —</option>
                                                <option value="1">1º Semestre</option>
                                                <option value="2">2º Semestre</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label" for="dataInicio">Data de Início <span class="req">*</span></label>
                                            <input type="date" id="dataInicio" name="dataInicio" class="form-control" required>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label" for="dataFim">Data de Fim <span class="req">*</span></label>
                                            <input type="date" id="dataFim" name="dataFim" class="form-control" required>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label style="display:flex;align-items:center;gap:.5rem;cursor:pointer;font-size:.875rem">
                                            <input type="checkbox" id="ativoChk" name="ativo" value="true" style="width:16px;height:16px">
                                            <span>Marcar como período activo</span>
                                        </label>
                                        <span class="form-hint">Apenas um período deve estar activo de cada vez.</span>
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


                        <!-- Lista -->
                        <div class="card">
                            <div class="card-header">
                                <h3><i class="bi bi-calendar3" style="margin-right:.4rem"></i>Períodos Registados</h3>
                                <span class="tag">${not empty periodos ? periodos.size() : 0} registo(s)</span>
                            </div>
                            <div class="table-wrap">
                                <table class="uni-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Nome</th>
                                            <th>Semestre</th>
                                            <th>Início</th>
                                            <th>Fim</th>
                                            <th style="text-align:center">Estado</th>
                                            <th style="text-align:center">Acções</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty periodos}">
                                                <tr>
                                                    <td colspan="7">
                                                        <div class="empty-state">
                                                            <i class="bi bi-calendar-x"></i>
                                                            <h3>Sem períodos</h3>
                                                            <p>Adicione o primeiro período letivo usando o formulário.</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="p" items="${periodos}" varStatus="s">
                                                    <tr>
                                                        <td class="muted">${s.count}</td>
                                                        <td><strong>${p.anoLetivo}</strong></td>
                                                        <td>${p.semestre}º</td>
                                                        <td class="muted"><fmt:formatDate value="${p.dataInicio}" pattern="dd/MM/yyyy"/></td>
                                                        <td class="muted"><fmt:formatDate value="${p.dataFim}" pattern="dd/MM/yyyy"/></td>
                                                        <td style="text-align:center">
                                                            <c:choose>
                                                                <c:when test="${p.ativo}">
                                                                    <span class="badge badge-success"><i class="bi bi-circle-fill" style="font-size:.45rem"></i> Ativo</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-neutral">Inativo</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="actions" style="display:flex;gap:.78em;justify-content:center">
                                                                <c:set var="dtInicio"><fmt:formatDate value="${p.dataInicio}" pattern="yyyy-MM-dd"/></c:set>
                                                                <c:set var="dtFim"><fmt:formatDate value="${p.dataFim}" pattern="yyyy-MM-dd"/></c:set>
                                                                    <button type="button" class="btn btn-outline btn-sm" title="Editar"
                                                                            onclick="preencherForm('${p.id}', '${p.anoLetivo}', '${p.semestre}', '${dtInicio}', '${dtFim}', '${p.ativo}')">
                                                                    <i class="bi bi-pencil"></i>
                                                                </button>
                                                                <c:if test="${not p.ativo}">
                                                                    <form action="${pageContext.request.contextPath}/admin/periodos" method="post" style="display:inline">
                                                                        <input type="hidden" name="acao" value="activar">
                                                                        <input type="hidden" name="id" value="${p.id}">
                                                                        <button type="submit" class="btn btn-outline btn-sm" title="Activar">
                                                                            <i class="bi bi-check-circle"></i>
                                                                        </button>
                                                                    </form>
                                                                </c:if>
                                                                <form action="${pageContext.request.contextPath}/admin/periodos" method="post" style="display:inline">
                                                                    <input type="hidden" name="acao" value="eliminar">
                                                                    <input type="hidden" name="id" value="${p.id}">
                                                                    <button type="submit" class="btn btn-outline-danger btn-sm" title="Eliminar"
                                                                            data-confirm="Eliminar o período '${p.anoLetivo}'?">
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
                    </div>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
        <script>
                                                                                function preencherForm(id, anoLetivo, semestre, dataInicio, dataFim, ativo) {
                                                                                    document.getElementById('perAcao').value = 'editar';
                                                                                    document.getElementById('perId').value = id;
                                                                                    document.getElementById('anoLetivo').value = anoLetivo;
                                                                                    document.getElementById('semestre').value = semestre;
                                                                                    document.getElementById('dataInicio').value = dataInicio;
                                                                                    document.getElementById('dataFim').value = dataFim;
                                                                                    document.getElementById('ativoChk').checked = (ativo === 'true');
                                                                                    document.getElementById('formTitulo').innerHTML = '<i class="bi bi-pencil" style="margin-right:.4rem"></i>Editar Período';
                                                                                    document.getElementById('btnTexto').textContent = 'Guardar Alterações';
                                                                                    document.getElementById('anoLetivo').focus();
                                                                                }
                                                                                function resetForm() {
                                                                                    document.getElementById('perAcao').value = 'criar';
                                                                                    document.getElementById('perId').value = '';
                                                                                    document.getElementById('formPer').reset();
                                                                                    document.getElementById('formTitulo').innerHTML = '<i class="bi bi-plus-circle" style="margin-right:.4rem"></i>Adicionar Período';
                                                                                    document.getElementById('btnTexto').textContent = 'Adicionar';
                                                                                }
        </script>
    </body>
</html>
