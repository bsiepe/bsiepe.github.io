// Comparison controls.
(function () {
  var mock = document.getElementById('mock');
  var state = { dir: 'scholarly', theme: 'light', palette: 'neutral', serif: 'crimson' };
  try {
    var saved = JSON.parse(localStorage.getItem('compare-state-4') || '{}');
    Object.keys(state).forEach(function (k) { if (saved[k]) state[k] = saved[k]; });
  } catch (e) {}
  var params = new URLSearchParams(location.search);
  Object.keys(state).forEach(function (k) { if (params.get(k)) state[k] = params.get(k); });

  function apply() {
    mock.dataset.dir = state.dir;
    mock.dataset.theme = state.theme;
    mock.dataset.palette = state.palette;
    mock.dataset.serif = state.serif;
    document.querySelectorAll('.bench button').forEach(function (b) {
      b.setAttribute('aria-pressed', String(state[b.dataset.set] === b.value));
    });
    document.querySelectorAll('.spec').forEach(function (s) {
      s.classList.toggle('on', s.dataset.for === state.dir);
    });
    try { localStorage.setItem('compare-state-4', JSON.stringify(state)); } catch (e) {}
  }

  document.querySelectorAll('.bench button').forEach(function (b) {
    b.addEventListener('click', function () { state[b.dataset.set] = b.value; apply(); });
  });
  document.querySelector('[data-toggle-theme]').addEventListener('click', function () {
    state.theme = state.theme === 'light' ? 'dark' : 'light'; apply();
  });
  document.addEventListener('keydown', function (e) {
    if (e.ctrlKey || e.metaKey || e.altKey || /input|textarea/i.test(e.target.tagName)) return;
    var dirs = { '1': 'editorial', '2': 'technical', '3': 'scholarly' };
    if (dirs[e.key]) state.dir = dirs[e.key];
    else if (e.key === 'd') state.theme = state.theme === 'light' ? 'dark' : 'light';
    else if (e.key === 's') { var o = ['libertinus', 'literata', 'crimson', 'newsreader']; state.serif = o[(o.indexOf(state.serif) + 1) % o.length]; }
    else if (e.key === 'p') state.palette = state.palette === 'warm' ? 'neutral' : 'warm';
    else return;
    apply();
  });

  apply();
})();
