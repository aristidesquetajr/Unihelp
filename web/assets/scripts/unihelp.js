/* ============================================================
 UNIHELP | OJJ — Main JavaScript v1.0
 ============================================================ */
(function () {
    'use strict';

    /* ── Sidebar toggle (mobile) ── */
    window.toggleSidebar = function () {
        var sb = document.getElementById('sidebar');
        var ov = document.querySelector('.sidebar-overlay');
        if (!sb)
            return;
        var open = sb.classList.toggle('open');
        if (ov)
            ov.classList.toggle('show', open);
        document.body.style.overflow = open ? 'hidden' : '';
    };

    document.addEventListener('DOMContentLoaded', function () {

        /* ── Fechar sidebar ao clicar no overlay ── */
        var overlay = document.querySelector('.sidebar-overlay');
        if (overlay)
            overlay.addEventListener('click', window.toggleSidebar);

        /* ── Auto-dismiss de alertas após 5 s ── */
        document.querySelectorAll('[data-dismiss]').forEach(function (el) {
            setTimeout(function () {
                el.style.transition = 'opacity .4s';
                el.style.opacity = '0';
                setTimeout(function () {
                    el.remove();
                }, 420);
            }, 5000);
        });

        /* ── Confirmação antes de acções destrutivas ── */
        document.querySelectorAll('[data-confirm]').forEach(function (el) {
            el.addEventListener('click', function (e) {
                if (!confirm(el.getAttribute('data-confirm')))
                    e.preventDefault();
            });
        });

        /* ── Estado de loading em formulários ── */
        document.querySelectorAll('form[data-loading]').forEach(function (form) {
            form.addEventListener('submit', function () {
                var btn = form.querySelector('[type=submit]');
                if (!btn)
                    return;
                btn.disabled = true;
                btn._orig = btn.innerHTML;
                btn.innerHTML = '<i class="bi bi-arrow-repeat spin"></i> A processar…';
                setTimeout(function () {         /* fallback de segurança */
                    btn.disabled = false;
                    btn.innerHTML = btn._orig;
                }, 12000);
            });
        });

        /* ── Ano corrente no footer ── */
        document.querySelectorAll('[data-year]')
                .forEach(function (el) {
                    el.textContent = new Date().getFullYear();
                });

        /* ── Fechar sidebar se clicar fora (mobile) ── */
        document.addEventListener('click', function (e) {
            var sb = document.getElementById('sidebar');
            if (sb && sb.classList.contains('open')
                    && !sb.contains(e.target)
                    && !e.target.closest('.btn-sidebar-toggle')) {
                window.toggleSidebar();
            }
        });

        /* ── Marcar link activo na sidebar/topnav ── */
        var path = window.location.pathname;
        document.querySelectorAll('.sidebar-link, .topnav-link').forEach(function (a) {
            var href = a.getAttribute('href') || '';
            if (href && path.endsWith(href))
                a.classList.add('active');
        });

        /* ── Highlight da linha de tabela ao clicar ── */
        document.querySelectorAll('.uni-table tbody tr[data-href]').forEach(function (tr) {
            tr.style.cursor = 'pointer';
            tr.addEventListener('click', function () {
                window.location.href = tr.getAttribute('data-href');
            });
        });

    });

    /* ── CSS para animação de spin ── */
    var style = document.createElement('style');
    style.textContent = '@keyframes spin{to{transform:rotate(360deg)}}.spin{display:inline-block;animation:spin .7s linear infinite}';
    document.head.appendChild(style);

})();
