init_text_editor = function() {

  // make sure that users can tab to wymeditor fields and add an overlay while loading.
  $('textarea.wymeditor').each(function() {
    textarea = $(this);
    if ((instance = WYMeditor.INSTANCES[$((textarea.next('.wym_box').find('iframe').attr('id') || '').split('_')).last().get(0)]) != null) {
      if ((next = textarea.parent().next()) != null && next.length > 0) {
        next.find('input, textarea').keydown($.proxy(function(e) {
          shiftHeld = e.shiftKey;
          if (shiftHeld && e.keyCode == $.ui.keyCode.TAB) {
            this._iframe.contentWindow.focus();
            e.preventDefault();
          }
        }, instance)).keyup(function(e) {
          shiftHeld = false;
        });
      }
      if ((prev = textarea.parent().prev()) != null && prev.length > 0) {
        prev.find('input, textarea').keydown($.proxy(function(e) {
          if (e.keyCode == $.ui.keyCode.TAB) {
            this._iframe.contentWindow.focus();
            e.preventDefault();
          }
        }, instance));
      }
    }
  });
}
