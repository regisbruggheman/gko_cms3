var iframe;
var idocument;
function init_theme_preview() {
	iframe = document.getElementById("preview");
	idocument = iframe.contentWindow.document || iframe.contentDocument;
	
	var vars = [], hash;
	var q = document.URL.split('?')[1];
	if(q != undefined){
		q = q.split('&');
		for(var i = 0; i < q.length; i++){
			hash = q[i].split('=');
			vars.push(hash[1]);
			vars[hash[0]] = hash[1];
		}
	}
	if(vars['theme'] != undefined) {
		$("#preview").contents().find('a[href]').attr('href', function(index, href) {
			var result = replaceOrAddParam(href, /theme=[^&^$]+/i, "theme="+vars['theme']);
			console.log(result)
			return result;
		});
	}
}

function replaceOrAddParam(str, pattern, newValue) {
	if (str.match(pattern)) {
		// parameter is already defined
    	return(str.replace(pattern, newValue));
   	}
	else if (str.indexOf("?") != -1) {
    	// query string exists, but without this parameter
		return(str + "&" + newValue);
	}
	else {
		// there is no query string
    	return(str + "?" + newValue);
	}
}
function fix_height(){
        var h = $("#tray").height();   
        $("#preview").css("height", (($(window).height()) - h) + "px");
}

$(document).ready(function() {



    $(window).resize(function(){ fix_height(); }).resize();
    //$("#preview").contentWindow.focus();
	
	 $("#themes-list").change(function() { 
		var value = $(this).val();
		window.location.href =  replaceOrAddParam(document.URL, /theme=[^&^$]+/i, "theme="+value);
	 });


})