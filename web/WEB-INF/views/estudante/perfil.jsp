<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Meu Perfil — UNIHELP | OJJ</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
    </head>
    <body>

        <!-- ═══════════════════════════════════
             NAVEGAÇÃO DO ESTUDANTE
             ═══════════════════════════════════ -->
        <nav class="topnav">
            <div class="topnav-inner">

                <a href="${pageContext.request.contextPath}/estudante/dashboard" class="topnav-brand">
                    <div class="brand-logo">UH</div>
                    UNIHELP
                </a>

                <div class="topnav-links">
                    <a href="${pageContext.request.contextPath}/estudante/dashboard"    class="topnav-link"><i class="bi bi-grid-1x2"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/estudante/perfil"       class="topnav-link active"><i class="bi bi-person"></i> Perfil</a>
                    <a href="${pageContext.request.contextPath}/estudante/agendar"      class="topnav-link"><i class="bi bi-calendar-plus"></i> Agendar</a>
                    <a href="${pageContext.request.contextPath}/estudante/atendimentos" class="topnav-link"><i class="bi bi-calendar2-check"></i> Atendimentos</a>
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

        <!-- ═══════════════════════════════════
             CONTEÚDO
             ═══════════════════════════════════ -->
        <div class="topnav-content">

            <div class="section-header mb-3">
                <div>
                    <h2 style="font-size:1.2rem;font-weight:800">Meu Perfil</h2>
                    <p class="muted text-sm">Dados da sua conta académica.</p>
                </div>
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

            <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.25rem">

                <!-- ── Coluna esquerda: dados pessoais ── -->
                <div>
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="bi bi-person-vcard" style="margin-right:.4rem"></i>Dados Pessoais</h3>
                        </div>
                        <div class="card-body">

                            <!-- Avatar + nome -->
                            <div class="profile-head">
                                <div class="avatar-lg">
                                    ${sessionScope.utilizadorLogado.nome.substring(0,1).toUpperCase()}
                                </div>
                                <div>
                                    <div style="font-size:1.1rem;font-weight:800">${estudante.nome}</div>
                                    <div class="muted text-sm">Estudante</div>
                                    <div style="margin-top:.4rem">
                                        <c:choose>
                                            <c:when test="${sessionScope.utilizadorLogado.status == 'ACTIVO'}">
                                                <span class="badge badge-success"><i class="bi bi-circle-fill" style="font-size:.45rem"></i> Activo</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger"><i class="bi bi-circle-fill" style="font-size:.45rem"></i> Bloqueado</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="divider"></div>

                            <!-- Lista de dados -->
                            <ul class="info-list">
                                <li>
                                    <span class="lbl"><i class="bi bi-hash"></i> Nº Estudante</span>
                                    <span class="val fw-7">${not empty estudante.numeroEstudante ? estudante.numeroEstudante : '—'}</span>
                                </li>
                                <li>
                                    <span class="lbl"><i class="bi bi-person"></i> Nome Completo</span>
                                    <span class="val">${not empty estudante.nome ? estudante.nome : '—'}</span>
                                </li>
                                <li>
                                    <span class="lbl"><i class="bi bi-envelope"></i> Email</span>
                                    <span class="val">${not empty estudante.email ? estudante.email : '—'}</span>
                                </li>
                                <li>
                                    <span class="lbl"><i class="bi bi-telephone"></i> Telefone</span>
                                    <span class="val">
                                        <c:choose>
                                            <c:when test="${not empty estudante.telefones}">
                                                <c:forEach var="telefone" items="${estudante.telefones}" varStatus="s">
                                                    ${telefone}<c:if test="${not s.last}">, </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- ── Coluna direita: dados académicos ── -->
                <div style="display:flex;flex-direction:column;gap:1.25rem">

                    <div class="card">
                        <div class="card-header">
                            <h3><i class="bi bi-mortarboard" style="margin-right:.4rem"></i>Dados Académicos</h3>
                        </div>
                        <div class="card-body">
                            <ul class="info-list">
                                <li>
                                    <span class="lbl"><i class="bi bi-book"></i> Curso</span>
                                    <span class="val">${not empty estudante.nomeCurso ? estudante.nomeCurso : '—'}</span>
                                </li>
                                <li>
                                    <span class="lbl"><i class="bi bi-calendar3"></i> Período Actual</span>
                                    <span class="val">${not empty estudante.anoLetivo ? estudante.anoLetivo : '—'}</span>
                                </li>
                                <li>
                                    <span class="lbl"><i class="bi bi-collection"></i> Turma</span>
                                    <span class="val">${not empty estudante.nomeTurma ? estudante.nomeTurma : '—'}</span>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <!-- Acções rápidas -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="bi bi-lightning" style="margin-right:.4rem"></i>Acções Rápidas</h3>
                        </div>
                        <div class="card-body" style="display:flex;flex-direction:column;gap:.6rem">
                            <a href="${pageContext.request.contextPath}/estudante/agendar"      class="btn btn-outline-primary btn-full"><i class="bi bi-calendar-plus"></i> Agendar Atendimento</a>
                            <a href="${pageContext.request.contextPath}/estudante/boletim"      class="btn btn-outline-primary btn-full"><i class="bi bi-journal-text"></i> Ver Boletim de Notas</a>
                            <a href="${pageContext.request.contextPath}/estudante/inscricoes"   class="btn btn-outline-primary btn-full"><i class="bi bi-book"></i> Histórico de Inscrições</a>
                        </div>
                    </div>

                </div><!-- /coluna direita -->
            </div><!-- /grid -->

        </div><!-- /topnav-content -->

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
    </body>
</html>
