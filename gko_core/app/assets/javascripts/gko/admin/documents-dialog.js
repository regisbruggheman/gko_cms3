var documents_dialog = {
  initialised: false,
  init: function() { 

    if (!this.initialised) {
      // Listen document selection
      $('#documents-list > li').on("click", "a.preview", function(e) {
        e.preventDefault();
        var link = $(this),
            form = $("#document-assignments-form");
        // We are in multiple selection
        if (form.length > 0) {
          // Get the document id
          var id = parseValue(link.closest("li").attr('id'));
          // Populate the hidden form fields
          $('#document_assignment_document_id').val(id);
          // ... and submit the form
          // ... view modifications are in the rjs file
          form.live("ajax:beforeSend.rails", function(xhr, settings) {
            attachLoading("body#dialog_container");
          }).live("ajax:complete.rails", function(xhr, status) {
            removeLoading("body#dialog_container");
          }).submit();
        } else { // We are in wymeditor
        }
        return false;
      });
      this.initialised = true;
    }
  }
}
