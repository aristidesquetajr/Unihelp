(function () {
  'use strict';

  var card = document.querySelector('.error-card');
  if (!card) return;

  /* ── Subtle parallax tilt on card ── */
  card.addEventListener('mousemove', function (e) {
    var rect = card.getBoundingClientRect();
    var x = (e.clientX - rect.left) / rect.width - 0.5;
    var y = (e.clientY - rect.top) / rect.height - 0.5;
    card.style.transform =
      'perspective(600px) rotateY(' + (x * 4) + 'deg) rotateX(' + (-y * 4) + 'deg)';
  });

  card.addEventListener('mouseleave', function () {
    card.style.transform = '';
  });
})();
