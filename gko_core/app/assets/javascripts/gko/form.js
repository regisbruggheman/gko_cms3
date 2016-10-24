// http://www.alfajango.com/blog/rails-3-remote-links-and-forms/

var Form = {
    init : function() {
		$("form[data-remote]")
		.on("ajax:beforeSend", function(evt, xhr, settings) {
			// do something
		})
		.on("ajax:error", function(evt, xhr, status, error) {
			var that = $(this),
				flash = $.parseJSON(xhr.getResponseHeader('X-Flash-Messages')),
				errors = $.parseJSON(xhr.responseText).errors;
			
			hideErrors(that);
			hideMessage(that);
			
			if(errors) {
				displayErrors(that, errors)
			}

			if(flash.error) {
				displayMessage(that, flash.error)
			}
			

		})
		.on("ajax:success", function(evt, xhr, status){
			hideErrors(that);
			hideMessage(that);
			resetFields(that);
		});
		.on("ajax:complete", function(evt, xhr, status){
			// do something
		});
    },
    showMessage : function(target, message) {
		target.prepend("<div class='alert alert-error fade in'><a class='close' data-dismiss='alert' href='#'>&times;</a><div class='error_notification'>" + message + "</div></div>");
    },
	showErrors : function (target, errors) {
		for ( error in errors ) {
			var input = target.find('input[name*="'+ error + '"]');
			if(input.length) {
				input.closest('.control-group').addClass('error');
				input.after('<span class="help-inline">' + errors[error] + "</span>");
			}
		}
	},
    hideMessage : function(target) {
		that.find('.alert-error').remove();
    },
	hideErrors : function (target) {
		that.find('.control-group').removeClass('error');
		that.find('.help-inline').remove();
	},
	resetFields : function(that) {
		
	}
}