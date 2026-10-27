/*
 * Spatial navigation for the webOS remote (D-pad) plus Magic Remote pointer.
 *
 * Every element with the `.focusable` class inside the active scope is a
 * candidate. Arrow keys move focus to the nearest candidate in that
 * direction, weighting cross-axis distance more heavily so focus stays
 * visually aligned (row to row, column to column).
 */
var Nav = (function () {
  var KEY = {
    LEFT: 37, UP: 38, RIGHT: 39, DOWN: 40,
    ENTER: 13,
    BACK: 461,          // webOS remote Back
    BACKSPACE: 8,       // desktop browser fallback
    ESC: 27
  };

  var scope = document;
  var current = null;
  var listeners = { focus: [], select: [], back: [] };

  function on(evt, fn) { listeners[evt].push(fn); }
  function emit(evt, arg) {
    for (var i = 0; i < listeners[evt].length; i++) listeners[evt][i](arg);
  }

  function candidates() {
    var all = scope.querySelectorAll('.focusable');
    var out = [];
    for (var i = 0; i < all.length; i++) {
      if (all[i] !== current && all[i].offsetParent !== null && !isClippedLeft(all[i])) out.push(all[i]);
    }
    return out;
  }

  // Cards scrolled past the left edge of a [data-nav-clip] container are
  // hidden, so they must not be reachable. Cards off the right edge stay
  // reachable so rows can scroll forward.
  function isClippedLeft(el) {
    var clip = el.closest('[data-nav-clip]');
    return !!clip && el.getBoundingClientRect().left < clip.getBoundingClientRect().left;
  }

  function center(r) { return { x: r.left + r.width / 2, y: r.top + r.height / 2 }; }

  function findNext(dir) {
    if (!current) return candidates()[0] || null;
    var from = current.getBoundingClientRect();
    var c = center(from);
    var best = null;
    var bestScore = Infinity;
    var list = candidates();

    for (var i = 0; i < list.length; i++) {
      var r = list[i].getBoundingClientRect();
      var t = center(r);
      var primary, cross;

      switch (dir) {
        case 'left':  if (r.right > from.left + 1) continue; primary = from.left - r.right; cross = Math.abs(t.y - c.y); break;
        case 'right': if (r.left < from.right - 1) continue; primary = r.left - from.right; cross = Math.abs(t.y - c.y); break;
        case 'up':    if (r.bottom > from.top + 1) continue; primary = from.top - r.bottom; cross = Math.abs(t.x - c.x); break;
        case 'down':  if (r.top < from.bottom - 1) continue; primary = r.top - from.bottom; cross = Math.abs(t.x - c.x); break;
      }

      var score = Math.max(primary, 0) + cross * 2.5;
      if (score < bestScore) { bestScore = score; best = list[i]; }
    }
    return best;
  }

  function focus(el) {
    if (!el || el === current) return;
    if (current) current.classList.remove('is-focused');
    current = el;
    current.classList.add('is-focused');
    if (current.focus) current.focus({ preventScroll: true });
    emit('focus', current);
  }

  function move(dir) {
    // An optional hook may redirect focus (e.g. leaving the rail restores the last item).
    var next = (api.override && current && api.override(dir, current)) || findNext(dir);
    if (next) focus(next);
  }

  // Restrict navigation to a container (e.g. a modal); pass null to reset.
  function setScope(el, initial) {
    scope = el || document;
    if (current) current.classList.remove('is-focused');
    current = null;
    focus(initial || scope.querySelector('.focusable'));
  }

  function onKey(e) {
    document.body.classList.add('dpad-mode');
    switch (e.keyCode) {
      case KEY.LEFT:  move('left'); break;
      case KEY.RIGHT: move('right'); break;
      case KEY.UP:    move('up'); break;
      case KEY.DOWN:  move('down'); break;
      case KEY.ENTER: if (current) emit('select', current); break;
      case KEY.BACK:
      case KEY.BACKSPACE:
      case KEY.ESC:   emit('back'); break;
      default: return;
    }
    e.preventDefault();
  }

  // Magic Remote: pointer hover moves focus, click selects.
  function onPointerOver(e) {
    var el = e.target.closest && e.target.closest('.focusable');
    if (el && (scope === document || scope.contains(el))) {
      document.body.classList.remove('dpad-mode');
      focus(el);
    }
  }
  function onClick(e) {
    var el = e.target.closest && e.target.closest('.focusable');
    if (el && (scope === document || scope.contains(el))) {
      focus(el);
      emit('select', el);
    }
  }

  function init() {
    document.addEventListener('keydown', onKey);
    document.addEventListener('mouseover', onPointerOver);
    document.addEventListener('click', onClick);
    // webOS fires this when the Magic Remote pointer appears/disappears.
    document.addEventListener('cursorStateChange', function (e) {
      var visible = e.detail && e.detail.visibility;
      document.body.classList.toggle('dpad-mode', !visible);
    });
  }

  var api = {
    init: init,
    on: on,
    focus: focus,
    setScope: setScope,
    override: null,
    get current() { return current; }
  };
  return api;
})();
