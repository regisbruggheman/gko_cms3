////////////////////////////////////////////////////////////////////////
// Drag and Drop Image on Folder
////////////////////////////////////////////////////////////////////////
dnd_join_list = function (source, target, insert_url) {
  // ajoute la propriété pour le drop et le transfert de données
	$.event.props.push('dataTransfer');
	if (Modernizr.draganddrop) {
		// Using HTML5 drag and want to drop into an element not visible in the viewport,
		// it is not possible on most browsers. On Google Chrome you can. Moving the dragged element
		// near the top or bottom of the viewport will scroll the page. But other browsers don't do
		// that. With this dndPageScroll jQuery plugin, you can.
		$().dndPageScroll();
		target.find("li").each(function () {
			$(this).attr("draggable","true")
		});
		target.on({
			// to get IE to work
			dragenter: function(e) {
				e.stopPropagation();
				e.preventDefault();
			    $(this).toggleClass('dragover');
		    },
		    dragover: function(e) {
				e.stopPropagation();
				e.preventDefault();
		    	e.dataTransfer.dropEffect = 'copy';
		    },
			dragleave: function(e) {
				e.stopPropagation();
				e.preventDefault();
				$(this).toggleClass('dragover');
		    },
		    drop: function(e) {
				e.stopPropagation();
				e.preventDefault();

				var $this = $(this),
					data = e.dataTransfer.getData("Text"),
					image_id = get_number_from_string(data),
					folder_id = get_number_from_string($this.attr("id"));
					
				$this.removeClass('dragover');

				jQuery.ajax({
                    type:'POST',
                    url: insert_url,
                    data:{
						image_id: image_id, 
						id: folder_id },
                    dataType:'script',
                    beforeSend:function (xhr) {
                        attachLoading("body");
                    },
                    error:function (xhr, status, error) {
                        alert(error);
                    },
                    complete:function (xhr, status) {
                        removeLoading("body");
                    }
                });//jQuery.ajax
		    },
		}, 'li')
		source.on({
		    dragstart: function(e) {
		        var $this = $(this);
		        $this.css('opacity', '0.5');
				e.dataTransfer.effectAllowed = 'copy'; // only dropEffect='copy' will be dropable
				e.dataTransfer.setData('text/plain', $this.attr('id'));// required otherwise doesn't work
		    },
		    dragend: function(e) {
				e.stopPropagation();
				e.preventDefault();
				$(this).css('opacity', '1');
		    },
		}, 'li')
	} else {
	  // Fallback to a library solution.
	}	
}
