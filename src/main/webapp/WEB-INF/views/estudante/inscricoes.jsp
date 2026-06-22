<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Consulte seu histórico de inscrições no UNIHELP. Veja todos os cursos e períodos académicos em que se inscreveu.">
        <meta name="keywords" content="inscrições, histórico académico, cursos, UNIHELP, gestão escolar">
        <meta property="og:title" content="Histórico de Inscrições — UNIHELP">
        <meta property="og:description" content="Histórico completo de inscrições académicas e períodos letivos.">
        <meta property="og:type" content="website">
        <title>Histórico de Inscrições — UNIHELP | OJJ</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
    </head>
    <body>

        <!-- NAVEGAÇÃO -->
        <nav class="topnav">
            <div class="topnav-inner">
                <a href="${pageContext.request.contextPath}/estudante/dashboard" class="topnav-brand">
                    <div class="brand-logo">UH</div> UNIHELP
                </a>
                <div class="topnav-links">
                    <a href="${pageContext.request.contextPath}/estudante/dashboard"    class="topnav-link"><i class="bi bi-grid-1x2"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/estudante/perfil"       class="topnav-link"><i class="bi bi-person"></i> Perfil</a>
                    <a href="${pageContext.request.contextPath}/estudante/agendar"      class="topnav-link"><i class="bi bi-calendar-plus"></i> Agendar</a>
                    <a href="${pageContext.request.contextPath}/estudante/atendimentos" class="topnav-link"><i class="bi bi-calendar2-check"></i> Atendimentos</a>
                    <a href="${pageContext.request.contextPath}/estudante/boletim"      class="topnav-link"><i class="bi bi-journal-text"></i> Boletim</a>
                    <a href="${pageContext.request.contextPath}/estudante/inscricoes"   class="topnav-link active"><i class="bi bi-book"></i> Inscrições</a>
                </div>
                <div class="topnav-user">
                    <i class="bi bi-person-circle" style="font-size:1.2rem;color:rgba(255,255,255,.65)"></i>
                    <span>${sessionScope.utilizadorLogado.nome}</span>
                    <a href="${pageContext.request.contextPath}/logout"
                       class="btn btn-sm"
                       style="background:transparent;border-color:rgba(255,255,255,.25);color:rgba(255,255,255,.75)"
                       data-confirm="Deseja terminar a sessão?">
                        <i class="bi bi-box-arrow-right"></i>
                    </a>
                </div>
            </div>
        </nav>

        <!-- CONTEÚDO -->
        <div class="topnav-content">

            <div class="section-header mb-3">
                <div>
                    <h2 style="font-size:1.2rem;font-weight:800">Histórico de Inscrições</h2>
                    <p class="muted text-sm">Acompanhe a inscrição activa e o histórico académico por turma e período.</p>
                </div>
            </div>

            <c:if test="${not empty erro}">
                <div class="alert alert-danger" data-dismiss>
                    <i class="bi bi-exclamation-circle-fill"></i><div>${erro}</div>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty inscricaoActiva}">
                    <div class="card current-enrollment">
                        <div class="card-header">
                            <h3><i class="bi bi-mortarboard" style="margin-right:.4rem"></i>Inscrição Activa</h3>
                            <span class="badge badge-success"><i class="bi bi-circle-fill" style="font-size:.45rem"></i> Activa</span>
                        </div>
                        <div class="enrollment-overview">
                            <div>
                                <span class="lbl">Curso</span>
                                <strong>${not empty inscricaoActiva.nomeCurso ? inscricaoActiva.nomeCurso : '—'}</strong>
                            </div>
                            <div>
                                <span class="lbl">Turma</span>
                                <strong>${not empty inscricaoActiva.nomeTurma ? inscricaoActiva.nomeTurma : '—'}</strong>
                            </div>
                            <div>
                                <span class="lbl">Ano académico</span>
                                <strong>${inscricaoActiva.anoAcademico}</strong>
                            </div>
                            <div>
                                <span class="lbl">Período letivo</span>
                                <strong>${inscricaoActiva.anoLetivo} · ${inscricaoActiva.semestre}.º semestre</strong>
                            </div>
                            <div>
                                <span class="lbl">Sala</span>
                                <strong>${not empty inscricaoActiva.sala ? inscricaoActiva.sala : '—'}</strong>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle-fill"></i>
                        <div>Não existe uma inscrição activa registada para este estudante.</div>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Filtro por estado -->
            <div class="card" style="margin-top:1rem">
                <div class="card-body" style="padding:.9rem 1.25rem">
                    <form action="${pageContext.request.contextPath}/estudante/inscricoes"
                          method="get"
                          class="filter-form filter-form-compact">
                        <div class="form-group">
                            <label class="form-label" for="estado"><i class="bi bi-funnel"></i> Estado</label>
                            <select id="estado" name="estado" class="form-control">
                                <option value="">Todos</option>
                                <option value="ACTIVO"    ${param.estado == 'ACTIVO'    ? 'selected' : ''}>Activas</option>
                                <option value="CONCLUIDO" ${param.estado == 'CONCLUIDO' ? 'selected' : ''}>Concluídas</option>
                                <option value="TRANCADO"  ${param.estado == 'TRANCADO'  ? 'selected' : ''}>Trancadas</option>
                            </select>
                        </div>
                        <div class="filter-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i> Filtrar
                            </button>
                            <a href="${pageContext.request.contextPath}/estudante/inscricoes"
                               class="btn btn-outline">Limpar</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Tabela de inscrições -->
            <div class="card" style="margin-top:1rem">
                <div class="card-header">
                    <h3><i class="bi bi-list-ul" style="margin-right:.4rem"></i>Inscrições</h3>
                    <span class="tag">${not empty totalInscricoes ? totalInscricoes : 0} registo(s)</span>
                </div>
                <div class="table-wrap">
                    <table class="uni-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Curso</th>
                                <th>Turma</th>
                                <th>Sala</th>
                                <th>Ano Acad.</th>
                                <th>Período Letivo</th>
                                <th>Data</th>
                                <th style="text-align:center">Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty inscricoes}">
                                    <tr><td colspan="8">
                                            <div class="empty-state">
                                                <i class="bi bi-journal-x"></i>
                                                <h3>Nenhuma inscrição encontrada</h3>
                                                <p>
                                                    <c:choose>
                                                        <c:when test="${not empty param.estado}">Sem resultados para o filtro seleccionado.</c:when>
                                                        <c:otherwise>Ainda não possui inscrições registadas no sistema.</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="i" items="${inscricoes}" varStatus="s">
                                        <tr class="${i.activo ? 'row-active' : ''}">
                                            <td class="muted">${s.count}</td>
                                            <td><strong>${i.nomeCurso}</strong></td>
                                            <td>${not empty i.nomeTurma ? i.nomeTurma : '—'}</td>
                                            <td class="muted">${not empty i.sala ? i.sala : '—'}</td>
                                            <td>${i.anoAcademico}</td>
                                            <td class="muted">${i.anoLetivo} · ${i.semestre}.º semestre</td>
                                            <td class="muted"><fmt:formatDate value="${i.dataInscricao}" pattern="dd/MM/yyyy"/></td>
                                            <td style="text-align:center">
                                                <c:choose>
                                                    <c:when test="${i.estado == 'ACTIVO'}">
                                                        <span class="badge badge-success"><i class="bi bi-circle-fill" style="font-size:.45rem"></i> Activo</span>
                                                    </c:when>
                                                    <c:when test="${i.estado == 'CONCLUIDO'}">
                                                        <span class="badge badge-primary"><i class="bi bi-check-lg"></i> Concluído</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-warning"><i class="bi bi-pause-fill"></i> Trancado</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div><!-- /topnav-content -->

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
    </body>
</html>
