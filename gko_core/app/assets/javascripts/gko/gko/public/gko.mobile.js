$(document).bind("mobileinit",
    function () {
        $.extend($.mobile, {
            ajaxEnabled:false
        });
        //$.ajaxSetup({
        //    dataType: 'script'
        // });
    });
$(document).ready(function () {

    /*
     * IMPORTANT!!!
     * REMEMBER TO ADD  rel="external"  to your anchor tags.
     * If you don't this will mess with how jQuery Mobile works
     */

    (function (window, $, PhotoSwipe) {

        $(document).ready(function () {
            if ($("ul.images").length > 0) {
                $("ul.images a").photoSwipe();
            }
        });

    }(window, window.jQuery, window.Code.PhotoSwipe));

});	