if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.ImageBrowser = {
	init: function()
	{
     $.extend( $.Redactor.opts,
     {
       imageBrowserUrl: false, // url (ex. /folder/images.json ) or false 
     });
     
     this.buttonAdd('image_browser', 'browserShow',$.proxy(function()
    {
      this.browserShow();
    }, this));
	},
	
  // IMAGE
	browserShow: function()
	{
    $.ajax({ 
      url: this.opts.imageBrowserUrl,
      dataType: "html",
      success: function(data){
        console.log(data) 
        $("body").append(data);
      } 
    }),

		this.selectionSave();

		var callback = $.proxy(function()
		{
			// json
			if (this.opts.imageGetJson)
			{  
			     
				$.getJSON(this.opts.imageGetJson, $.proxy(function(data)
				{
					var folders = {}, count = 0;

					// folders
					$.each(data, $.proxy(function(key, val)
					{
						if (typeof val.folder !== 'undefined')
						{
							count++;
							folders[val.folder] = count;
						}

					}, this));

					var folderclass = false;
					$.each(data, $.proxy(function(key, val)
					{
						// title
						var thumbtitle = '';
						if (typeof val.title !== 'undefined') thumbtitle = val.title;

						var folderkey = 0;
						if (!$.isEmptyObject(folders) && typeof val.folder !== 'undefined')
						{
							folderkey = folders[val.folder];
							if (folderclass === false) folderclass = '.redactorfolder' + folderkey;
						}

						var img = $('<img src="' + val.thumb + '" class="redactorfolder redactorfolder' + folderkey + '" rel="' + val.image + '" title="' + thumbtitle + '" />');
						$('#images-container').append(img);
						$(img).click($.proxy(this.imageThumbClick, this));

					}, this));

					// folders
					if (!$.isEmptyObject(folders))
					{
						$('.redactorfolder').hide();
						$(folderclass).show();

						var onchangeFunc = function(e)
						{
							$('.redactorfolder').hide();
							$('.redactorfolder' + $(e.target).val()).show();
						};

						var select = $('<select id="images-container_select">');
						$.each( folders, function(k, v)
						{
							select.append( $('<option value="' + v + '">' + k + '</option>'));
						});

						$('#images-container').before(select);
						select.change(onchangeFunc);
					}
				}, this));

			}
			else
			{
				$('#li_redactor_tab2').remove();
			}

			if (this.opts.imageUpload || this.opts.s3)
			{
				  
				// dragupload
				if (!this.isMobile() && this.opts.s3 === false)
				{
					if ($('#redactor_file' ).length)
					{
						this.draguploadInit('#redactor_file', {
							url: this.opts.imageUpload,
							uploadFields: this.opts.uploadFields,
							success: $.proxy(this.imageCallback, this),
							error: $.proxy(function(obj, json)
							{
								this.callback('imageUploadError', json);

							}, this)
						});
					}
				}

				if (this.opts.s3 === false)
				{
					// ajax upload
					this.uploadInit('redactor_file', {
						auto: true,
						url: this.opts.imageUpload,
						success: $.proxy(this.imageCallback, this),
						error: $.proxy(function(obj, json)
						{
							this.callback('imageUploadError', json);

						}, this)
					});
				}
				// s3 upload
				else
				{
					$('#redactor_file').on('change.redactor', $.proxy(this.s3handleFileSelect, this));
				}

			}
			else
			{
				$('#li_redactor_tab1').remove();
				if (!this.opts.imageGetJson)
				{
					$('#li_redactor_tab2').remove();
					$('#li_redactor_tab3').show();
				}
				else
				{
					$('#li_redactor_tab1').remove();
					$('#li_redactor_tab2').addClass('active');
					$('#li_redactor_tab3').show();
					
				}
			}

			$('#redactor_upload_btn').click($.proxy(this.imageCallbackLink, this));

			if (!this.opts.imageUpload && !this.opts.imageGetJson)
			{
				setTimeout(function()
				{
					$('#redactor_file_link').focus();

				}, 200);
			}

		}, this);
		
    this.modalInit('Browser', '#imagebrowsermodal', $(document).width() - 60, callback);

	}
};

