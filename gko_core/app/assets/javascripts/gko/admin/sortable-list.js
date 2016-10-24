// Make a list sortable Used by image_assignement and table
// TODO merge with sortable-list
make_sortable = function(element) {
  var url = element.data('sortable-url');
  var handle = element.data('sortable-handle');
  if(element.get(0)) {
    var items = element.get(0).tagName == 'UL' ? 'li' : 'tr';
  }
  
  element.sortable().on('sortupdate', function(event, o) {
    var el = $(o.item);
    $.ajax({
      type: "GET",
      url: url,
      items: items,
      handle: handle,
      data: {
        position: el.prevAll().length + 1,
        id: parseValue(el.attr('id'))
      },
      beforeSend: function(event, xhr, settings) {
        attachLoading();
      },
      success: function(event, data, status, xhr) {
        // item.effect("highlight");
      },
      complete: function(event, xhr, status) {
        removeLoading();
      }
    });
  });
}
