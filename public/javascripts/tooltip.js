function showTooltip(x, y, contents) {
  $('<div id="tooltip">' + contents + '</div>').css( {
    position: 'absolute',
    display: 'none',
    top: y + 15,
    left: x + 15,
    opacity: 0.80
  }).addClass('ui-state-highlight').appendTo("body").fadeIn(200);
}

function removeTooltip()  {
  $('#tooltip').remove();
}

