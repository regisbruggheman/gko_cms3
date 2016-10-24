// Never Tested !!!
setActiveLink = function () {
    var url = window.location.pathname,
        urlRegExp = new RegExp(url.replace(/\/$/, '') + "$"); // create regexp to match current url pathname and remove trailing slash if present as it could collide with the link in navigation in case trailing slash wasn't present there
    // now grab every link from the navigation
    $('.menu a').each(function () {
        // and test its normalized href against the url pathname regexp
        if (urlRegExp.test(this.href.replace(/\/$/, ''))) {
            $(this).addClass('active');
        }
    });
}
// Never Tested !!!
setActiveLink2 = function () {
    var pathname = window.location.pathname;
    var pathname = pathname.split('/');
    var tester = pathname[pathname.length - 1];

    $('#sidebar1 a').each(function () {
        var test = $(this).attr('href');
        if (test == tester) {
            $(this).addClass('active');
        }
    });
}
/**
 * Adds a loading animation in to the specified container.
 */
attachLoading = function (cont, msg, dur, callback) {
    if (typeof(cont) == "undefined") {
        cont = "body";
    }
    container = $(cont);
    if (typeof(callback) == "undefined") {
        callback = function () {};
    }
    if (typeof(dur) == "undefined") {
        dur = 500;
    }
    if (typeof(msg) == "undefined") {
        msg = "Please wait...";
    }
    loader = $(cont + ' .gko-loader');
    if (loader.length > 0) {
        loader.fadeIn(callback);
    }
    else {
        container.append("<div class='gko-loader'><div class='progress progress-striped active'><div class='bar' style='width: 100%;'></div></div></div>");
        loader = $(cont + ' .loader');
        loader.css({
            'z-index':10000,
            'top':100
        });
        loader.hide().fadeIn(dur, callback);

    }
    $('html').addClass("loading");
}

/**
 * Removes loading animation from page. Invokes the callback function once
 * completed.
 */
removeLoading = function (cont, dur, callback) {
    if (typeof(cont) == "undefined") {
        cont = "body";
    }
    if (typeof(dur) == undefined) {
        dur = 500;
    }
    if (typeof(callback) == 'undefined') {
        callback = function () {
            $(this).remove();
        };
    }

    $(cont + ' .gko-loader').fadeOut(dur, callback);
    $('html').removeClass("loading");
}
// parse anything into a number
parseValue = function (val) {
    if (typeof val === 'number') {
        return val;
    } else if (typeof val === 'string') {
        var arr = val.match(/\-?\d/g);
        return arr && arr.constructor === Array ? parseInt(arr.join(''), 10) : 0;
    } else {
        return 0;
    }
}
timestamp = function () {
    return new Date().getTime();
}
get_number_from_string = function (str) {
    return str.replace(/[^\d]+/g, '');
}
/* Get the screen size depending of screen orientation */
getScreenSize = function () {
    var orientation = (window.innerHeight > window.innerWidth) ? "landscape" : "portrait",
        port = orientation === "portrait",
        winHeightMin = port ? 480 : 320,
        winWidthMin = port ? 320 : 480,
        screenHeight = port ? screen.availHeight : screen.availWidth,
        screenWidth = port ? screen.availWidth : screen.availHeight,
        winHeight = Math.max(winHeightMin, $(window).height()),
        winWidth = Math.max(winWidthMin, $(window).width()),
        pageSize = {
            width:Math.min(screenWidth, winWidth),
            height:Math.min(screenHeight, winHeight)
        };
    return pageSize;
}
centerDialog = function (el) {
    var obj = $(el);
    var screenSize = gecko.getScreenSize();
    var halfsc = screenSize.height / 2;
    var halfh = $(el).height() / 2;

    var halfscrn = screenSize.width / 2;
    var halfobj = $(el).width() / 2;

    var goRight = halfscrn - halfobj;
    var goBottom = halfsc - halfh;

    $(el).css({
        left:goRight
    }).css({
            top:goBottom
        });
}