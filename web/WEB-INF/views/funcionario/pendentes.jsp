<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c"   uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Atendimentos Pendentes — UNIHELP</title>
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
                    <a href="${pageContext.request.contextPath}/funcionario/pendentes"  class="sidebar-link active"><i class="bi bi-hourglass-split"></i> Atendimentos Pendentes</a>
                    <a href="${pageContext.request.contextPath}/funcionario/agenda"     class="sidebar-link"><i class="bi bi-calendar2-week"></i> Agenda do Dia</a>

                    <span class="nav-section-label">Estudantes</span>
                    <a href="${pageContext.request.contextPath}/funcionario/estudantes"         class="sidebar-link"><i class="bi bi-people"></i> Lista de Estudantes</a>
                    <a href="${pageContext.request.contextPath}/funcionario/registar-estudante" class="sidebar-link"><i class="bi bi-person-plus"></i> Registar Estudante</a>
                    <a href="${pageContext.request.contextPath}/funcionario/lancar-nota"        class="sidebar-link"><i class="bi bi-pencil-square"></i> Lançar Nota</a>
                </nav>

            </aside>

            <!-- CONTEÚDO PRINCIPAL -->
            <div class="main-content">

                <header class="topbar">
                    <div class="topbar-left">
                        <button class="btn-sidebar-toggle" onclick="toggleSidebar()">
                            <i class="bi bi-list"></i>
                        </button>
                        <div>
                            <div class="page-title">Atendimentos Pendentes</div>
                            <div class="page-subtitle">Pedidos a aguardar aprovação</div>
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

                    <!-- Aviso de pendentes -->
                    <c:if test="${not empty contPendentes and contPendentes > 0}">
                        <div class="alert alert-warning" style="margin-bottom:1rem">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                            <div>Existem <strong>${contPendentes}</strong> pedido(s) a aguardar a sua resposta.</div>
                        </div>
                    </c:if>

                    <!-- Tabela de pendentes -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="bi bi-hourglass-split" style="margin-right:.4rem"></i>Pedidos Pendentes</h3>
                            <span class="tag">${not empty contPendentes ? contPendentes : 0} registo(s)</span>
                        </div>
                        <div class="table-wrap">
                            <table class="uni-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Estudante</th>
                                        <th>Data Pedida</th>
                                        <th>Hora</th>
                                        <th>Descrição / Motivo</th>
                                        <th style="text-align:center">Acções</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty atendimentos}">
                                            <tr><td colspan="6">
                                                    <div class="empty-state">
                                                        <i class="bi bi-check2-circle"></i>
                                                        <h3>Sem pedidos pendentes</h3>
                                                        <p>Não existem atendimentos à espera de aprovação.</p>
                                                    </div>
                                                </td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="a" items="${atendimentos}" varStatus="s">
                                                <tr>
                                                    <td class="muted">${s.count}</td>
                                                    <td>
                                                        <strong>${a.nomeEstudante}</strong><br>
                                                        <span class="muted" style="font-size:.78rem">${a.numeroEstudante}</span>
                                                    </td>
                                                    <td><fmt:formatDate value="${a.dataAgendada}" pattern="dd/MM/yyyy"/></td>
                                                    <td class="muted"><fmt:formatDate value="${a.dataAgendada}" pattern="HH:mm"/></td>
                                                    <td style="max-width:240px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis"
                                                        title="${a.descricao}">${a.descricao}</td>
                                                    <td>
                                                        <div class="action-buttons">

                                                            <%-- Aprovação rápida directa --%>
                                                            <form action="${pageContext.request.contextPath}/funcionario/atendimento/acao"
                                                                  method="post" style="display:inline">
                                                                <input type="hidden" name="idAtendimento"      value="${a.idAtendimento}">
                                                                <input type="hidden" name="accao" value="APROVAR">
                                                                <input type="hidden" name="origem"  value="pendentes">
                                                                <button type="submit"
                                                                        class="btn btn-success btn-sm"
                                                                        data-confirm="Confirmar aprovação do atendimento de ${a.nomeEstudante}?"
                                                                        title="Aprovar">
                                                                    <i class="bi bi-check-lg"></i>
                                                                </button>
                                                            </form>

                                                            <a href="${pageContext.request.contextPath}/funcionario/aprovacao?id=${a.idAtendimento}"
                                                               class="btn btn-danger btn-sm"
                                                               title="Rejeitar">
                                                                <i class="bi bi-x-lg"></i>
                                                            </a>

                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <div class="card-footer" style="font-size:.78rem;color:var(--text-muted)">
                            <i class="bi bi-info-circle"></i>
                            O botão <strong>✓</strong> aprova rapidamente. O botão <strong>✕</strong> abre a análise para informar o motivo da rejeição.
                        </div>
                    </div>

                </main>
            </div><!-- /main-content -->
        </div><!-- /wrapper -->

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
    </body>
</html>
