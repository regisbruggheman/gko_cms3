/*
 //= require jquery
 //= require jquery_ujs
 //= require jquery-ui-1.8.18.custom.min
 //= require jquery.color.js
 //= require bootstrap-colorpicker.js
 //= require less
 //= require theme_roller
 */

$(document).ready(function () {

    var $tab = $("#properties-accordion");
    var refresh_less = true;
    var sheet;
    var new_sheet;
    var roller;
    var ifrm;
    var variables;


    gradienter = function (color_start, color_end, count) {
        var colors = ["black", "grayDarker", "grayDark", "gray", "grayLight", "grayLighter", "white"];

        var r = g = b = er = eg = eb = sr = sg = sb = 0;

        r = sr = parseInt(color_start.substring(0, 2), 16);
        g = sg = parseInt(color_start.substring(2, 4), 16);
        b = sb = parseInt(color_start.substring(4, 6), 16);

        er = parseInt(color_end.substring(0, 2), 16);
        eg = parseInt(color_end.substring(2, 4), 16);
        eb = parseInt(color_end.substring(4, 6), 16);

        $.each(colors, function (i, item) {
            if (i == 0) {
                changeVariableValue(item, 'rgb(' + sr + ',' + sg + ',' + sb + ')');
            } else {
                r -= parseInt((sr - er) / i);
                g -= parseInt((sg - eg) / i);
                b -= parseInt((sb - eb) / i);
                changeVariableValue(item, 'rgb(' + r + ',' + g + ',' + b + ')');
            }
        });
    };


    //$("a[data-remote], form[data-remote]")
//	.bind("ajax:beforeSend", function(event, xhr, settings) {attachLoading("body");})
//	.bind("ajax:complete", function(event, xhr, status){removeLoading("body")});


    addStyleToFrame = function (newStyle) {
        var css = '';

        /*
         * Lets less generate styles
         */
        new (less.Parser)().parse(newStyle, function (e, tree) {
            css = tree.toCSS();
        });
        /*
         * Get iframe's document
         */
        if (typeof ifrm == "undefined") {
            ifrm = document.getElementById('frame');
            if (ifrm.contentWindow) {
                ifrm = ifrm.contentWindow;
            } else {
                if (ifrm.contentDocument.document) {
                    ifrm = ifrm.contentDocument.document;
                } else {
                    ifrm = ifrm.contentDocument;
                }
            }
        }
        /*
         * Now that we have the document, look for an existing style tag
         */
        var tag = ifrm.document.getElementById("less:tmp_styles");

        /*
         * Hmm, this doesn't look right, but it is. IE will not allow you
         * to use a pre-existing style tag and set the innerHTML for that
         * element. Which means, we can't create the style tag in another
         * function and pass back the element and then set the innerHTML
         * to what we need. Plus, with this limitation, now we need to
         * actually remove the style element from the DOM and recreate
         * it each time. LAME.
         */
        if (typeof tag != "undefined" || tag != null) {
            $("#tmp_styles", ifrm.document).remove();
        }
        /*
         * We only have one shot at writing out the style tag, we must
         * include the css at that point as well or IE will bail with an
         * unsuported method exception.
         */
        $("HEAD", ifrm.document).append('<style type="text/css" media="screen" id="less:tmp_styles">' + css + '</style>');

        new_sheet = css;
    }

    refreshTheme = function () {
        var variables = roller.themeroller('getLessVariables');
        //console.log(variables);
        $("#tab-css-content").html(new_sheet);
        $("#tab-less-content").html(variables);
        $("#tab-sass-content").html(variables);
        addStyleToFrame(variables + "\n" + sheet);
    }

    changeVariableValue = function (name, value, type, target) {
        console.log("name: " + name + " - value: " + value);
        if (!refresh_less) {
            $("iframe").contents().find(target).css(name, value);
        } else {
            roller.themeroller('setVariable', '@' + name, value);
            refreshTheme();
        }
    }

    loadIframe = function (url) {
        $("iframe").attr('src', url);
    }

    init_theme = function () {
        //    $("[data-type=background-color], [data-type=color]" ).bind("blur mouseup change keyup", function(event) {
        //       var color = $( this ).val();
        //       var type = $( this ).attr( "data-type" );
        //		var target = $( this ).attr("data-target");
        //		console.log("color: " + color + " - target: " + target + " - type: " + type);
        //$("iframe").contents().find(target).css( type, color );
        //		changeVariableValue(type, color);
        //  });

        //	$("[data-type=link]" ).bind("blur mouseup change keyup", function(event) {
        //		var color = $( this ).val();
        //		var type = $( this ).attr( "data-type" );
        //		var target = "a";
        //		console.log("color: " + color + " - target: " + target + " - type: " + type);
        //		$("iframe").contents().find(target).css( "color", color );
        //	});
  
        variables = [
            set_variable('black', '#000', '.caret '),
            set_variable('white', '#000')
        ]
        $.each(variables, function (val, o) {
            for (i in o) {
                console.log(i + " : " + o[i])
            }
        });


    }

    set_variable = function (name, value, type, target) {
        return {
            'name':name,
            'value':value,
            'type':type,
            'target':target
        }
    }

    set_target = function (element, property) {
        return {
            'element':element,
            'property':property
        }
    }

    render_result = function () {
        console.log("booo")
        $("#result-modal").modal('show');
    }

    changeGradient = function (target, start, end) {
        t = $("iframe").contents().find(target);
        t.css({
            "background-image":"-moz-linear-gradient(top, " + start + ", #" + end + ")"
        });
        t.css({
            "background-image":"-webkit-gradient(linear, 0 0, 0 100%, from(" + start + "), to(" + end + "))"
        });
        t.css({
            "background-image":"-webkit-linear-gradient(top, " + start + ", " + end + ")"
        });
        t.css({
            "background-image":"-ms-linear-gradient(top, " + start + ", " + end + ")"
        });
        t.css({
            "background-image":"-o-linear-gradient(top, " + start + ", " + end + ")"
        });
        t.css({
            "background-image":"linear-gradient(top, " + start + ", " + end + ")"
        });
        t.css({
            filter:"progid:DXImageTransform.Microsoft.gradient(startColorstr=" + start + ", endColorstr=" + end + ", GradientType=0)"
        })
    }

    //##########################################################
    // javascript build logic
    //    var inputsVariables = $("#variables.download input")

    //    $('#variables.download .toggle-all').on('click', function (e) {
    //      e.preventDefault()
    //      inputsVariables.val('')
    //    })


    $("a#toogle-panel-btn").click(function () {
        $tab.toggle("fast");
        $(this).toggleClass("active");
        return false;
    });


    $("a#finish-and-save-btn").click(function () {
        console.log("booo btn");
        render_result();
        return false;
    });
    $("a#load-theme").bind("ajax:complete", function (event, xhr, status) {
        sheet = xhr.responseText;
        roller = $('body').themeroller({css:sheet});
        //roller.themeroller('setVariable', '@white', 'red');
        //gradienter("FE3627","590512");
        changeVariableValue('white', '#fff');
    });


    //var style = $('<style>' + t.themeroller('getCss') + '</style>')
    //$("iframe").contents().find('head').append(style);

    $("[data-link]").bind("click", function (event) {
        console.log("click: " + $(this).attr("data-link"));
        loadIframe($(this).attr("data-link"));
    });


    // Slider
    $(".slider").slider({
        min:0,
        max:100,
        step:1
    });

    //Radius range of values
    $(".slider[data-type=radius]").slider("option", {
        max:2,
        step:.1
    });

    //Padding range of values
    $(".slider[data-type=padding], .slider[data-type=margin]").slider("option", {
        min:-300,
        max:300,
        step:1
    });

    // Padding Margin
    $(".slider.sizer").on("change slide mouseup", function () {
        var $this = $(this),
            name = $this.attr("data-name"),
            type = $this.attr("data-type"),
            target = $this.attr("data-target"),
            unit = $this.attr("data-unit"),
            value = $this.slider("value") + unit,
            input = $("input[data-type=" + type + "][data-name=" + name + "]");
        input.val(value);
        changeVariableValue(name, value, type, target);
    });

    //Font Family
    $("[data-type=font-family]").bind("blur change keyup", function () {
        var name = $(this).attr("data-name"),
            target = $this.attr("data-target");
        changeVariableValue(name, value, 'font-family', target);
    });

    //Corner Radius input
    $("input[data-type=radius]").on("change keyup mouseup", function () {
        var $this = $(this),
            name = $this.attr("data-name"),
            target = $this.attr("data-target"),
            slider = $(".slider[data-type=radius][data-name=" + name + "]"),
            value = parseFloat($this.val().replace(/[^0-9\.]/g, ""));
        slider.slider("value", value);
        changeVariableValue(name, value + "em", 'border-radius', target);
    });

    //Corner Radius slider
    $(".slider[data-type=radius]").on("change slide mouseup", function () {
        var $this = $(this),
            name = $this.attr("data-name"),
            target = $this.attr("data-target"),
            input = $("input[data-type=radius][data-name=" + name + "]"),
            value = $this.slider("value") + "em";
        input.val(value);
        changeVariableValue(name, value, 'border-radius', target);
    });

    // Simple color
    $('.color').colorpicker().on('changeColor', function (ev) {
        var $this = $(this),
            name = $this.attr("data-name"),
            type = $this.attr("data-type"),
            target = $this.attr("data-target"),
            unit = $this.attr("data-unit"),
            value = ev.color.toHex(),
            input = $("input[data-name=" + name + "][data-type=" + type + "]");
        if (typeof name != "undefined") {
            changeVariableValue(name, ev.color.toHex(), type, target);
        } else {
            console.log("name is undefined");
        }
    });

    // Gradient color
    $('.gradient').colorpicker().on('changeColor', function (ev) {
        var $this = $(this),
            name = $this.attr("data-name"),
            type = $this.attr("data-type"),
            target = $this.attr("data-target"),
            unit = $this.attr("data-unit"),
            value = ev.color.toHex(),
            input = $("input[data-name=" + name + "][data-type=" + type + "]");
        //input.val( value );

        changeGradient(target, ev.color.toHex(), ev.color.toHex());
    });

    $("a.more").on("click", function (ev) {
        var $this = $(this),
            href = $this.attr("href");

        $("div" + href).toggle();
    })

});
   

