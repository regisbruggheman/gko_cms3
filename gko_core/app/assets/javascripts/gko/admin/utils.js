
//parse a URL to form an object of properties
parseURL = function (url) {
    //save the unmodified url to href property
    //so that the object we get back contains
    //all the same properties as the built-in location object
    var loc = {
        'href':url
    };

    //split the URL by single-slashes to get the component parts
    var parts = url.replace('//', '/').split('/');

    //store the protocol and host
    loc.protocol = parts[0];
    loc.host = parts[1];

    //extract any port number from the host
    //from which we derive the port and hostname
    parts[1] = parts[1].split(':');
    loc.hostname = parts[1][0];
    loc.port = parts[1].length > 1 ? parts[1][1] : '';

    //splice and join the remainder to get the pathname
    parts.splice(0, 2);
    loc.pathname = '/' + parts.join('/');

    //extract any hash and remove from the pathname
    loc.pathname = loc.pathname.split('#');
    loc.hash = loc.pathname.length > 1 ? '#' + loc.pathname[1] : '';
    loc.pathname = loc.pathname[0];

    //extract any search query and remove from the pathname
    loc.pathname = loc.pathname.split('?');
    loc.search = loc.pathname.length > 1 ? '?' + loc.pathname[1] : '';
    loc.pathname = loc.pathname[0];

    //return the final object
    return loc;
}

iframed = function () {
    return (parent && parent.document.location.href != document.location.href && $.isFunction(parent.$));
};

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