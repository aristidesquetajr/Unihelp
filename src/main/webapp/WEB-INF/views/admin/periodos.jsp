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

                        <!-- Lista -->
                        <div class="card">
                            <div class="card-header">
                                <h3><i class="bi bi-calendar3" style="margin-right:.4rem"></i>Períodos Registados</h3>
                                <span class="tag">${not empty periodos ? periodos.size() : 0} registo(s)</span>
                                <button type="button" id="btnNovoPeriodo" class="btn btn-primary btn-md" style="gap:.4rem">
                                    <i class="bi bi-plus-circle"></i> Novo Período
                                </button>
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
                                                            <p>Adicione o primeiro período letivo clicando em <strong>Novo Período</strong>.</p>
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
                    <!-- Modal de Novo Período -->
                    <div class="modal-overlay" id="modalNovoPeriodo">
                        <div class="modal-box">
                            <div class="modal-header">
                                <h3 id="modalPerTitulo"><i class="bi bi-plus-circle"></i> Adicionar Período</h3>
                                <button type="button" class="modal-close" id="btnFecharNovoPeriodo">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/admin/periodos" method="post" id="formPerModal">
                                <input type="hidden" name="acao" id="perAcaoModal" value="criar">
                                <input type="hidden" name="id"    id="perIdModal"  value="">
                                <div class="modal-body">
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label" for="anoLetivoModal">Ano Letivo <span class="req">*</span></label>
                                            <input type="text" id="anoLetivoModal" name="anoLetivo" class="form-control"
                                                   placeholder="Ex: 2025/2026" maxlength="20" required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label" for="semestreModal">Semestre <span class="req">*</span></label>
                                            <select id="semestreModal" name="semestre" class="form-control" required>
                                                <option value="">— Seleccione —</option>
                                                <option value="1">1º Semestre</option>
                                                <option value="2">2º Semestre</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label" for="dataInicioModal">Data de Início <span class="req">*</span></label>
                                            <input type="date" id="dataInicioModal" name="dataInicio" class="form-control" required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label" for="dataFimModal">Data de Fim <span class="req">*</span></label>
                                            <input type="date" id="dataFimModal" name="dataFim" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label style="display:flex;align-items:center;gap:.5rem;cursor:pointer;font-size:.875rem">
                                            <input type="checkbox" id="ativoChkModal" name="ativo" value="true" style="width:16px;height:16px">
                                            <span>Marcar como período activo</span>
                                        </label>
                                        <span class="form-hint">Apenas um período deve estar activo de cada vez.</span>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline" id="btnCancelarNovoPeriodo">Cancelar</button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save"></i> <span id="btnTextoModal">Adicionar</span>
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
        <script>
            (function () {
                'use strict';

                var overlay = document.getElementById('modalNovoPeriodo');
                var btnAbrir = document.getElementById('btnNovoPeriodo');
                var btnFechar = document.getElementById('btnFecharNovoPeriodo');
                var btnCancelar = document.getElementById('btnCancelarNovoPeriodo');

                function abrir() {
                    var form = document.getElementById('formPerModal');
                    if (form) {
                        form.reset();
                        document.getElementById('perAcaoModal').value = 'criar';
                        document.getElementById('perIdModal').value = '';
                        document.getElementById('modalPerTitulo').innerHTML = '<i class="bi bi-plus-circle"></i> Adicionar Período';
                        document.getElementById('btnTextoModal').textContent = 'Adicionar';
                    }
                    overlay.classList.add('open');
                    document.body.style.overflow = 'hidden';
                    setTimeout(function () { document.getElementById('anoLetivoModal').focus(); }, 350);
                }

                function fechar() {
                    overlay.classList.remove('open');
                    document.body.style.overflow = '';
                }

                if (btnAbrir) btnAbrir.addEventListener('click', abrir);
                if (btnFechar) btnFechar.addEventListener('click', fechar);
                if (btnCancelar) btnCancelar.addEventListener('click', fechar);

                overlay.addEventListener('click', function (e) {
                    if (e.target === overlay) fechar();
                });

                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && overlay.classList.contains('open')) fechar();
                });

                window.preencherForm = function (id, anoLetivo, semestre, dataInicio, dataFim, ativo) {
                    document.getElementById('perAcaoModal').value = 'editar';
                    document.getElementById('perIdModal').value = id;
                    document.getElementById('anoLetivoModal').value = anoLetivo;
                    document.getElementById('semestreModal').value = semestre;
                    document.getElementById('dataInicioModal').value = dataInicio;
                    document.getElementById('dataFimModal').value = dataFim;
                    document.getElementById('ativoChkModal').checked = (ativo === 'true');
                    document.getElementById('modalPerTitulo').innerHTML = '<i class="bi bi-pencil"></i> Editar Período';
                    document.getElementById('btnTextoModal').textContent = 'Guardar Alterações';
                    overlay.classList.add('open');
                    document.body.style.overflow = 'hidden';
                    setTimeout(function () { document.getElementById('anoLetivoModal').focus(); }, 350);
                };
            })();
        </script>
    </body>
</html>
