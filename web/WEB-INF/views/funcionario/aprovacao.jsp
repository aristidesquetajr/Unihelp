<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c"   uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="pt-AO">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Analisar Atendimento — UNIHELP</title>
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
      <div class="brand-text"><strong>UNIHELP</strong></div>
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

  <!-- CONTEÚDO -->
  <div class="main-content">
    <header class="topbar">
      <div class="topbar-left">
        <button class="btn-sidebar-toggle" onclick="toggleSidebar()"><i class="bi bi-list"></i></button>
        <div>
          <div class="page-title">Analisar Atendimento</div>
          <div class="page-subtitle">Aprovar ou rejeitar pedido</div>
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
      <div class="section-header">
        <div>
          <h2 style="font-size:1.1rem;font-weight:800">Detalhe do Atendimento</h2>
          <p class="muted text-sm">Revise o pedido antes de aprovar ou rejeitar.</p>
        </div>
        <a href="${pageContext.request.contextPath}/funcionario/pendentes"
           class="btn btn-outline btn-sm">
          <i class="bi bi-arrow-left"></i> Voltar
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

        <%-- Atendimento não encontrado --%>
        <c:when test="${empty atendimento}">
          <div class="card">
            <div class="card-body">
              <div class="empty-state">
                <i class="bi bi-exclamation-circle"></i>
                <h3>Atendimento não encontrado</h3>
                <p>O pedido solicitado não existe ou já foi processado.</p>
                <a href="${pageContext.request.contextPath}/funcionario/pendentes"
                   class="btn btn-primary" style="margin-top:1rem">
                  <i class="bi bi-arrow-left"></i> Voltar
                </a>
              </div>
            </div>
          </div>
        </c:when>

        <%-- Detalhe do atendimento --%>
        <c:otherwise>
          <div class="approval-grid">

            <!-- Coluna esquerda: detalhes -->
            <div style="display:flex;flex-direction:column;gap:1.25rem">

              <!-- Dados do estudante -->
              <div class="card">
                <div class="card-header">
                  <h3><i class="bi bi-person-circle" style="margin-right:.4rem"></i>Estudante</h3>
                </div>
                <div class="card-body">
                  <div class="profile-head" style="margin-bottom:1rem">
                    <div class="avatar-lg" style="width:54px;height:54px;font-size:1.3rem">
                      ${atendimento.nomeEstudante.substring(0,1).toUpperCase()}
                    </div>
                    <div>
                      <div style="font-weight:800;font-size:1rem">${atendimento.nomeEstudante}</div>
                      <div class="muted text-sm">${not empty atendimento.numeroEstudante ? atendimento.numeroEstudante : ''}</div>
                    </div>
                  </div>
                  <ul class="info-list">
                    <li>
                      <span class="lbl"><i class="bi bi-hash"></i> Nº Estudante</span>
                      <span class="val">${not empty atendimento.numeroEstudante ? atendimento.numeroEstudante : '—'}</span>
                    </li>
                  </ul>
                </div>
              </div>

              <!-- Dados do atendimento -->
              <div class="card">
                <div class="card-header">
                  <h3><i class="bi bi-calendar-event" style="margin-right:.4rem"></i>Detalhes do Pedido</h3>
                  <c:choose>
                    <c:when test="${atendimento.estado == 'PENDENTE'}">
                      <span class="badge badge-warning"><i class="bi bi-hourglass-split"></i> Pendente</span>
                    </c:when>
                    <c:when test="${atendimento.estado == 'CONFIRMADO'}">
                      <span class="badge badge-success"><i class="bi bi-check-lg"></i> Confirmado</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-danger"><i class="bi bi-x-lg"></i> Rejeitado</span>
                    </c:otherwise>
                  </c:choose>
                </div>
                <div class="card-body">
                  <ul class="info-list">
                    <li>
                      <span class="lbl"><i class="bi bi-calendar"></i> Data</span>
                      <span class="val fw-7"><fmt:formatDate value="${atendimento.dataAgendada}" pattern="dd/MM/yyyy"/></span>
                    </li>
                    <li>
                      <span class="lbl"><i class="bi bi-clock"></i> Hora</span>
                      <span class="val fw-7"><fmt:formatDate value="${atendimento.dataAgendada}" pattern="HH:mm"/></span>
                    </li>
                    <li>
                      <span class="lbl"><i class="bi bi-chat-text"></i> Motivo</span>
                      <span class="val">${atendimento.descricao}</span>
                    </li>
                    <c:if test="${not empty atendimento.motivoRejeicao}">
                      <li>
                        <span class="lbl"><i class="bi bi-sticky"></i> Motivo da rejeição</span>
                        <span class="val">${atendimento.motivoRejeicao}</span>
                      </li>
                    </c:if>
                  </ul>
                </div>
              </div>

            </div><!-- /coluna esquerda -->

            <!-- Coluna direita: formulário de decisão -->
            <div>
              <div class="card">
                <div class="card-header">
                  <h3><i class="bi bi-check2-square" style="margin-right:.4rem"></i>Decisão</h3>
                </div>
                <div class="card-body">

                  <c:choose>
                    <%-- Já foi processado: mostrar resultado, não mostrar form --%>
                    <c:when test="${atendimento.estado != 'PENDENTE'}">
                      <div class="alert ${atendimento.estado == 'CONFIRMADO' ? 'alert-success' : 'alert-danger'}">
                        <i class="bi ${atendimento.estado == 'CONFIRMADO' ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                        <div>Este atendimento já foi <strong>${atendimento.estado == 'CONFIRMADO' ? 'aprovado' : 'rejeitado'}</strong>.</div>
                      </div>
                      <a href="${pageContext.request.contextPath}/funcionario/pendentes"
                         class="btn btn-outline btn-full">
                        <i class="bi bi-arrow-left"></i> Voltar aos Pendentes
                      </a>
                    </c:when>

                    <%-- Pendente: mostrar formulário --%>
                    <c:otherwise>
                      <form action="${pageContext.request.contextPath}/funcionario/aprovacao"
                            method="post"
                            data-loading
                            id="formDecisao">

                        <input type="hidden" name="idAtendimento" value="${atendimento.idAtendimento}">

                        <div class="form-group">
                          <label class="form-label" for="observacao">
                            Observação <span class="muted text-sm">(opcional para aprovação, recomendada para rejeição)</span>
                          </label>
                          <textarea id="observacao"
                                    name="observacao"
                                    class="form-control"
                                    rows="4"
                                    maxlength="300"
                                    placeholder="Escreva uma observação ou motivo de rejeição…"></textarea>
                          <span class="form-hint">Máx. 300 caracteres.</span>
                        </div>

                        <!-- Botões de decisão -->
                        <div style="display:flex;gap:.75rem;margin-top:1.25rem">
                          <button type="submit"
                                  name="acao"
                                  value="aprovar"
                                  class="btn btn-success"
                                  style="flex:1;justify-content:center"
                                  data-confirm="Confirmar aprovação deste atendimento?">
                            <i class="bi bi-check-lg"></i> Aprovar
                          </button>
                          <button type="submit"
                                  name="acao"
                                  value="rejeitar"
                                  class="btn btn-danger"
                                  style="flex:1;justify-content:center"
                                  data-confirm="Rejeitar este pedido de atendimento?">
                            <i class="bi bi-x-lg"></i> Rejeitar
                          </button>
                        </div>

                        <div style="margin-top:.75rem">
                          <a href="${pageContext.request.contextPath}/funcionario/pendentes"
                             class="btn btn-outline btn-full">
                            Cancelar
                          </a>
                        </div>

                      </form>
                    </c:otherwise>
                  </c:choose>

                </div>
              </div>
            </div><!-- /coluna direita -->

          </div><!-- /grid -->
        </c:otherwise>
      </c:choose>

    </main>
  </div><!-- /main-content -->
</div><!-- /wrapper -->

<script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
</body>
</html>
