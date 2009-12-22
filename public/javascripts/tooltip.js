function showTooltip(x, y, contents, css_class) {
  $('<div class="site-tooltip">' + contents + '</div>')
  .css({
    position: 'absolute',
    display: 'none',
    top: y + 5,
    left: x + 15
  })
  .css($.support.opacity ? {opacity: 0.8} : {}) //guess which browser does not support opacity? the answer is amaizingly obvious.
  .addClass(css_class == undefined ? 'ui-state-highlight' : '')
  .appendTo("body")
  .show();
}

function removeTooltip()  {
  $('.site-tooltip').remove();
}

