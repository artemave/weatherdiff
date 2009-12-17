function showTooltip(x, y, contents, css_class) {
  $('<div class="site-tooltip">' + contents + '</div>').css( {
    position: 'absolute',
    display: 'none',
    top: y + 5,
    left: x + 15,
    opacity: 0.80
  }).addClass(css_class == undefined ? 'ui-state-highlight' : '').appendTo("body").fadeIn(200);
}

function removeTooltip()  {
  $('.site-tooltip').remove();
}

