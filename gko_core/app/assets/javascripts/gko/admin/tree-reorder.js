/*
 //= require jquery.mjs.nestedSortable
*/
// reorder a tree - used by section and category model
var list_reorder = {
  initialised: false,
  init: function(element, url, maxLevel) {
    this.element = element;
    this.url = url;

    element.nestedSortable({
      disableNesting: 'no-nest',
      forcePlaceholderSize: true,
      handle: 'i.icon-move',
      helper: 'clone',
      items: 'li',
      listType: 'ul',
      maxLevels: maxLevel || 3,
      opacity: .6,
      placeholder: 'placeholder',
      revert: 250,
      tabSize: 25,
      tolerance: 'pointer',
      toleranceElement: '> div',
      protectRoot: this.element.hasClass('root-protected'),
      isAllowed: function(item, parent) { 
        return true; 
      },
      update: function(event, ui) {
        // ITEM ID
        item_id = get_number_from_string(ui.item.attr('id'));
        // PARENT ID
        try {
          parent_id = ui.item.parent().parent().attr('id');
          if (parent_id == undefined) {
            parent_id = 0;
          } else {
            parent_id = get_number_from_string(parent_id);
          }
        } catch (ex) {
          parent_id = 0;
        }
        // PREV ID
        try {
          prev_id = get_number_from_string(ui.item.prev().attr('id'));
        } catch (ex) {
          prev_id = 0;
        }
        // NEXT ID
        try {
          next_id = get_number_from_string(ui.item.next().attr('id'));
        } catch (ex) {
          next_id = 0;
        }

        jQuery.ajax({
          type: 'POST',
          url: list_reorder.url,
          data: {
            node_id: item_id,
            parent_id: parent_id,
            prev_id: prev_id,
            next_id: next_id,
            authenticity_token: AUTH_TOKEN
          },
          dataType: 'script',
          beforeSend: function(xhr) {
            attachLoading("body");
          },
          error: function(xhr, status, error) {
            //alert(error);
          },
          complete: function(xhr, status) {
            removeLoading("body");
          }
        });
      }
    });
    this.initialised = true;
  }
};
