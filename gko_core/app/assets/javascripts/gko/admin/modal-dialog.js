// Init modal dialog
// Dialog are used by wymeditor and without wymeditor for images and page links
init_modal_dialogs = function () {
	$('a[href*="dialog=true"]').not('#dialog_container a').each(function (i, anchor) {
	//$('a[href*="dialog=true"]').each(function (i, anchor) {
        $(anchor).data({
            'dialog-width':parseInt($($(anchor).attr('href').match("width=([0-9]*)")).last().get(0), 10) || 928, 'dialog-height':parseInt($($(anchor).attr('href').match("height=([0-9]*)")).last().get(0), 10) || 473, 'dialog-title':($(anchor).attr('title') || $(anchor).attr('name') || $(anchor).html() || null)
        }).attr('href', $(anchor).attr('href').replace(/(\&(amp\;)?)?dialog\=true/, '')
            .replace(/(\&(amp\;)?)?width\=\d+/, '')
            .replace(/(\&(amp\;)?)?height\=\d+/, '')
            .replace(/(\?&(amp\;)?)/, '?')
            .replace(/\?$/, ''))
            .on('click', function (e) {
				e.preventDefault();
                $anchor = $(this);
                iframe_src = (iframe_src = $anchor.attr('href'))
                    + (iframe_src.indexOf('?') > -1 ? '&' : '?')
                    + 'dialog=true';

                iframe = $("<iframe id='dialog_iframe' frameborder='0' marginheight='0' marginwidth='0' border='0' width='100%' height='100%' class='row-fluid'></iframe>");
				
		
                var screenSize = getScreenSize(),
                    w = Math.min(screenSize.width, 980),
                    h = Math.min(screenSize.height - 100, 980),
                    type = $(anchor).data('dialog-type');

                //console.log('type ' + screenSize.width)
                if (type == 'images') {
                    $anchor.data('dialog-width', screenSize.width);
                    w = screenSize.width;
                }

                iframe.dialog({
                    title:$anchor.data('dialog-title') 
					, zIndex:1050 //same as boostrap modal 
					, modal:true
					, resizable:true
					, autoOpen:true
					, width:screenSize.width
					, height: h
					, open:onOpenDialog // @see boot_wym
					, close:onCloseDialog // @see boot_wym
                });

                iframe.attr('src', iframe_src);
            });
    });
};