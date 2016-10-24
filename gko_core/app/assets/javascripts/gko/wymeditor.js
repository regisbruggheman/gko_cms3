/*
 *= require ../wymeditor/gko_wymeditor
 *= require ../wymeditor/lang/fr
 *= require ../wymeditor/skins/gko/skin
 */

onOpenDialog = function(dialog) {
	dialog = $('.ui-dialog');
  if (dialog.height() < $(window).height()) {
    if(iframed()) {
      $(parent.document.body).addClass('hide-overflow');
    } else {
      $(document.body).addClass('hide-overflow');
    }
  }
};

onCloseDialog = function(dialog) {

  if(iframed()) {
    $(parent.document.body).removeClass('hide-overflow');
		window.parent.$('#dialog_iframe').remove();
		window.parent.$('.ui-dialog').remove();
  } else {
    $(document.body).removeClass('hide-overflow');
		$('#dialog_iframe').remove();
		$('.ui-dialog').remove();
		$('#dialog_frame').remove();
		$('#editor_dialog').remove();
  }
};

WYMeditor.onload_functions = [];
var wymeditor_inputs = [];
var wymeditors_loaded = 0;
// supply custom_wymeditor_boot_options if you want to override anything here.
if (typeof(custom_wymeditor_boot_options) == "undefined") {
	custom_wymeditor_boot_options = {}
} else {
	console.log("custom_wymeditor_boot_options")
}
var form_actions =
"<div id='dialog-form-actions'>"
	+ "<div class='form-actions'>"
    + "<input id='submit_button' class='wym_submit button btn primary' type='submit' value='{Insert}' />"
    + "<a href='' class='wym_cancel close_dialog button btn inline'>{Cancel}</a>"
  + "</div>"
+ "</div>";
var wymeditor_boot_options = $.extend({
  skin: 'gko'
  , basePath: "/"
  , wymPath: "/assets/wymeditor/gko_wymeditor.js"
  , cssSkinPath: "/assets/wym_skin/"
  , jsSkinPath: "/assets/wymeditor/skins/"
  , langPath: "/assets/wymeditor/lang/"
  , iframeBasePath: '/'
 	, classesItems: [
    //{ name: 'text-align', rules:[{name: 'left', title: '{Left}'}, {name: 'center', title: '{Center}'}, {name: 'right', title: '{Right}'}, {name: 'justify', title: '{Justify}'}], join: '-', title: '{Text_Align}'}
    //, {name: 'image-align', rules:[{name: 'left', title: '{Left}'}, {name: 'right', title: '{Right}'}], join: '-', title: '{Image_Align}'}
    //, {name: 'font-size', rules:[{name: 'small', title: '{Small}'}, {name: 'normal', title: '{Normal}'}, {name: 'large', title: '{Large}'}], join: '-', title: '{Font_Size}'}
  ]
  , containersItems: [
    //{'name': 'h1', 'title':'Heading_1', 'css':'wym_containers_h1'}
    {'name': 'h2', 'title':'Heading_2', 'css':'icon-picture'}
    ,{'name': 'h3', 'title':'Heading_3', 'css':'icon-picture'}
		,{'name': 'h4', 'title':'Heading_4', 'css':'icon-picture'}
    ,{'name': 'p', 'title':'Paragraph', 'css':'icon-picture'}
  ]
  , toolsItems: [
    {'name': 'Bold', 'title': 'Bold', 'css': 'icon-bold'}
    ,{'name': 'Italic', 'title': 'Emphasis', 'css': ' icon-italic'}
    ,{'name': 'InsertUnorderedList', 'title': 'Unordered_List', 'css': 'icon-list'}
    ,{'name': 'InsertOrderedList', 'title': 'Ordered_List', 'css': 'icon-th-list'}
		/*,{'name': 'Indent', 'title': 'Indent', 'css': 'icon-indent-left'}
    ,{'name': 'Outdent', 'title': 'Outdent', 'css': ' icon-indent-right'}
    ,{'name': 'Undo', 'title': 'Undo', 'css': 'wym_tools_undo'}
    ,{'name': 'Redo', 'title': 'Redo', 'css': 'wym_tools_redo'}*/
    //,{'name': 'CreateLink', 'title': 'Link', 'css': 'icon-external-link'}
    //,{'name': 'Unlink', 'title': 'Unlink', 'css': 'icon-picture'}
    ,{'name': 'InsertImage', 'title': 'Image', 'css': 'icon-picture'}
	//,{'name': 'InsertVideo', 'title': 'Video', 'css': 'icon-facetime-video'}
    ,{'name': 'InsertTable', 'title': 'Table', 'css': 'icon-th-large'}
    //,{'name': 'Paste', 'title': 'Paste_From_Word', 'css': 'wym_tools_paste'}
    //,{'name': 'ToggleHtml', 'title': 'HTML', 'css': ' icon-cog'}
  ]

  ,toolsHtml:
	"<div class='wym_tools wym_section wym_buttons btn-group'>"
		+ WYMeditor.TOOLS_ITEMS
	+ "</div>"
	+ "<div class='wym_tools wym_section wym_buttons btn-group'>"
	+ "<ul>"
		+ "<li class='dropdown'><button class='btn dropdown-toggle' data-toggle='dropdown'><i class='icon-share'></i><span class='caret'></span></button></button>"
			+ "<ul class='dropdown-menu'>"
				+ "<li><a href='#' name='" + WYMeditor.CREATE_LINK + "'>Ajouter un lien</a></li>"
				+ "<li class='divider'></li>"
				+ "<li><a href='#' name='" + WYMeditor.UNLINK + "'>Supprimer le Lien</a></li>"
			+ "</ul></li></ul>"
			+ "</div>"
			+ "<div class='wym_tools wym_section wym_buttons btn-group'><ul><a href='#' name='ToggleHtml' rel='tooltip' class='btn no-tooltip' title='HTML'><i class='icon-cog'></i></a></li></ul></div>"


  ,toolsItemHtml:
      "<a href='#' name='" + WYMeditor.TOOL_NAME + "' title='" + WYMeditor.TOOL_TITLE + "' rel='tooltip' class='btn no-tooltip'><i class='" + WYMeditor.TOOL_CLASS + "'></i></a>"
  // Classes html are broken !!!
  /*, classesHtml:
  	"<div class='wym_classes wym_section wym_buttons btn-group'><ul>"
		+ "<li class='dropdown'>"
			+ "<button class='btn dropdown-toggle' data-toggle='dropdown'><i class='icon-adjust'></i><span class='caret'></span></button>"
			+ "<ul class='dropdown-menu'>" + WYMeditor.CLASSES_ITEMS + "</ul>"
  	+ "</li></ul></div>"
	, classesItemHtml: "<li class='wym_classes_" + WYMeditor.CLASS_NAME + "'>"
                        + "<a href='#' name='" + WYMeditor.CLASS_NAME + "'>"
                          + WYMeditor.CLASS_TITLE
                        + "</a>"
                      +"</li>"
  , classesItemHtmlMultiple: "<li><span>" + WYMeditor.CLASS_TITLE + "</span><ul>{classesItemHtml}</ul></li>"*/

  , containersHtml:
	"<div class='wym_containers wym_section btn-group'><ul class='nav'>"
		+ "<li class='dropdown'><button class='btn dropdown-toggle' data-toggle='dropdown'><i class='icon-font'></i><span class='caret'></span></button>"
		+ "<ul class='dropdown-menu'>" + WYMeditor.CONTAINERS_ITEMS + "</ul>"
		+ "</li></ul></div>"
  , containersItemHtml:
		"<li><a href='#' name='"+ WYMeditor.CONTAINER_NAME + "'>"+ WYMeditor.CONTAINER_TITLE+ " ["+ WYMeditor.CONTAINER_NAME+"]</a></li>"

  , boxHtml:
	"<div class='wym_box'>"
  	+ "<div class='wym_area_top'>"
		+ "<div class='btn-toolbar'>"
     	+ WYMeditor.CONTAINERS
     	+ WYMeditor.TOOLS
     	//+ WYMeditor.CLASSES
		+ "</div>"
  		+ "</div>"
  		+ "<div class='wym_area_main'>"
     	+ WYMeditor.HTML
     	+ WYMeditor.IFRAME
     	+ WYMeditor.STATUS
   		+ "</div>"
 		+ "</div>"

  , iframeHtml:
    "<div class='wym_iframe wym_section'>"
     + "<iframe id='WYMeditor_" + WYMeditor.INDEX + "'" + ($.browser.msie ? " src='" + WYMeditor.IFRAME_BASE_PATH + "wymiframe'" : "")
     + " frameborder='0' marginheight='0' marginwidth='0' border='0'"
     + " onload='this.contentWindow.parent.WYMeditor.INSTANCES[" + WYMeditor.INDEX + "].loadIframe(this);'></iframe>"
    +"</div>"

  , dialogImageHtml: ""

  , dialogLinkHtml: ""

  , dialogTableHtml:
    "<div class='wym_dialog wym_dialog_table'>"
      + "<form class='form-horizontal'>"
        + "<input type='hidden' id='wym_dialog_type' class='wym_dialog_type' value='"+ WYMeditor.DIALOG_TABLE + "' />"
        + "<div class='control-group'>"
          + "<label for='wym_caption' class='control-label'>{Caption}</label>"
					+ "<div class='controls'>"
          	+ "<input type='text' id='wym_caption' class='wym_caption' value='' size='40' />"
					+ "</div>"
        + "</div>"
        + "<div class='control-group'>"
          + "<label for='wym_rows' class='control-label'>{Number_Of_Rows}</label>"
					 + "<div class='controls'>"
          	+ "<input type='text' id='wym_rows' class='wym_rows' value='3' size='3' />"
					+ "</div>"
        + "</div>"
        + "<div class='control-group'>"
          + "<label for='wym_cols' class='control-label'>{Number_Of_Cols}</label>"
					+ "<div class='controls'>"
          	+ "<input type='text' id='wym_cols' class='wym_cols' value='2' size='3' />"
        	 + "</div>"
        + "</div>"
        + form_actions
      + "</form>"
    + "</div>"

  , dialogPasteHtml:
    "<div class='wym_dialog wym_dialog_paste'>"
      + "<form class='form-horizontal'>"
        + "<input type='hidden' id='wym_dialog_type' class='wym_dialog_type' value='" + WYMeditor.DIALOG_PASTE + "' />"
        + "<div class='control-group'>"
          + "<textarea class='wym_text' rows='10' cols='50'></textarea>"
        + "</div>"
        + form_actions
      + "</form>"
    + "</div>"

  , dialogPath: "/admin/dialogs/"
  , dialogFeatures: {
	zIndex:1050 //same as boostrap modal
    , width: 866
    , height: 455
    , modal: true
    , draggable: true
    , resizable: false
    , autoOpen: true
    , open: onOpenDialog
    , close: onCloseDialog
  }
  , dialogInlineFeatures: {
    zIndex:1050 //same as boostrap modal
    , width: 600
    , height: 485
    , modal: true
    , draggable: true
    , resizable: false
    , autoOpen: true
    , open: onOpenDialog
    , close: onCloseDialog
  }

  , dialogId: 'editor_dialog'

  , dialogHtml:
    "<!DOCTYPE html>"
    + "<html dir='" + WYMeditor.DIRECTION + "'>"
      + "<head>"
        + "<link rel='stylesheet' type='text/css' media='screen' href='" + WYMeditor.CSS_PATH + "' />"
        + "<title>" + WYMeditor.DIALOG_TITLE + "</title>"
        + "<script type='text/javascript' src='" + WYMeditor.JQUERY_PATH + "'></script>"
        + "<script type='text/javascript' src='" + WYMeditor.WYM_PATH + "'></script>"
      + "</head>"
      + "<body>"
        + "<div id='page'>" + WYMeditor.DIALOG_BODY + "</div>"
      + "</body>"
    + "</html>"
  , postInit: function(wym)
  {
    // register loaded
    wymeditors_loaded += 1;

    // fire loaded if all editors loaded
    if(WYMeditor.INSTANCES.length == wymeditors_loaded){
      $('.wym_loading_overlay').remove();

      // load any functions that have been registered to happen onload.
      // these will have to be registered BEFORE postInit is fired (which is fairly quickly).
      for(i=0; i < WYMeditor.onload_functions.length; i++) {
        WYMeditor.onload_functions[i]();
      }
    }

    $(wym._iframe).contents().find('body').addClass('wym_iframe_body');

    $('.field.hide-overflow').removeClass('hide-overflow').css('height', 'auto');
  }
  , postInitDialog: function(wym) {
    if($.browser.msie) {
      ($the_ui_dialog = $('.ui-dialog')).css('height',
        $the_ui_dialog.find('iframe').height()
        + $the_ui_dialog.find('iframe').contents().find('.form-actions').height()
        - 12
      );
    }
  }
  , lang: (typeof(I18n.locale) != "undefined" ? I18n.locale : 'en')
}, custom_wymeditor_boot_options);

WYMeditor.editor.prototype.loadIframe = function(iframe) {
  var wym = this;

  // Internet explorer doesn't like this (which versions??)
  var doc = (iframe.contentDocument || iframe.contentWindow);
  if(doc.document) {
    doc = doc.document;
  }
  if (!$.browser.msie) {
    doc.open('text/html', 'replace');
    html = "<!DOCTYPE html>\
    <html>\
      <head>\
        <title>WYMeditor</title>\
        <meta charset='" + $('meta[charset]').attr('charset') + "' />\
        <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1' />\
      </head>\
      <body class='wym_iframe'>\
      </body>\
    </html>";
    doc.write(html);
    doc.close();

    var doc_head = doc.head || $(doc).find('head').get(0);
    $.each(["gko_wym"], function(i, href) {
      $("<link href='/assets/" + href + ".css?"+Math.random().toString().split('.')[1]+"' media='all' rel='stylesheet' />").appendTo(doc_head);
    });
  }
  if ((id_of_editor = wym._element.parent().attr('id')) != null) {
    $(doc.body).addClass(id_of_editor);
  }

  wym.initIframe(iframe);
};

WYMeditor.init = function() {

  wymeditor_inputs = $('.wymeditor').filter(function(index) {
    for (i=0; i < WYMeditor.INSTANCES.length; i++) {
      if (WYMeditor.INSTANCES[i]._element.attr('id') == $(this).attr('id')) {
        return false;
      }
    }

    return true;
  });

  wymeditor_inputs.each(function(input) {
    if ((containing_field = $(this).parents('.field')).length > 0 && containing_field.get(0).style.height.replace('auto', '') === '') {
      containing_field.addClass('hide-overflow')
                      .css('height', $(this).outerHeight() - containing_field.offset().top + $(this).offset().top + 45);
    }
	$(this).hide();
  });

  wymeditor_inputs.wymeditor(wymeditor_boot_options);
};

$(function(){
  WYMeditor.init();
});
