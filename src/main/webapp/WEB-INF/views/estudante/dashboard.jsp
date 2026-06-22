<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Dashboard do estudante no UNIHELP. Consulte sua situação académica, atendimentos, notas e inscrições numa plataforma moderna de gestão escolar.">
        <meta name="keywords" content="dashboard estudante, situação académica, notas, atendimentos, UNIHELP, gestão escolar">
        <meta property="og:title" content="Dashboard Estudante — UNIHELP">
        <meta property="og:description" content="Painel académico do estudante com acesso a notas, atendimentos e inscrições.">
        <meta property="og:type" content="website">
        <title>Dashboard — UNIHELP | OJJ</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
    </head>
    <body>

        <!-- ═══════════════════════════════════
             NAVEGAÇÃO DO ESTUDANTE
             ═══════════════════════════════════ -->
        <nav class="topnav">
            <div class="topnav-inner">

                <a href="${pageContext.request.contextPath}" class="topnav-brand">
                    <div class="brand-logo">UH</div>
                    UNIHELP
                </a>

                <div class="topnav-links">
                    <a href="${pageContext.request.contextPath}/estudante/dashboard"   class="topnav-link active"><i class="bi bi-grid-1x2"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/estudante/perfil"      class="topnav-link"><i class="bi bi-person"></i> Perfil</a>
                    <a href="${pageContext.request.contextPath}/estudante/agendar"     class="topnav-link"><i class="bi bi-calendar-plus"></i> Agendar</a>
                    <a href="${pageContext.request.contextPath}/estudante/atendimentos" class="topnav-link"><i class="bi bi-calendar2-check"></i> Atendimentos</a>
                    <a href="${pageContext.request.contextPath}/estudante/boletim"     class="topnav-link"><i class="bi bi-journal-text"></i> Boletim</a>
                    <a href="${pageContext.request.contextPath}/estudante/inscricoes"  class="topnav-link"><i class="bi bi-book"></i> Inscrições</a>
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

        <!-- ═══════════════════════════════════
             CONTEÚDO
             ═══════════════════════════════════ -->
        <div class="topnav-content">

            <!-- Cabeçalho da página -->
            <div class="section-header mb-3">
                <div>
                    <h2 style="font-size:1.2rem;font-weight:800">Olá, ${sessionScope.utilizadorLogado.nome}!</h2>
                    <p class="muted text-sm">Bem-vindo ao seu painel académico.</p>
                </div>
                <a href="${pageContext.request.contextPath}/estudante/agendar" class="btn btn-primary">
                    <i class="bi bi-calendar-plus"></i> Novo Atendimento
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

            <c:choose>
                <c:when test="${not empty inscricaoActiva}">
                    <div class="card current-enrollment">
                        <div class="card-header">
                            <h3><i class="bi bi-mortarboard" style="margin-right:.4rem"></i>Situação Académica</h3>
                            <span class="badge badge-success"><i class="bi bi-circle-fill" style="font-size:.45rem"></i> Inscrição Activa</span>
                        </div>
                        <div class="enrollment-overview">
                            <div>
                                <span class="lbl">Curso actual</span>
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
                    <div class="alert alert-warning">
                        <i class="bi bi-exclamation-triangle"></i>
                        <div>Não existe uma inscrição activa registada para este estudante.</div>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Cartões de estatísticas -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon warning"><i class="bi bi-hourglass-split"></i></div>
                    <div>
                        <div class="stat-value">${not empty contPendentes   ? contPendentes   : 0}</div>
                        <div class="stat-label">Atendimentos Pendentes</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon success"><i class="bi bi-calendar2-check"></i></div>
                    <div>
                        <div class="stat-value">${not empty contConfirmados ? contConfirmados : 0}</div>
                        <div class="stat-label">Atendimentos Confirmados</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon primary"><i class="bi bi-graph-up-arrow"></i></div>
                    <div>
                        <div class="stat-value"><fmt:formatNumber value="${mediaGeral}" minFractionDigits="1" maxFractionDigits="1"/></div>
                        <div class="stat-label">Média Geral</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon danger"><i class="bi bi-exclamation-triangle"></i></div>
                    <div>
                        <div class="stat-value">${not empty disciplinasEmRisco ? disciplinasEmRisco : 0}</div>
                        <div class="stat-label">Disciplinas em Risco</div>
                    </div>
                </div>
            </div>

            <c:if test="${contPendentes > 0}">
                <div class="alert alert-warning">
                    <i class="bi bi-hourglass-split"></i>
                    <div>Tem ${contPendentes} atendimento(s) pendente(s) a aguardar confirmação.</div>
                </div>
            </c:if>
            <c:if test="${disciplinasEmRisco > 0}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <div>Existem ${disciplinasEmRisco} disciplina(s) com média abaixo de 10.</div>
                </div>
            </c:if>

            <div class="dashboard-grid">
                <div class="card">
                    <div class="card-header">
                        <h3><i class="bi bi-calendar-event" style="margin-right:.4rem"></i>Próximo Atendimento</h3>
                        <a href="${pageContext.request.contextPath}/estudante/agendar" class="btn btn-outline btn-sm">
                            Novo <i class="bi bi-plus-lg"></i>
                        </a>
                    </div>
                    <c:choose>
                        <c:when test="${not empty proximoAtendimento}">
                            <div class="next-appointment">
                                <div class="date-block">
                                    <strong><fmt:formatDate value="${proximoAtendimento.dataAgendada}" pattern="dd"/></strong>
                                    <span><fmt:formatDate value="${proximoAtendimento.dataAgendada}" pattern="MMM"/></span>
                                </div>
                                <div>
                                    <h4>${proximoAtendimento.descricao}</h4>
                                    <p>
                                        <i class="bi bi-clock"></i>
                                        <fmt:formatDate value="${proximoAtendimento.dataAgendada}" pattern="HH:mm"/>
                                        · ${not empty proximoAtendimento.nomeFuncionario ? proximoAtendimento.nomeFuncionario : 'Funcionário por confirmar'}
                                    </p>
                                    <c:choose>
                                        <c:when test="${proximoAtendimento.estado == 'PENDENTE'}">
                                            <span class="badge badge-warning"><i class="bi bi-hourglass-split"></i> Pendente</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-success"><i class="bi bi-check-lg"></i> Confirmado</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state compact">
                                <i class="bi bi-calendar-x"></i>
                                <h3>Sem atendimento futuro</h3>
                                <p>Não existe atendimento pendente ou confirmado nos próximos dias.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3><i class="bi bi-lightning" style="margin-right:.4rem"></i>Ações Rápidas</h3>
                    </div>
                    <div class="quick-actions">
                        <a href="${pageContext.request.contextPath}/estudante/agendar" class="btn btn-primary btn-full">
                            <i class="bi bi-calendar-plus"></i> Agendar Atendimento
                        </a>
                        <a href="${pageContext.request.contextPath}/estudante/boletim" class="btn btn-outline-primary btn-full">
                            <i class="bi bi-journal-text"></i> Ver Boletim
                        </a>
                        <a href="${pageContext.request.contextPath}/estudante/inscricoes" class="btn btn-outline-primary btn-full">
                            <i class="bi bi-book"></i> Ver Inscrições
                        </a>
                        <a href="${pageContext.request.contextPath}/estudante/atendimentos" class="btn btn-outline-primary btn-full">
                            <i class="bi bi-calendar2-check"></i> Ver Atendimentos
                        </a>
                    </div>
                </div>
            </div>

            <div class="card performance-card">
                <div class="card-header">
                    <h3><i class="bi bi-bar-chart" style="margin-right:.4rem"></i>Desempenho Académico</h3>
                    <a href="${pageContext.request.contextPath}/estudante/boletim" class="btn btn-outline btn-sm">
                        Ver boletim <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
                <div class="performance-grid">
                    <div>
                        <span class="lbl">Média geral</span>
                        <strong><fmt:formatNumber value="${mediaGeral}" minFractionDigits="1" maxFractionDigits="1"/></strong>
                    </div>
                    <div>
                        <span class="lbl">Disciplinas avaliadas</span>
                        <strong>${not empty totalDisciplinas ? totalDisciplinas : 0}</strong>
                    </div>
                    <div>
                        <span class="lbl">Disciplinas em risco</span>
                        <strong class="${disciplinasEmRisco > 0 ? 'text-danger' : ''}">${not empty disciplinasEmRisco ? disciplinasEmRisco : 0}</strong>
                    </div>
                </div>
            </div>

            <!-- Tabela de atendimentos recentes -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="bi bi-clock-history" style="margin-right:.4rem"></i>Últimos 5 Atendimentos</h3>
                    <a href="${pageContext.request.contextPath}/estudante/atendimentos" class="btn btn-outline btn-sm">
                        Ver todos <i class="bi bi-arrow-right"></i>
                    </a>
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
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty atendimentos}">
                                    <tr><td colspan="6">
                                            <div class="empty-state">
                                                <i class="bi bi-calendar-x"></i>
                                                <h3>Sem atendimentos</h3>
                                                <p>Ainda não agendou nenhum atendimento. <a href="${pageContext.request.contextPath}/estudante/agendar">Agendar agora</a></p>
                                            </div>
                                        </td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="a" items="${atendimentos}" varStatus="s">
                                        <tr>
                                            <td class="muted">${s.count}</td>
                                            <td><fmt:formatDate value="${a.dataAgendada}" pattern="dd/MM/yyyy"/></td>
                                            <td class="muted"><fmt:formatDate value="${a.dataAgendada}" pattern="HH:mm"/></td>
                                            <td>${a.descricao}</td>
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
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div><!-- /card -->

        </div><!-- /topnav-content -->

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
    </body>
</html>
