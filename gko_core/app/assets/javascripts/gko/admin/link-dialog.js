var link_dialog = {
    initialised:false,
    init:function () {
        if (!this.initialised) {
            this.init_close();
            this.page_tab();
            this.web_tab();
            this.email_tab();
            this.document_tab();
            this.initialised = true;
        }
    },

    init_close:function () {
        if (parent && parent.document.location.href != document.location.href
            && parent.document.getElementById('wym_dialog_submit') != null) {
            $('#dialog_container input#insert_link_submit').click(function (e) {
                e.preventDefault();
                $(parent.document.getElementById('wym_dialog_submit')).click();
            });
        }
    },

    page_tab:function () {
        $('#link_to_page').on("click", "a.selectable", function (event) {
            var el = $(this),
                li = el.parent(),
				ul = li.parent();

            $('#link_to_page ul.selection').find('.ui-selected').removeClass('ui-selected');
            li.addClass('ui-selected');
            link_dialog.update_parent(el.attr('href'), el.html());
            event.preventDefault();
        });
    },

    document_tab:function () {
        $('#link_to_document li a').click(function (e) {
            e.preventDefault();
            link_dialog.update_parent($(this).attr("href"));
        });
    },

    web_tab:function () {
        $('#web_address_text').change(function (e) {
            link_dialog.update_parent($('#web_address_text').val(), null, "_blank");
        });
    },

    email_tab:function () {
        $('#email_address_text, #email_default_subject_text, #email_default_body_text').change(function (e) {
            var default_subject = $('#email_default_subject_text').val(),
                default_body = $('#email_default_body_text').val(),
                mailto = "mailto:" + $('#email_address_text').val(),
                modifier = "?";

            if (default_subject.length > 0) {
                mailto += modifier + "subject=" + default_subject;
                modifier = "&";
            }

            if (default_body.length > 0) {
                mailto += modifier + "body=" + default_body;
                modifier = "&";
            }

            link_dialog.update_parent(mailto, mailto.replace('mailto:', ''));
        });
    },

    update_parent:function (url, title, target) {
        if (parent != null) {
            if ((wym_href = parent.document.getElementById('wym_href')) != null) {
                wym_href.value = url;
            }
            if ((wym_title = parent.document.getElementById('wym_title')) != null) {
                wym_title.value = title;
            }
            if ((wym_target = parent.document.getElementById('wym_target')) != null) {
                wym_target.value = target || "";
            }
        }
    }
};