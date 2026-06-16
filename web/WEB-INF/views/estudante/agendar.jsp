<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Agendar Atendimento — UNIHELP | OJJ</title>
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
                    <a href="${pageContext.request.contextPath}/estudante/agendar"      class="topnav-link active"><i class="bi bi-calendar-plus"></i> Agendar</a>
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

        <!-- CONTEÚDO -->
        <div class="topnav-content">

            <div class="section-header mb-3">
                <div>
                    <h2 style="font-size:1.2rem;font-weight:800">Agendar Atendimento</h2>
                    <p class="muted text-sm">Preencha os dados para solicitar um atendimento.</p>
                </div>
                <a href="${pageContext.request.contextPath}/estudante/atendimentos" class="btn btn-outline btn-sm">
                    <i class="bi bi-arrow-left"></i> Os meus atendimentos
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

            <div>
                <div class="card">
                    <div class="card-header">
                        <h3><i class="bi bi-calendar-plus" style="margin-right:.4rem"></i>Novo Pedido de Atendimento</h3>
                    </div>
                    <div class="card-body">

                        <form action="${pageContext.request.contextPath}/estudante/agendar"
                              method="post"
                              data-loading>

                            <!-- Data e Hora -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="data">
                                        Data <span class="req">*</span>
                                    </label>
                                    <input type="date"
                                           id="data"
                                           name="data"
                                           class="form-control"
                                           min="${dataMin}"
                                           value="${param.data}"
                                           required>
                                    <span class="form-hint">Selecione uma data disponível.</span>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="hora">
                                        Hora <span class="req">*</span>
                                    </label>
                                    <input type="time"
                                           id="hora"
                                           name="hora"
                                           class="form-control"
                                           min="07:00"
                                           max="18:00"
                                           value="${param.hora}"
                                           required>
                                    <span class="form-hint">Entre as 07h00 e as 18h00.</span>
                                </div>
                            </div>

                            <!-- Descrição -->
                            <div class="form-group">
                                <label class="form-label" for="descricao">
                                    Motivo / Descrição <span class="req">*</span>
                                </label>
                                <textarea id="descricao"
                                          name="descricao"
                                          class="form-control"
                                          rows="4"
                                          maxlength="500"
                                          placeholder="Descreva brevemente o motivo do atendimento…"
                                          required>${not empty param.descricao ? param.descricao : ''}</textarea>
                                <span class="form-hint">Máximo de 500 caracteres.</span>
                            </div>

                            <!-- Info sobre aprovação -->
                            <div class="alert alert-info" style="margin-bottom:1.25rem">
                                <i class="bi bi-info-circle-fill"></i>
                                <div>O pedido ficará <strong>pendente</strong> até ser aprovado ou rejeitado por um funcionário.</div>
                            </div>

                            <!-- Botões -->
                            <div style="display:flex;gap:.75rem;justify-content:flex-end">
                                <a href="${pageContext.request.contextPath}/estudante/atendimentos"
                                   class="btn btn-outline">
                                    Cancelar
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-send"></i> Enviar Pedido
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>

        </div><!-- /topnav-content -->

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
    </body>
</html>
