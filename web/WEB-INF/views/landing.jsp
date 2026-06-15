<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNIHELP — Sistema de Gestão Académica OJJ</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
    </head>
    <body>

        <!-- ═══════════════════════════════════════
             NAVEGAÇÃO
             ═══════════════════════════════════════ -->
        <nav class="landing-nav">
            <div class="landing-brand">
                <div class="brand-logo">UH</div>
                UNIHELP
            </div>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-accent btn-sm">
                <i class="bi bi-box-arrow-in-right"></i> Entrar
            </a>
        </nav>

        <!-- ═══════════════════════════════════════
             HERO
             ═══════════════════════════════════════ -->
        <section class="landing-hero">
            <div class="hero-logo">UH</div>
            <h1>UNIHELP &mdash; OJJ</h1>
            <p>Sistema integrado de gestão de atendimentos, notas e registos académicos da instituição OJJ. Simples, rápido e seguro.</p>
            <div class="hero-btns">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-accent btn-lg">
                    <i class="bi bi-box-arrow-in-right"></i>&nbsp; Aceder ao Sistema
                </a>
            </div>
            <!-- estatísticas visuais -->
            <div style="display:flex;justify-content:center;gap:3rem;margin-top:3rem;flex-wrap:wrap">
                <div style="text-align:center">
                    <div style="font-size:2rem;font-weight:900;color:var(--accent-light)">3</div>
                    <div style="font-size:.78rem;color:rgba(255,255,255,.55);text-transform:uppercase;letter-spacing:.06em">Perfis de Acesso</div>
                </div>
                <div style="text-align:center">
                    <div style="font-size:2rem;font-weight:900;color:var(--accent-light)">11</div>
                    <div style="font-size:.78rem;color:rgba(255,255,255,.55);text-transform:uppercase;letter-spacing:.06em">Entidades Académicas</div>
                </div>
                <div style="text-align:center">
                    <div style="font-size:2rem;font-weight:900;color:var(--accent-light)">27</div>
                    <div style="font-size:.78rem;color:rgba(255,255,255,.55);text-transform:uppercase;letter-spacing:.06em">Operações Disponíveis</div>
                </div>
            </div>
        </section>

        <!-- ═══════════════════════════════════════
             FUNCIONALIDADES
             ═══════════════════════════════════════ -->
        <section class="landing-features">
            <h2 class="features-title">O que o sistema oferece</h2>
            <p class="features-sub">Três perfis de acesso, cada um com as ferramentas certas para o seu papel.</p>

            <div class="features-grid">

                <!-- Estudante: Agendamento -->
                <div class="feature-card">
                    <div class="feature-icon" style="background:rgba(30,58,95,.1);color:var(--primary)">
                        <i class="bi bi-calendar-plus"></i>
                    </div>
                    <h3>Agendamento de Atendimentos</h3>
                    <p>Estudantes podem agendar atendimentos com funcionários, acompanhar o estado (pendente, confirmado ou rejeitado) e consultar o histórico completo.</p>
                </div>

                <!-- Estudante: Notas -->
                <div class="feature-card">
                    <div class="feature-icon" style="background:rgba(39,103,73,.1);color:var(--success)">
                        <i class="bi bi-journal-text"></i>
                    </div>
                    <h3>Boletim de Notas</h3>
                    <p>Consulta de notas por disciplina e período letivo, com distinção entre avaliação contínua, exames e provas de recurso.</p>
                </div>

                <!-- Estudante: Inscrições -->
                <div class="feature-card">
                    <div class="feature-icon" style="background:rgba(201,162,39,.12);color:var(--accent-dark)">
                        <i class="bi bi-book-half"></i>
                    </div>
                    <h3>Histórico de Inscrições</h3>
                    <p>Visualização completa das inscrições em cursos e turmas por período letivo, com estado actual (activo, concluído ou trancado).</p>
                </div>

                <!-- Funcionário: Agenda -->
                <div class="feature-card">
                    <div class="feature-icon" style="background:rgba(43,108,176,.1);color:var(--info)">
                        <i class="bi bi-calendar2-week"></i>
                    </div>
                    <h3>Gestão da Agenda</h3>
                    <p>Funcionários consultam e gerem a sua agenda diária, aprovam ou rejeitam pedidos de atendimento e registam notas dos estudantes.</p>
                </div>

                <!-- Admin: Utilizadores -->
                <div class="feature-card">
                    <div class="feature-icon" style="background:rgba(192,86,33,.1);color:var(--warning)">
                        <i class="bi bi-people"></i>
                    </div>
                    <h3>Gestão de Utilizadores</h3>
                    <p>Administradores controlam todos os perfis de acesso (ADMIN, ESTUDANTE, FUNCIONÁRIO), podendo activar ou bloquear contas.</p>
                </div>

                <!-- Admin: Académico -->
                <div class="feature-card">
                    <div class="feature-icon" style="background:rgba(197,48,48,.08);color:var(--danger)">
                        <i class="bi bi-mortarboard"></i>
                    </div>
                    <h3>Estrutura Académica</h3>
                    <p>Gestão centralizada de cursos, disciplinas, turmas, períodos letivos e inscrições. Toda a estrutura da instituição num só painel.</p>
                </div>

            </div>
        </section>

        <!-- ═══════════════════════════════════════
             RODAPÉ
             ═══════════════════════════════════════ -->
        <footer class="landing-footer">
            &copy; <span data-year></span> UNIHELP &mdash; OJJ &bull;
            Projecto Final de Programação IV &bull;
            Desenvolvido com Java EE + JSP + JDBC + MySQL
        </footer>

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
    </body>
</html>
