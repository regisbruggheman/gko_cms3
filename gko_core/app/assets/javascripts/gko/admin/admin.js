
var shiftHeld = false;
var body, loader, dialog_max_width = 964, comfirm_dialog;

/*/////////////////////////////////////////////*/

$(document).ready(function () {
	body = $("body");
	body.on("ajax:beforeSend", "a[data-remote], form[data-remote]",
		function (event, xhr, settings) {
			attachLoading("body");
		})
		.on("ajax:complete", function (event, xhr, status) {
			removeLoading("body");
		}).on('click', 'a.remove_fields', function () {
	        $(this).prev("input[type=hidden]").val("1");
	        $(this).closest(".fields").hide();
	        return false;
	    }).on('change', '.observe_field', function () {
	        target = $(this).attr("data-update");
	        ajax_indicator = $(this).attr("data-ajax-indicator") || '#busy_indicator';
	        $(target).hide();
	        $(ajax_indicator).show();
	        $.ajax({ dataType:'html',
	            url:$(this).attr("data-base-url") + encodeURIComponent($(this).val()),
	            type:'get',
	            success:function (data) {
	                $(target).html(data);
	                $(ajax_indicator).hide();
	                $(target).show();
	            }
	        });
	    });

    // Possible defunct
    add_fields = function (target, association, content) {
        var new_id = new Date().getTime();
        var regexp = new RegExp("new_" + association, "g");
        $(target).append(content.replace(regexp, new_id));
        $('input.color-field').each(function () {
          $(this).css('backgroundColor', $(this).attr('value')).colorpicker()
          .on('changeColor', function(ev) {
            $(this).css('backgroundColor', ev.color.toHex());
          });
        });
    }

    // Override rails to use custom alert
    $.rails.allowAction = function (element) {
        var message = element.data('confirm'),
            answer = false,
            callback;
        if (!message) {
            return true;
        }
        if ($.rails.fire(element, 'confirm')) {

            bootbox.setIcons({
                "CONFIRM":"icon-trash icon-white"
            });
            bootbox.confirm(message, "Non annuler", "Oui supprimer", function (result) {
                if (result) {
                    //console.log("User confirmed dialog");
                    $.rails.fire(element, 'confirm:complete', [answer]);
                    var oldAllowAction = $.rails.allowAction;
                    $.rails.allowAction = function () {
                        return true;
                    };
                    element.trigger('click');
                    $.rails.allowAction = oldAllowAction;
                } else {
                    //console.log("User declined dialog");
                }
                bootbox.setIcons(null);
            });
        }
        return false;
    }

    if(parent && (parent.document.location.href != document.location.href)) {
      $("body#dialog_container.dialog").addClass("iframed");
    };

    $("ul.wym_tools a, li.wym_tools_class a:first").each(function () {
      $(this).attr('rel', 'tooltip').html('');
    });

    $('a[rel="tooltip"], a[rel="tooltip nofollow"]').tooltip();
    $('input[rel="popover"]').popover();

    $('.btn.toggle').on('click', function(e) {
      e.preventDefault();
      $($(this).attr('href')).toggle();
    });

    //-------------------------------------------------
    //-- DATE PICKERS
    // Define the dateFormat for the datepicker.
    // "day month year" is the default CMS format whatever the language used in forms.
    // TODO define format and language for the user
    $.datepicker.setDefaults($.datepicker.regional['fr']);
    $('input.date_picker, input.date, input.datetime').datepicker({
      dateFormat: 'yy-mm-d'
    });


    init_text_editor();
    init_modal_dialogs();
    init_images();
    init_videos();

    $('select[data-dynamic-selectable-url][data-dynamic-selectable-target]').dynamicSelectable();

    //init_nested_form_links();
    $('textarea.wysihtml5').wysihtml5({
      stylesheets: '/assets/gko_wysihtml5_body.css'
    });

    // COLOR PICKER
    // =========================

    $('input.color-field').each(function () {
      $(this).css('backgroundColor', $(this).attr('value')).colorpicker()
      .on('changeColor', function(ev) {
        $(this).css('backgroundColor', ev.color.toHex());
      });
    });
});



////////////////////////////////////////////////////////////////////////
close_dialog = function (e) {
    //console.log("XXXXXXXXXXXX close_dialog");
    if (iframed()) {
        the_body = $(parent.document.body);
        the_dialog = parent.$('.ui-dialog-content');
    } else {
        the_body = $(document.body).removeClass('hide-overflow');
        the_dialog = $('.ui-dialog-content');
        the_dialog.filter(':data(dialog)').dialog('close');
        the_dialog.remove();
    }

    // if there's a wymeditor involved don't try to close the dialog as wymeditor will.
    if (!$(document.body).hasClass('wym_iframe_body')) {
        the_body.removeClass('hide-overflow');
        the_dialog.filter(':data(dialog)').dialog('close');
        the_dialog.remove();
        e.preventDefault();
    }
};
