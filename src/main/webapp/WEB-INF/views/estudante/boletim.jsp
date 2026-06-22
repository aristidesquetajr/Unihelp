<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Consulte seu boletim de notas no UNIHELP. Acompanhe seu desempenho académico em cada disciplina de forma detalhada.">
        <meta name="keywords" content="boletim notas, desempenho académico, disciplinas, UNIHELP, gestão escolar">
        <meta property="og:title" content="Boletim de Notas — UNIHELP">
        <meta property="og:description" content="Boletim académico com notas em todas as disciplinas inscritas.">
        <meta property="og:type" content="website">
        <title>Boletim de Notas — UNIHELP | OJJ</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
    </head>
    <body>

        <nav class="topnav">
            <div class="topnav-inner">
                <a href="${pageContext.request.contextPath}/estudante/dashboard" class="topnav-brand">
                    <div class="brand-logo">UH</div> UNIHELP
                </a>
                <div class="topnav-links">
                    <a href="${pageContext.request.contextPath}/estudante/dashboard" class="topnav-link"><i class="bi bi-grid-1x2"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/estudante/perfil" class="topnav-link"><i class="bi bi-person"></i> Perfil</a>
                    <a href="${pageContext.request.contextPath}/estudante/agendar" class="topnav-link"><i class="bi bi-calendar-plus"></i> Agendar</a>
                    <a href="${pageContext.request.contextPath}/estudante/atendimentos" class="topnav-link"><i class="bi bi-calendar2-check"></i> Atendimentos</a>
                    <a href="${pageContext.request.contextPath}/estudante/boletim" class="topnav-link active"><i class="bi bi-journal-text"></i> Boletim</a>
                    <a href="${pageContext.request.contextPath}/estudante/inscricoes" class="topnav-link"><i class="bi bi-book"></i> Inscrições</a>
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

        <div class="topnav-content">

            <div class="section-header mb-3">
                <div>
                    <h2 style="font-size:1.2rem;font-weight:800">Boletim de Notas</h2>
                    <p class="muted text-sm">Consulte o desempenho académico por período, disciplina e tipo de avaliação.</p>
                </div>
            </div>

            <c:if test="${not empty erro}">
                <div class="alert alert-danger" data-dismiss>
                    <i class="bi bi-exclamation-circle-fill"></i><div>${erro}</div>
                </div>
            </c:if>

            <div class="card mb-3">
                <div class="card-header">
                    <h3><i class="bi bi-funnel" style="margin-right:.4rem"></i>Filtros</h3>
                    <span class="tag">${not empty totalNotas ? totalNotas : 0} registo(s)</span>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/estudante/boletim"
                          method="get"
                          class="filter-form">
                        <div class="form-group">
                            <label class="form-label" for="periodoId">Período letivo</label>
                            <select id="periodoId" name="periodoId" class="form-control">
                                <option value="">Todos os períodos</option>
                                <c:forEach var="p" items="${periodos}">
                                    <option value="${p.id}" ${param.periodoId == p.id ? 'selected' : ''}>
                                        ${p.anoLetivo} - ${p.semestre}.º semestre
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="disciplina">Disciplina</label>
                            <select id="disciplina" name="disciplina" class="form-control">
                                <option value="">Todas as disciplinas</option>
                                <c:forEach var="disciplina" items="${disciplinas}">
                                    <option value="${disciplina}" ${disciplinaFiltrada == disciplina ? 'selected' : ''}>
                                        ${disciplina}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="filter-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i> Consultar
                            </button>
                            <a href="${pageContext.request.contextPath}/estudante/boletim" class="btn btn-outline">
                                Limpar
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty boletimPeriodos}">
                    <div class="card">
                        <div class="empty-state">
                            <i class="bi bi-journal-x"></i>
                            <h3>Nenhuma nota encontrada</h3>
                            <p>Ainda não existem notas registadas para os filtros seleccionados.</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon primary"><i class="bi bi-graph-up-arrow"></i></div>
                            <div>
                                <div class="stat-value"><fmt:formatNumber value="${mediaGeral}" minFractionDigits="1" maxFractionDigits="1"/></div>
                                <div class="stat-label">Média Geral</div>
                            </div>
                        </div>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 1em">
                        <c:forEach var="periodo" items="${boletimPeriodos}">
                            <div class="card boletim-period-card">
                                <div class="card-header">
                                    <h3><i class="bi bi-journal-check" style="margin-right:.4rem"></i>${periodo.legenda} ${periodo.totalNotas} nota(s)</h3>
                                </div>
                                <div class="table-wrap">
                                    <table class="uni-table boletim-table">
                                        <thead>
                                            <tr>
                                                <th>Disciplina</th>
                                                <th>Código</th>
                                                <th style="text-align:center">Avaliação</th>
                                                <th style="text-align:center">P1/P2</th>
                                                <th style="text-align:center">Recurso</th>
                                                <th style="text-align:center">Média</th>
                                                <th style="text-align:center">Estado</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="linha" items="${periodo.disciplinas}">
                                                <tr class="${linha.aprovado ? '' : 'row-risk'}">
                                                    <td><strong>${linha.disciplina}</strong></td>
                                                    <td class="muted">${not empty linha.codigo ? linha.codigo : '—'}</td>
                                                    <td style="text-align:center">
                                                        <c:choose>
                                                            <c:when test="${linha.avaliacao != null}">
                                                                <fmt:formatNumber value="${linha.avaliacao}" minFractionDigits="0" maxFractionDigits="1"/>
                                                            </c:when>
                                                            <c:otherwise>0</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="text-align:center">
                                                        <c:choose>
                                                            <c:when test="${linha.exame != null}">
                                                                <fmt:formatNumber value="${linha.exame}" minFractionDigits="0" maxFractionDigits="1"/>
                                                            </c:when>
                                                            <c:otherwise>0</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="text-align:center">
                                                        <c:choose>
                                                            <c:when test="${linha.recurso != null}">
                                                                <fmt:formatNumber value="${linha.recurso}" minFractionDigits="0" maxFractionDigits="1"/>
                                                            </c:when>
                                                            <c:otherwise>0</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="text-align:center">
                                                        <span class="grade-val ${linha.aprovado ? 'grade-pass' : 'grade-fail'}">
                                                            <fmt:formatNumber value="${linha.media}" minFractionDigits="0" maxFractionDigits="1"/>
                                                        </span>
                                                    </td>
                                                    <td style="text-align:center">
                                                        <c:choose>
                                                            <c:when test="${linha.aprovado}">
                                                                <span class="badge badge-success"><i class="bi bi-check-lg"></i> Aprovado</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-danger"><i class="bi bi-x-lg"></i> Reprovado</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
    </body>
</html>
