<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Gerir turmas no UNIHELP. Associe turmas a cursos e períodos letivos.">
        <meta name="keywords" content="turmas, gestão académica, cursos, períodos, UNIHELP">
        <meta property="og:title" content="Gerir Turmas — Admin | UNIHELP">
        <meta property="og:description" content="Painel de gestão de turmas para administradores.">
        <meta property="og:type" content="website">
        <title>Gerir Turmas — Admin | UNIHELP</title>
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
                    <a href="${pageContext.request.contextPath}/admin/turmas"               class="sidebar-link active"><i class="bi bi-collection"></i> Turmas</a>
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
                            <div class="page-title">Gerir Turmas</div>
                            <div class="page-subtitle">Turmas por curso e período letivo</div>
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

                    <div style="display:grid;grid-template-columns:1fr;gap:1.25rem;align-items:start">

                        <!-- Lista -->
                        <div class="card">
                            <div class="card-header">
                                <h3><i class="bi bi-collection" style="margin-right:.4rem"></i>Turmas Registadas
                                    <c:if test="${not empty param.nome or not empty param.idCurso or not empty param.idPeriodoLetivo}">
                                        <span class="tag-filtro"><i class="bi bi-funnel"></i> Filtro activo</span>
                                    </c:if>
                                </h3>
                                <span class="tag">${not empty turmas ? turmas.size() : 0} registo(s)</span>
                                <div style="display:flex;gap:.6rem">
                                    <button type="button" id="btnAbrirFiltros" class="btn btn-primary btn-md" style="gap:.4rem">
                                        <i class="bi bi-funnel"></i> Filtrar
                                    </button>
                                    <button type="button" id="btnNovaTurma" class="btn btn-primary btn-md" style="gap:.4rem">
                                        <i class="bi bi-plus-circle"></i> Nova Turma
                                    </button>
                                </div>
                            </div>
                            <div class="table-wrap">
                                <table class="uni-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Turma</th>
                                            <th>Curso</th>
                                            <th>Período</th>
                                            <th>Sala</th>
                                            <th style="text-align:center">Acções</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty turmas}">
                                                <tr>
                                                    <td colspan="6">
                                                        <div class="empty-state">
                                                            <i class="bi bi-collection"></i>
                                                            <h3>Sem turmas</h3>
                                                            <p>Adicione a primeira turma clicando em <strong>Nova Turma</strong>.</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="t" items="${turmas}" varStatus="s">
                                                    <tr>
                                                        <td class="muted">${s.count}</td>
                                                        <td><strong>${t.nome}</strong></td>
                                                        <td class="muted">${not empty t.nomeCurso ? t.nomeCurso : '—'}</td>
                                                        <td class="muted">${not empty t.nomePeriodo ? t.nomePeriodo : '—'}</td>
                                                        <td class="muted">${not empty t.sala ? t.sala : '—'}</td>
                                                        <td>
                                                            <div class="actions" style="display:flex;gap:.78em;justify-content:center">
                                                                <button type="button" class="btn btn-outline btn-sm" title="Editar"
                                                                        onclick="preencherForm('${t.id}', '${t.nome}', '${t.idCurso}', '${t.idPeriodoLetivo}', '${t.sala}', '${t.anoAcademico}')">
                                                                    <i class="bi bi-pencil"></i>
                                                                </button>
                                                                <form action="${pageContext.request.contextPath}/admin/turmas" method="post" style="display:inline">
                                                                    <input type="hidden" name="acao" value="eliminar">
                                                                    <input type="hidden" name="id" value="${t.id}">
                                                                    <button type="submit" class="btn btn-outline-danger btn-sm" title="Eliminar"
                                                                            data-confirm="Eliminar a turma '${t.nome}'?">
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
                    <!-- Modal de Filtros -->
                    <div class="modal-overlay" id="modalFiltros">
                        <div class="modal-box">
                            <div class="modal-header">
                                <h3><i class="bi bi-funnel"></i> Filtrar Turmas</h3>
                                <button type="button" class="modal-close" id="btnFecharFiltros">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/admin/turmas" method="get">
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label class="form-label" for="filtroNome">Nome da Turma</label>
                                        <input type="text" id="filtroNome" name="nome" class="form-control"
                                               placeholder="Pesquisar por nome…" maxlength="60"
                                               value="${param.nome}">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="filtroCurso">Curso</label>
                                        <select id="filtroCurso" name="idCurso" class="form-control">
                                            <option value="">Todos os cursos</option>
                                            <c:forEach var="c" items="${cursos}">
                                                <option value="${c.id}" ${param.idCurso eq c.id ? 'selected' : ''}>${c.nome}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="filtroPeriodo">Período Letivo</label>
                                        <select id="filtroPeriodo" name="idPeriodoLetivo" class="form-control">
                                            <option value="">Todos os períodos</option>
                                            <c:forEach var="p" items="${periodos}">
                                                <option value="${p.id}" ${param.idPeriodoLetivo eq p.id ? 'selected' : ''}>${p.nomeFormatado}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline" onclick="window.location='${pageContext.request.contextPath}/admin/turmas'">
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

                    <!-- Modal de Nova Turma -->
                    <div class="modal-overlay" id="modalNovaTurma">
                        <div class="modal-box">
                            <div class="modal-header">
                                <h3 id="modalTurmaTitulo"><i class="bi bi-plus-circle"></i> Adicionar Turma</h3>
                                <button type="button" class="modal-close" id="btnFecharNovaTurma">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/admin/turmas" method="post" id="formTurmaModal">
                                <input type="hidden" name="acao" id="turmaAcaoModal" value="criar">
                                <input type="hidden" name="id"    id="turmaIdModal"  value="">
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label class="form-label" for="nomeModal">Nome da Turma <span class="req">*</span></label>
                                        <input type="text" id="nomeModal" name="nome" class="form-control"
                                               placeholder="Ex: LCC1T" maxlength="80" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="idCursoModal">Curso <span class="req">*</span></label>
                                        <select id="idCursoModal" name="idCurso" class="form-control" required>
                                            <option value="">— Seleccione o curso —</option>
                                            <c:forEach var="c" items="${cursos}">
                                                <option value="${c.id}">${c.nome}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="idPeriodoLetivoModal">Período Letivo <span class="req">*</span></label>
                                        <select id="idPeriodoLetivoModal" name="idPeriodoLetivo" class="form-control" required>
                                            <option value="">— Seleccione o período —</option>
                                            <c:forEach var="p" items="${periodos}">
                                                <option value="${p.id}">${p.nomeFormatado}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="anoAcademicoModal">Ano Académico <span class="req">*</span></label>
                                        <select id="anoAcademicoModal" name="anoAcademico" class="form-control" required>
                                            <option value="">— Seleccione —</option>
                                            <option value="1">1º Ano</option>
                                            <option value="2">2º Ano</option>
                                            <option value="3">3º Ano</option>
                                            <option value="4">4º Ano</option>
                                            <option value="5">5º Ano</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="salaModal">Sala</label>
                                        <input type="text" id="salaModal" name="sala" class="form-control"
                                               placeholder="Ex: Sala 301" maxlength="30">
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline" id="btnCancelarNovaTurma">Cancelar</button>
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

                // --- Modal de Nova Turma ---
                var overlay = document.getElementById('modalNovaTurma');
                var btnAbrir = document.getElementById('btnNovaTurma');
                var btnFechar = document.getElementById('btnFecharNovaTurma');
                var btnCancelar = document.getElementById('btnCancelarNovaTurma');

                function abrir() {
                    var form = document.getElementById('formTurmaModal');
                    if (form) {
                        form.reset();
                        document.getElementById('turmaAcaoModal').value = 'criar';
                        document.getElementById('turmaIdModal').value = '';
                        document.getElementById('modalTurmaTitulo').innerHTML = '<i class="bi bi-plus-circle"></i> Adicionar Turma';
                        document.getElementById('btnTextoModal').textContent = 'Adicionar';
                    }
                    overlay.classList.add('open');
                    document.body.style.overflow = 'hidden';
                    setTimeout(function () { document.getElementById('nomeModal').focus(); }, 350);
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

                // --- Preencher formulário no modal para edição ---
                window.preencherForm = function (id, nome, idCurso, idPeriodoLetivo, sala, anoAcademico) {
                    document.getElementById('turmaAcaoModal').value = 'editar';
                    document.getElementById('turmaIdModal').value = id;
                    document.getElementById('nomeModal').value = nome;
                    selById('idCursoModal', idCurso);
                    selById('idPeriodoLetivoModal', idPeriodoLetivo);
                    selById('anoAcademicoModal', anoAcademico);
                    document.getElementById('salaModal').value = sala || '';
                    document.getElementById('modalTurmaTitulo').innerHTML = '<i class="bi bi-pencil"></i> Editar Turma';
                    document.getElementById('btnTextoModal').textContent = 'Guardar Alterações';
                    overlay.classList.add('open');
                    document.body.style.overflow = 'hidden';
                    setTimeout(function () { document.getElementById('nomeModal').focus(); }, 350);
                };

                function selById(selId, val) {
                    var sel = document.getElementById(selId);
                    for (var i = 0; i < sel.options.length; i++) {
                        if (sel.options[i].value == val) {
                            sel.selectedIndex = i;
                            break;
                        }
                    }
                }
            })();
        </script>
    </body>
</html>
