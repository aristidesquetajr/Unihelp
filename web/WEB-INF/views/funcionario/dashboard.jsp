<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard — Funcionário | UNIHELP</title>
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
                    <span class="nav-section-label">Menu Principal</span>
                    <a href="${pageContext.request.contextPath}/funcionario/dashboard" class="sidebar-link active"><i class="bi bi-speedometer2"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/funcionario/pendentes" class="sidebar-link"><i class="bi bi-hourglass-split"></i> Atendimentos Pendentes</a>
                    <a href="${pageContext.request.contextPath}/funcionario/agenda" class="sidebar-link"><i class="bi bi-calendar2-week"></i> Agenda do Dia</a>

                    <span class="nav-section-label">Estudantes</span>
                    <a href="${pageContext.request.contextPath}/funcionario/estudantes" class="sidebar-link"><i class="bi bi-people"></i> Lista de Estudantes</a>
                    <a href="${pageContext.request.contextPath}/funcionario/registar-estudante" class="sidebar-link"><i class="bi bi-person-plus"></i> Registar Estudante</a>
                    <a href="${pageContext.request.contextPath}/funcionario/lancar-nota" class="sidebar-link"><i class="bi bi-pencil-square"></i> Lançar Nota</a>
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
                            <div class="page-subtitle">Painel do Funcionário</div>
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

            <div class="section-header mb-3">
                <div>
                    <h2 style="font-size:1.2rem;font-weight:800">Olá, ${sessionScope.utilizadorLogado.nome}!</h2>
                    <p class="muted text-sm">Painel de atendimentos e decisões pendentes.</p>
                </div>
                <a href="${pageContext.request.contextPath}/funcionario/pendentes" class="btn btn-primary">
                    <i class="bi bi-hourglass-split"></i> Ver Pendentes
                </a>
            </div>

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

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon warning"><i class="bi bi-hourglass-split"></i></div>
                    <div>
                        <div class="stat-value">${not empty contPendentes ? contPendentes : 0}</div>
                        <div class="stat-label">Pendentes</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon success"><i class="bi bi-calendar2-check"></i></div>
                    <div>
                        <div class="stat-value">${not empty contConfirmadosHoje ? contConfirmadosHoje : 0}</div>
                        <div class="stat-label">Confirmados Hoje</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon danger"><i class="bi bi-x-circle"></i></div>
                    <div>
                        <div class="stat-value">${not empty contRejeitadosHoje ? contRejeitadosHoje : 0}</div>
                        <div class="stat-label">Rejeitados Hoje</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon primary"><i class="bi bi-calendar-day"></i></div>
                    <div>
                        <div class="stat-value">${not empty contTotalHoje ? contTotalHoje : 0}</div>
                        <div class="stat-label">Total Hoje</div>
                    </div>
                </div>
            </div>

            <c:if test="${contPendentes > 0}">
                <div class="alert alert-warning">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <div>Há ${contPendentes} pedido(s) pendente(s) aguardando decisão.</div>
                </div>
            </c:if>

            <div class="dashboard-grid">
                <div class="card">
                    <div class="card-header">
                        <h3><i class="bi bi-calendar-day" style="margin-right:.4rem"></i>Agenda de Hoje</h3>
                        <span class="tag">${not empty contTotalHoje ? contTotalHoje : 0} atendimento(s)</span>
                    </div>

                    <c:choose>
                        <c:when test="${not empty proximoAtendimento}">
                            <div class="next-appointment">
                                <div class="date-block">
                                    <strong><fmt:formatDate value="${proximoAtendimento.dataAgendada}" pattern="HH"/></strong>
                                    <span><fmt:formatDate value="${proximoAtendimento.dataAgendada}" pattern="mm"/></span>
                                </div>
                                <div>
                                    <h4>${proximoAtendimento.nomeEstudante}</h4>
                                    <p>
                                        <i class="bi bi-hash"></i> ${proximoAtendimento.numeroEstudante}
                                        · ${proximoAtendimento.descricao}
                                    </p>
                                    <c:choose>
                                        <c:when test="${proximoAtendimento.estado == 'CONFIRMADO'}">
                                            <span class="badge badge-success"><i class="bi bi-check-lg"></i> Confirmado</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-warning"><i class="bi bi-hourglass-split"></i> Pendente</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state compact">
                                <i class="bi bi-calendar-check"></i>
                                <h3>Sem próximos atendimentos</h3>
                                <p>Não há atendimentos pendentes ou confirmados para o resto do dia.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3><i class="bi bi-lightning" style="margin-right:.4rem"></i>Ações Rápidas</h3>
                    </div>
                    <div class="quick-actions">
                        <a href="${pageContext.request.contextPath}/funcionario/pendentes" class="btn btn-primary btn-full">
                            <i class="bi bi-hourglass-split"></i> Ver Pendentes
                        </a>
                        <a href="${pageContext.request.contextPath}/funcionario/agenda" class="btn btn-outline-primary btn-full">
                            <i class="bi bi-calendar2-week"></i> Ver Agenda
                        </a>
                        <a href="${pageContext.request.contextPath}/funcionario/estudantes" class="btn btn-outline-primary btn-full">
                            <i class="bi bi-people"></i> Consultar Estudantes
                        </a>
                        <a href="${pageContext.request.contextPath}/funcionario/lancar-nota" class="btn btn-outline-primary btn-full">
                            <i class="bi bi-pencil-square"></i> Lançar Nota
                        </a>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3><i class="bi bi-hourglass-split" style="margin-right:.4rem"></i>Pendentes de Aprovação</h3>
                    <a href="${pageContext.request.contextPath}/funcionario/pendentes" class="btn btn-outline btn-sm">
                        Ver todos <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
                <div class="table-wrap">
                    <table class="uni-table">
                        <thead>
                            <tr>
                                <th>Data</th>
                                <th>Hora</th>
                                <th>Estudante</th>
                                <th>Nº Estudante</th>
                                <th>Descrição</th>
                                <th style="text-align:center">Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty pendentesResumo}">
                                    <tr><td colspan="6">
                                            <div class="empty-state compact">
                                                <i class="bi bi-check2-circle"></i>
                                                <h3>Sem pedidos pendentes</h3>
                                                <p>Não há pedidos a aguardar decisão.</p>
                                            </div>
                                        </td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="a" items="${pendentesResumo}">
                                            <tr>
                                                <td><fmt:formatDate value="${a.dataAgendada}" pattern="dd/MM/yyyy"/></td>
                                                <td class="muted"><fmt:formatDate value="${a.dataAgendada}" pattern="HH:mm"/></td>
                                                <td><strong>${a.nomeEstudante}</strong></td>
                                                <td class="muted">${a.numeroEstudante}</td>
                                                <td style="max-width:260px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis" title="${a.descricao}">${a.descricao}</td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <form action="${pageContext.request.contextPath}/funcionario/atendimento/acao" method="post">
                                                            <input type="hidden" name="idAtendimento" value="${a.idAtendimento}">
                                                            <input type="hidden" name="accao" value="APROVAR">
                                                            <input type="hidden" name="origem" value="dashboard">
                                                            <button type="submit" class="btn btn-success btn-sm" data-confirm="Confirmar aprovação do atendimento de ${a.nomeEstudante}?">
                                                                <i class="bi bi-check-lg"></i> Aprovar
                                                            </button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/funcionario/atendimento/acao" method="post">
                                                            <input type="hidden" name="idAtendimento" value="${a.idAtendimento}">
                                                            <input type="hidden" name="accao" value="REJEITAR">
                                                            <input type="hidden" name="origem" value="dashboard">
                                                            <button type="submit" class="btn btn-danger btn-sm" data-confirm="Rejeitar o pedido de ${a.nomeEstudante}?">
                                                                <i class="bi bi-x-lg"></i> Rejeitar
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

            <div class="card" style="margin-top:1rem">
                <div class="card-header">
                    <h3><i class="bi bi-list-ul" style="margin-right:.4rem"></i>Tabela Geral de Hoje</h3>
                    <span class="tag">${not empty contTotalHoje ? contTotalHoje : 0} registo(s)</span>
                </div>
                <div class="table-wrap">
                    <table class="uni-table">
                        <thead>
                            <tr>
                                <th>Data</th>
                                <th>Hora</th>
                                <th>Estudante</th>
                                <th>Nº Estudante</th>
                                <th>Descrição</th>
                                <th style="text-align:center">Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty agendaHoje}">
                                    <tr><td colspan="6">
                                            <div class="empty-state compact">
                                                <i class="bi bi-calendar-check"></i>
                                                <h3>Sem atendimentos hoje</h3>
                                                <p>Não há atendimentos agendados para hoje.</p>
                                            </div>
                                        </td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="a" items="${agendaHoje}">
                                            <tr>
                                                <td><fmt:formatDate value="${a.dataAgendada}" pattern="dd/MM/yyyy"/></td>
                                                <td class="muted"><fmt:formatDate value="${a.dataAgendada}" pattern="HH:mm"/></td>
                                                <td><strong>${a.nomeEstudante}</strong></td>
                                                <td class="muted">${a.numeroEstudante}</td>
                                                <td style="max-width:260px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis" title="${a.descricao}">${a.descricao}</td>
                                                <td style="text-align:center">
                                                    <c:choose>
                                                        <c:when test="${a.estado == 'CONFIRMADO'}">
                                                            <span class="badge badge-success"><i class="bi bi-check-lg"></i> Confirmado</span>
                                                        </c:when>
                                                        <c:when test="${a.estado == 'PENDENTE'}">
                                                            <span class="badge badge-warning"><i class="bi bi-hourglass-split"></i> Pendente</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-danger"><i class="bi bi-x-lg"></i> Rejeitado</span>
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

                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
    </body>
</html>
