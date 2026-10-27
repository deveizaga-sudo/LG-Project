(function () {
  var $ = function (id) { return document.getElementById(id); };
  var stage = $('stage');
  var scroller = $('scroller');
  var rail = $('rail');
  var heroItem = null;
  var lastMainFocus = null;
  var activeRail = 'home';

  /* ---------- Fit the 1920x1080 stage to any window size ---------- */
  function fitStage() {
    var s = Math.min(window.innerWidth / 1920, window.innerHeight / 1080);
    var x = (window.innerWidth - 1920 * s) / 2;
    var y = (window.innerHeight - 1080 * s) / 2;
    stage.style.transform = 'translate(' + x + 'px,' + y + 'px) scale(' + s + ')';
  }

  /* ---------- Rendering ---------- */
  function renderRail() {
    var html = '';
    AppData.rail.forEach(function (item) {
      html += '<li class="rail__item focusable' + (item.id === activeRail ? ' is-active' : '') +
        '" tabindex="-1" data-action="rail" data-id="' + item.id + '">' +
        Icons.svg(item.icon) + '<span>' + item.label + '</span></li>';
    });
    $('rail-items').innerHTML = html;
  }

  function cardHtml(type, item, r, i) {
    var attrs = ' tabindex="-1" data-action="card" data-row="' + r + '" data-index="' + i + '"';
    if (type === 'app') {
      return '<div class="card card--app focusable"' + attrs + ' style="--art:' + item.art + '">' +
        Icons.svg(item.icon) + '<span class="card__label">' + item.title + '</span></div>';
    }
    if (type === 'input') {
      return '<div class="card card--input focusable"' + attrs + '>' + Icons.svg(item.icon) +
        '<div><div class="card__label">' + item.title + '</div><div class="card__sub">' + item.sub + '</div></div>' +
        '<i class="dot' + (item.live ? ' is-live' : '') + '"></i></div>';
    }
    return '<div class="card card--' + type + ' focusable"' + attrs + '>' +
      '<div class="card__art" style="--art:' + item.art + '"><span class="card__title">' + item.title + '</span></div>' +
      (item.progress != null ? '<div class="card__progress"><i style="width:' + item.progress + '%"></i></div>' : '') +
      '</div>';
  }

  function renderRows() {
    var html = '';
    AppData.rows.forEach(function (row, r) {
      html += '<section class="row" data-row="' + r + '"><h2 class="row__title">' + row.title + '</h2>' +
        '<div class="row__window"><div class="row__track">';
      row.items.forEach(function (item, i) { html += cardHtml(row.type, item, r, i); });
      html += '</div></div></section>';
    });
    $('rows').innerHTML = html;
  }

  /* ---------- No ads ---------- */
  // Drop anything a data source marks as paid placement, and any row left empty.
  function stripAds() {
    AppData.rows = AppData.rows.filter(function (row) {
      row.items = row.items.filter(function (item) { return !item.sponsored && !item.promoted; });
      return row.items.length > 0;
    });
  }

  /* ---------- Hero: resume what the viewer was last watching ---------- */
  function showHero() {
    var resume = AppData.rows.filter(function (row) { return row.type === 'wide'; })[0];
    heroItem = resume && resume.items[0];
    if (!heroItem) { $('hero').hidden = true; return; }
    $('hero-tag').textContent = 'Continue watching';
    $('hero-title').textContent = heroItem.title;
    $('hero-meta').textContent = heroItem.meta || '';
    $('hero-desc').textContent = heroItem.desc || '';
    stage.style.setProperty('--hero-bg', heroItem.art);
  }

  /* ---------- Scrolling to keep focus in view ---------- */
  var ROW_LEFT_PAD = 32;

  function scrollRowTo(el) {
    var track = el.parentNode;
    if (!track.classList.contains('row__track')) return;
    var index = Array.prototype.indexOf.call(track.children, el);
    var offset = 0;
    // Keep the focused card one slot from the left edge once past the first item.
    if (index > 0) offset = track.children[index - 1].offsetLeft - ROW_LEFT_PAD + 16;
    var max = Math.max(0, track.scrollWidth - (1920 - 112 - ROW_LEFT_PAD - 64));
    track.style.transform = 'translateX(' + -Math.min(offset, max) + 'px)';
  }

  function scrollPageTo(el) {
    var row = el.closest('.row');
    var y = 0;
    // Hero and top bar stay visible until the second row is reached.
    if (row && row.getAttribute('data-row') > 0) y = row.offsetTop - 360;
    scroller.style.transform = 'translateY(' + -Math.max(0, y) + 'px)';
    $('backdrop').style.opacity = y > 0 ? 0.35 : 1;
    stage.classList.toggle('is-scrolled', y > 0);
  }

  // First item on the page: the Resume button, or the first row if there is nothing to resume.
  function homeFocus() {
    return $('hero').hidden ? document.querySelector('.row .focusable') : document.querySelector('.hero .focusable');
  }

  /* ---------- Focus side-effects ---------- */
  Nav.on('focus', function (el) {
    var inRail = !!el.closest('.rail');
    rail.classList.toggle('is-open', inRail);
    if (el.closest('.viewport') || el.closest('.topbar')) lastMainFocus = el;
    if (el.closest('.row')) { scrollRowTo(el); scrollPageTo(el); }
    else if (el.closest('.hero') || el.closest('.topbar')) scrollPageTo(el);
  });

  // Leaving the rail returns to where the user came from.
  Nav.override = function (dir, cur) {
    if (dir === 'right' && cur.closest('.rail') && lastMainFocus) return lastMainFocus;
  };

  /* ---------- Selection ---------- */
  function itemFor(el) {
    var row = AppData.rows[el.getAttribute('data-row')];
    return { row: row, item: row.items[el.getAttribute('data-index')] };
  }

  function openModal(data) {
    $('modal-tag').textContent = data.tag || 'Details';
    $('modal-title').textContent = data.title;
    $('modal-meta').textContent = data.meta || '';
    $('modal-desc').textContent = data.desc || '';
    $('modal-art').style.setProperty('--art', data.art);
    $('modal').hidden = false;
    Nav.setScope($('modal'));
  }

  function closeOverlay(id) {
    $(id).hidden = true;
    Nav.setScope(null, lastMainFocus);
  }

  var toastTimer;
  function toast(msg) {
    var t = $('toast');
    t.textContent = msg;
    t.classList.add('is-visible');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function () { t.classList.remove('is-visible'); }, 2200);
  }

  Nav.on('select', function (el) {
    var action = el.getAttribute('data-action');
    switch (action) {
      case 'rail':
        activeRail = el.getAttribute('data-id');
        var items = rail.querySelectorAll('.rail__item');
        for (var i = 0; i < items.length; i++) items[i].classList.toggle('is-active', items[i] === el);
        toast(el.textContent + ' selected');
        break;
      case 'hero-play':
        toast('Resuming ' + heroItem.title);
        break;
      case 'hero-info':
        openModal(heroItem);
        break;
      case 'card':
        var d = itemFor(el);
        if (d.row.type === 'app') toast('Launching ' + d.item.title + '…');
        else if (d.row.type === 'input') toast('Switching to ' + d.item.title);
        else openModal(d.item);
        break;
      case 'modal-play':
        toast('Playing ' + $('modal-title').textContent);
        closeOverlay('modal');
        break;
      case 'modal-close':
        closeOverlay('modal');
        break;
      case 'exit-cancel':
        closeOverlay('exit-dialog');
        break;
      case 'exit-confirm':
        if (window.webOS && webOS.platformBack) webOS.platformBack();
        else window.close();
        break;
      default:
        toast(action.charAt(0).toUpperCase() + action.slice(1));
    }
  });

  /* ---------- Back key ---------- */
  Nav.on('back', function () {
    if (!$('modal').hidden) return closeOverlay('modal');
    if (!$('exit-dialog').hidden) return closeOverlay('exit-dialog');
    var cur = Nav.current;
    // Back from content returns to the top of the page first, then offers exit.
    if (cur && cur.closest('.row')) {
      Nav.focus(homeFocus());
      return;
    }
    $('exit-dialog').hidden = false;
    Nav.setScope($('exit-dialog'));
  });

  /* ---------- Clock & greeting ---------- */
  function tick() {
    var now = new Date();
    var h = now.getHours();
    var m = now.getMinutes();
    $('clock').textContent = ((h % 12) || 12) + ':' + (m < 10 ? '0' : '') + m + (h < 12 ? ' AM' : ' PM');
    $('greeting').textContent = h < 12 ? 'Good morning' : h < 18 ? 'Good afternoon' : 'Good evening';
  }

  /* ---------- Boot ---------- */
  function init() {
    fitStage();
    window.addEventListener('resize', fitStage);
    stripAds();
    renderRail();
    renderRows();
    Icons.hydrate();
    showHero();
    tick();
    setInterval(tick, 15000);
    Nav.init();
    Nav.focus(homeFocus());
  }

  document.addEventListener('DOMContentLoaded', init);
})();
