document.addEventListener('DOMContentLoaded', () => {
    const buttons = document.querySelectorAll('[data-action]');

    buttons.forEach(button => {
        button.addEventListener('click', (e) => {
            const action = button.dataset.action;
            const target = button.dataset.target;

            if (action === 'navigate' && target) {
                window.location.href = target;
            } else if (action === 'scroll' && target) {
                const element = document.querySelector(target);
                if (element) {
                    element.scrollIntoView({behavior: 'smooth'});
                }
            }
        });
    });

    // Scroll animation para cards
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    document.querySelectorAll('.card').forEach(card => {
        observer.observe(card);
    });
});
