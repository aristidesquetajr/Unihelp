<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="UNIHELP - Uma plataforma moderna para gestão académica e escolar, conectando estudantes, professores e administração num ecossistema digital seguro.">
        <meta name="keywords" content="gestão académica, sistema escolar, plataforma educacional, Angola">
        <meta property="og:title" content="UNIHELP - Sistema Académico">
        <meta property="og:description" content="Plataforma moderna para gestão escolar conectando estudantes, professores e administração.">
        <meta property="og:type" content="website">
        <title>UNIHELP - Sistema Académico</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/landing.css">
    </head>
    <body>

        <header>
            <div class="logo">
                <a href="${pageContext.request.contextPath}/" class="logo-link">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="UNIHELP Logo">
                    UNIHELP
                </a>
            </div>

            <nav>
                <a href="#sobre">Sobre</a>
                <a href="#func">Funcionalidades</a>
                <a href="#seguranca">Segurança</a>
            </nav>

            <button class="btn" data-action="navigate" data-target="${pageContext.request.contextPath}/login" aria-label="Entrar no sistema">
                Entrar
            </button>
        </header>

        <section class="hero">
            <h1>Sistema Académico <span>UNIHELP</span></h1>

            <p>
                Uma plataforma moderna para gestão escolar, conectando estudantes, professores e administração
                num único ecossistema digital seguro, rápido e inteligente.
            </p>

            <div class="hero-actions">
                <button class="btn-primary" data-action="navigate" data-target="${pageContext.request.contextPath}/login">Aceder ao Sistema</button>
                <button class="btn-secondary" data-action="scroll" data-target="#sobre">Saber mais</button>
            </div>
        </section>

        <section class="stats">
            <div class="stat">
                <h2>+1.200</h2>
                <p>Estudantes</p>
            </div>

            <div class="stat">
                <h2>+80</h2>
                <p>Funcionários</p>
            </div>

            <div class="stat">
                <h2>100%</h2>
                <p>Digital</p>
            </div>

            <div class="stat">
                <h2>24/7</h2>
                <p>Disponível</p>
            </div>
        </section>

        <section class="section" id="sobre">
            <h2 class="section-title">Sobre o UNIHELP</h2>

            <div class="card">
                <h3>Missão</h3>
                <p>
                    A missão do UNIHELP é modernizar e facilitar a gestão académica das instituições de ensino em Angola, promovendo a digitalização dos processos escolares e melhorando a comunicação entre estudantes, funcionários e administração.
                    <br><br>
                    O sistema foi desenvolvido para centralizar informações como notas, inscrições, agendamentos de atendimento e gestão de utilizadores, reduzindo o uso de processos manuais e tornando a gestão escolar mais eficiente, organizada e acessível.
                </p>

                <br>

                <h3>Visão</h3>
                <p>
                    Ser uma plataforma académica de referência em Angola, contribuindo para a transformação digital das instituições de ensino e para a melhoria da qualidade da gestão escolar no país.
                    <br><br>
                    O UNIHELP pretende apoiar escolas, institutos e universidades na transição para sistemas digitais modernos, seguros e eficientes, facilitando o acesso à informação académica em qualquer lugar.
                </p>
                <br>

                <h3>Valores</h3>
                <p>
                    <strong>Inovação</strong> — aplicação de tecnologia para melhorar a educação em Angola.<br>
                    <strong>Eficiência</strong> — redução de burocracia e melhoria dos processos académicos.<br>
                    <strong>Organização</strong> — centralização e gestão estruturada de dados escolares.<br>
                    <strong>Transparência</strong> — acesso claro e controlado à informação.<br>
                    <strong>Responsabilidade</strong> — proteção e uso correto dos dados dos utilizadores.<br>
                    <strong>Acessibilidade</strong> — sistema simples, intuitivo e adaptado ao contexto local.
                </p>
        </section>

        <section class="section" id="func">
            <h2 class="section-title">Funcionalidades</h2>

            <div class="grid">

                <div class="card">
                    <h3>📊 Gestão de Notas</h3>
                    <p>Consulta e lançamento de notas em tempo real.</p>
                </div>

                <div class="card">
                    <h3>🧑‍🎓 Estudantes</h3>
                    <p>Perfil académico completo e histórico escolar.</p>
                </div>

                <div class="card">
                    <h3>📅 Agendamentos</h3>
                    <p>Gestão de atendimentos entre alunos e funcionários.</p>
                </div>

                <div class="card">
                    <h3>📁 Relatórios</h3>
                    <p>Relatórios automáticos para administração.</p>
                </div>

                <div class="card">
                    <h3>🔐 Segurança</h3>
                    <p>Acesso por perfis com autenticação segura.</p>
                </div>

                <div class="card">
                    <h3>🌐 Cloud</h3>
                    <p>Acesso online de qualquer dispositivo.</p>
                </div>

            </div>
        </section>

        <section class="section" id="seguranca">
            <h2 class="section-title">Segurança</h2>

            <div class="card">
                <h3>Segurança do Sistema</h3>
                <p>
                    A segurança do UNIHELP é fundamental para garantir a proteção dos dados académicos das instituições de ensino em Angola.
                    <br><br>
                    O sistema inclui medidas como:
                    <br><br>
                    • Autenticação segura através de login com email e senha<br>
                    • Controlo de acesso por perfis (Estudante, Funcionário e Administrador)<br>
                    • Restrição de funcionalidades conforme o nível de utilizador<br>
                    • Proteção de dados académicos e pessoais<br>
                    • Prevenção de acessos não autorizados ao sistema<br>
                    • Organização de permissões para garantir uso correto da plataforma
                    <br><br>
                    O objetivo é assegurar que cada utilizador tenha acesso apenas às informações e funções necessárias ao seu perfil, garantindo confidencialidade, integridade e segurança dos dados.
                </p>
            </div>
        </section>

        <footer>
            &copy; 2026 UNIHELP &mdash; OJJ &bull;
            Projecto Final de Programação IV &bull;
            Desenvolvido com Java EE + JSP + JDBC + MySQL
        </footer>

        <script src="${pageContext.request.contextPath}/assets/scripts/landing.js"></script>
    </body>
</html>
