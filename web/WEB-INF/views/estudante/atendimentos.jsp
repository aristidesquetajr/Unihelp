<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Meus Atendimentos — UNIHELP | OJJ</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
    </head>
    <body>

        <!-- NAVEGAÇÃO -->
        <nav class="topnav">
            <div class="topnav-inner">
                <a href="${pageContext.request.contextPath}/estudante/dashboard" class="topnav-brand">
                    <div class="brand-logo">UH</div>
                    UNIHELP
                </a>
                <div class="topnav-links">
                    <a href="${pageContext.request.contextPath}/estudante/dashboard"    class="topnav-link"><i class="bi bi-grid-1x2"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/estudante/perfil"       class="topnav-link"><i class="bi bi-person"></i> Perfil</a>
                    <a href="${pageContext.request.contextPath}/estudante/agendar"      class="topnav-link"><i class="bi bi-calendar-plus"></i> Agendar</a>
                    <a href="${pageContext.request.contextPath}/estudante/atendimentos" class="topnav-link active"><i class="bi bi-calendar2-check"></i> Atendimentos</a>
                    <a href="${pageContext.request.contextPath}/estudante/boletim"      class="topnav-link"><i class="bi bi-journal-text"></i> Boletim</a>
                    <a href="${pageContext.request.contextPath}/estudante/inscricoes"   class="topnav-link"><i class="bi bi-book"></i> Inscrições</a>
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
                    <h2 style="font-size:1.2rem;font-weight:800">Os Meus Atendimentos</h2>
                    <p class="muted text-sm">Histórico completo dos seus pedidos de atendimento.</p>
                </div>
                <a href="${pageContext.request.contextPath}/estudante/agendar" class="btn btn-primary">
                    <i class="bi bi-calendar-plus"></i> Novo Agendamento
                </a>
            </div>

            <%-- Alertas flash --%>
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

            <!-- Filtro por estado -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="bi bi-funnel" style="margin-right:.4rem"></i>Filtrar por Estado</h3>
                </div>
                <div class="card-body" style="padding:.9rem 1.25rem">
                    <form action="${pageContext.request.contextPath}/estudante/atendimentos"
                          method="get"
                          style="display:flex;gap:.75rem;align-items:center;flex-wrap:wrap">
                        <select name="estado" class="form-control" style="max-width:220px">
                            <option value="">Todos os estados</option>
                            <option value="PENDENTE"   ${param.estado == 'PENDENTE'   ? 'selected' : ''}>Pendentes</option>
                            <option value="CONFIRMADO" ${param.estado == 'CONFIRMADO' ? 'selected' : ''}>Confirmados</option>
                            <option value="REJEITADO"  ${param.estado == 'REJEITADO'  ? 'selected' : ''}>Rejeitados</option>
                        </select>
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="bi bi-search"></i> Filtrar
                        </button>
                        <a href="${pageContext.request.contextPath}/estudante/atendimentos"
                           class="btn btn-outline btn-sm">Limpar</a>
                    </form>
                </div>
            </div>

            <!-- Contadores rápidos -->
            <div class="stats-grid" style="margin-top:1rem; grid-template-columns:repeat(3, minmax(0, 1fr));">
                <div class="stat-card">
                    <div class="stat-icon warning"><i class="bi bi-hourglass-split"></i></div>
                    <div>
                        <div class="stat-value">${not empty contPendentes   ? contPendentes   : 0}</div>
                        <div class="stat-label">Pendentes</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon success"><i class="bi bi-check-circle"></i></div>
                    <div>
                        <div class="stat-value">${not empty contConfirmados ? contConfirmados : 0}</div>
                        <div class="stat-label">Confirmados</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon danger"><i class="bi bi-x-circle"></i></div>
                    <div>
                        <div class="stat-value">${not empty contRejeitados  ? contRejeitados  : 0}</div>
                        <div class="stat-label">Rejeitados</div>
                    </div>
                </div>
            </div>

            <!-- Tabela de atendimentos -->
            <div class="card" style="margin-top:1rem">
                <div class="card-header">
                    <h3><i class="bi bi-list-ul" style="margin-right:.4rem"></i>Resultados</h3>
                    <span class="tag">${not empty totalAtendimentos ? totalAtendimentos : 0} registo(s)</span>
                </div>
                <div class="table-wrap">
                    <table class="uni-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Data</th>
                                <th>Hora</th>
                                <th>Descrição</th>
                                <th>Funcionário</th>
                                <th>Estado</th>
                                <th>Observação</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty atendimentos}">
                                    <tr><td colspan="7">
                                            <div class="empty-state">
                                                <i class="bi bi-calendar-x"></i>
                                                <h3>Nenhum atendimento encontrado</h3>
                                                <p>
                                                    <c:choose>
                                                        <c:when test="${not empty param.estado}">Sem resultados para o filtro seleccionado.</c:when>
                                                        <c:otherwise>Ainda não agendou nenhum atendimento. <a href="${pageContext.request.contextPath}/estudante/agendar">Agendar agora</a></c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="a" items="${atendimentos}" varStatus="s">
                                        <tr>
                                            <td class="muted">${s.count}</td>
                                            <td><fmt:formatDate value="${a.dataAgendada}" pattern="dd/MM/yyyy"/></td>
                                            <td class="muted"><fmt:formatDate value="${a.dataAgendada}" pattern="HH:mm"/></td>
                                            <td style="max-width:220px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis"
                                                title="${a.descricao}">${a.descricao}</td>
                                            <td>${not empty a.nomeFuncionario ? a.nomeFuncionario : '—'}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${a.estado == 'PENDENTE'}">
                                                        <span class="badge badge-warning"><i class="bi bi-hourglass-split"></i> Pendente</span>
                                                    </c:when>
                                                    <c:when test="${a.estado == 'CONFIRMADO'}">
                                                        <span class="badge badge-success"><i class="bi bi-check-lg"></i> Confirmado</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-danger"><i class="bi bi-x-lg"></i> Rejeitado</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="muted" style="font-size:.8rem">
                                                ${not empty a.motivoRejeicao ? a.motivoRejeicao : '—'}
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
