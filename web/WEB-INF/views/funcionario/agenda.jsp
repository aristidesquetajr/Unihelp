<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c"   uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Agenda do Dia — UNIHELP</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
    </head>
    <body>

        <div class="sidebar-overlay" onclick="toggleSidebar()"></div>

        <div class="wrapper">

            <!-- SIDEBAR -->
            <aside class="sidebar" id="sidebar">

                <div class="sidebar-brand">
                    <div class="brand-logo">UH</div>
                    <div class="brand-text">
                        <strong>UNIHELP</strong>
                    </div>
                </div>

                <nav class="sidebar-nav">
                    <span class="nav-section-label">Menu Principal</span>
                    <a href="${pageContext.request.contextPath}/funcionario/dashboard"  class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/funcionario/pendentes"  class="sidebar-link"><i class="bi bi-hourglass-split"></i> Atendimentos Pendentes</a>
                    <a href="${pageContext.request.contextPath}/funcionario/agenda"     class="sidebar-link active"><i class="bi bi-calendar2-week"></i> Agenda do Dia</a>

                    <span class="nav-section-label">Estudantes</span>
                    <a href="${pageContext.request.contextPath}/funcionario/estudantes"         class="sidebar-link"><i class="bi bi-people"></i> Lista de Estudantes</a>
                    <a href="${pageContext.request.contextPath}/funcionario/registar-estudante" class="sidebar-link"><i class="bi bi-person-plus"></i> Registar Estudante</a>
                    <a href="${pageContext.request.contextPath}/funcionario/lancar-nota"        class="sidebar-link"><i class="bi bi-pencil-square"></i> Lançar Nota</a>
                </nav>

            </aside>


            <!-- CONTEÚDO -->
            <div class="main-content">
                <header class="topbar">
                    <div class="topbar-left">
                        <button class="btn-sidebar-toggle" onclick="toggleSidebar()"><i class="bi bi-list"></i></button>
                        <div>
                            <div class="page-title">Agenda do Dia</div>
                            <div class="page-subtitle">Atendimentos confirmados</div>
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

                    <!-- Navegação de datas -->
                    <div class="card" style="margin-bottom:1rem">
                        <div class="card-body" style="padding:.85rem 1.25rem">
                            <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:.75rem">

                                <!-- Dia anterior -->
                                <a href="${pageContext.request.contextPath}/funcionario/agenda?data=${dataAnterior}"
                                   class="btn btn-outline btn-sm">
                                    <i class="bi bi-chevron-left"></i> Dia Anterior
                                </a>

                                <!-- Data seleccionada / picker -->
                                <form action="${pageContext.request.contextPath}/funcionario/agenda"
                                      method="get"
                                      style="display:flex;align-items:center;gap:.6rem">
                                    <i class="bi bi-calendar3" style="color:var(--primary);font-size:1.1rem"></i>
                                    <input type="date"
                                           name="data"
                                           class="form-control"
                                           style="max-width:180px"
                                           value="${not empty dataSelecionada ? dataSelecionada : ''}"
                                           onchange="this.form.submit()">
                                    <span style="font-size:.8rem;color:var(--text-muted)">
                                        <c:if test="${not empty labelData}">${labelData}</c:if>
                                        </span>
                                    </form>

                                    <!-- Próximo dia -->
                                    <a href="${pageContext.request.contextPath}/funcionario/agenda?data=${dataProxima}"
                                   class="btn btn-outline btn-sm">
                                    Próximo Dia <i class="bi bi-chevron-right"></i>
                                </a>

                            </div>
                        </div>
                    </div>

                    <!-- Tabela de agenda -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="bi bi-calendar2-check" style="margin-right:.4rem"></i>Atendimentos do Dia</h3>
                            <span class="tag">${not empty totalDia ? totalDia : 0} marcação(ões)</span>
                        </div>
                        <div class="table-wrap">
                            <table class="uni-table">
                                <thead>
                                    <tr>
                                        <th>Hora</th>
                                        <th>Estudante</th>
                                        <th>Nº Estudante</th>
                                        <th>Descrição</th>
                                        <th style="text-align:center">Estado</th>
                                        <th style="text-align:center">Acções</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty atendimentos}">
                                            <tr><td colspan="6">
                                                    <div class="empty-state">
                                                        <i class="bi bi-calendar-check"></i>
                                                        <h3>Dia livre</h3>
                                                        <p>Não há atendimentos confirmados para esta data.</p>
                                                    </div>
                                                </td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="a" items="${atendimentos}">
                                                <tr>
                                                    <td>
                                                        <strong style="font-size:1rem">
                                                            <fmt:formatDate value="${a.dataAgendada}" pattern="HH:mm"/>
                                                        </strong>
                                                    </td>
                                                    <td><strong>${a.nomeEstudante}</strong></td>
                                                    <td class="muted">${not empty a.numeroEstudante ? a.numeroEstudante : '—'}</td>
                                                    <td style="max-width:250px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis"
                                                        title="${a.descricao}">${a.descricao}</td>
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
                                                    <td style="text-align:center">
                                                        <a href="${pageContext.request.contextPath}/funcionario/aprovacao?id=${a.idAtendimento}"
                                                           class="btn btn-outline btn-sm">
                                                            <i class="bi bi-eye"></i> Detalhes
                                                        </a>
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
            </div><!-- /main-content -->
        </div><!-- /wrapper -->

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
    </body>
</html>
