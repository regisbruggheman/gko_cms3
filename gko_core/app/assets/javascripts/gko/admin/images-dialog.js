var images_dialog = {
    initialised:false,
    init:function () {
        if (!this.initialised) {
            // Listen image size selection
            $('#image_dialog_size_container ul li a').on("click", function (e) {
                $('#image_dialog_size_container ul li').removeClass('active');
                $(this).parent().addClass('active');
                e.preventDefault();
            });

            // Listen image selection
            $('body#dialog_container').on("click", "ul.js-selectable a",
                function (e) {
                    e.preventDefault();
                    var link = $(this),
                        form = $("#image_assignments_form");

                    // We are in multiple selection
                    if (form.length > 0) {
                        // Get the image id
                        var dom_id = link.closest("li").attr('id');
                        var id = parseValue(dom_id);
                        // Populate the hidden form fields
                        $('#image_assignment_image_id').val(id);
                        // ... and submit the form
                        // ... view modifications are in the rjs file
                        form.live("ajax:beforeSend.rails",
                            function (xhr, settings) {
                                attachLoading("body#dialog_container");
                            }).live("ajax:complete.rails",
                            function (xhr, status) {
                                removeLoading("body#dialog_container");
                            }).submit();
                    }
                    else { // We are in wymeditor
                        var img = link.find('img:first');
                        var size = $('#image_dialog_size_container li.active a').attr('data-size');
                        image_url = img.attr('data-' + size);
                        if (parent) {
                            if ((wym_src = parent.document.getElementById('wym_src')) != null) {
                                wym_src.value = image_url;
                            }
                            if ((wym_title = parent.document.getElementById('wym_title')) != null) {
                                wym_title.value = img.attr('title');
                            }
                            if ((wym_alt = parent.document.getElementById('wym_alt')) != null) {
                                wym_alt.value = img.attr('alt');
                            }
                            if ((wym_dialog_submit = parent.document.getElementById('wym_dialog_submit')) != null) {
                                wym_dialog_submit.click();
                            }
                        }
                    }
                });
            this.initialised = true;
        }
    },
}