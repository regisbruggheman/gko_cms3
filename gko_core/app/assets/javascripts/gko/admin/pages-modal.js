var pages_modal = {
    initialised:false,
    init:function () {
        if (this.initialised) {
            return
        };
     
        $("#page_selection_modal").on("click", 'a.selectable',function (event) {
            var el = $(this).parent();
            el.parent().find('> .ui-selected').removeClass('ui-selected');
            el.addClass('ui-selected');
            event.preventDefault();
        });
        $("#page_selection_modal").on("click", 'a#validate_page_selection_btn' ,function (event) {
            var el = $("li.ui-selected:first"),
                type = el.data('type'),
                id = parseValue(el.attr('id')),
                name = el.find('a.selectable:first').html();
            $('#owner_name').html(name);
            $('#owner_id').val(id);
            $('#owner_type').val(type);
            $('#page_selection_modal').modal('hide');
        });
        this.initialised = true;
    }
}