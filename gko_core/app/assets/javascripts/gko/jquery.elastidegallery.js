//= require gko/externals/jquery.easing.1.3
//= require gko/externals/jquery.imagesloaded
//= require gko/externals/jquery.elastislide
var current = 0, // index of the current item
    anim = false, // control if one image is being loaded
    $rgGallery = $('.images:first'),
    $esCarousel,
    $items,
    thumbWidth = 156,
    itemsCount = 0;
$(function () {


    Gallery = (function () {

        init = function (tag, thumbW) {
            // gallery container
            //	$rgGallery = tag;
            //console.log('vvv ' + $rgGallery)

            if (typeof(thumbW) != 'undefined') {
                thumbWidth = thumbW;
            }

            // carousel container
            $esCarousel = $rgGallery.find('div.images-thumbnails-container');
            // the carousel items
            $items = $esCarousel.find('a');
            // total number of items
            itemsCount = $items.length;
            // (not necessary) preloading the images here...
            //$items.add('<img src="images/ajax-loader.gif"/><img src="images/black.png"/>')
            $items.imagesLoaded(function () {
                var list = $esCarousel.find($('ul')),
                    list_width = list.width(),
                    carrousel_width = $esCarousel.width();
                if (carrousel_width > list_width) {
                    list.css({width:list_width})
                }
                // add options
                // add large image wrapper
                _addImageWrapper();
                // show first image
                _showImage($items.eq(current));
            });

            // initialize the carousel
            if (itemsCount > 1) {
                _initCarousel();
            }

        },
            _initCarousel = function () {
                // we are using the elastislide plugin:
                // http://tympanus.net/codrops/2011/09/12/elastislide-responsive-carousel/
                $esCarousel.show().elastislide({
                    imageW:156,
                    onClick:function ($item) {
                        if (anim) return false;
                        anim = true;
                        // on click show image
                        _showImage($item.find('a'));
                        // change current
                        current = $item.index();
                    }
                });

                // set elastislide's current to current
                $esCarousel.elastislide('setCurrent', current);

            },
            _addImageWrapper = function () {
//console.log('xxx ' + $rgGallery)
                // initializes the navigation events
                // addNavigation
                var $navPrev = $rgGallery.find('a.image-large-nav-prev'),
                    $navNext = $rgGallery.find('a.image-large-nav-next'),
                    $imgWrapper = $rgGallery.find('div.image-large');

                if (itemsCount > 1) {

                    $navPrev.bind('click.rgGallery', function (event) {
                        _navigate('left');
                        return false;
                    });

                    $navNext.bind('click.rgGallery', function (event) {
                        _navigate('right');
                        return false;
                    });

                    // add touchwipe events on the large image wrapper
                    $imgWrapper.touchwipe({
                        wipeLeft:function () {
                            _navigate('right');
                        },
                        wipeRight:function () {
                            _navigate('left');
                        },
                        preventDefaultEvents:false
                    });

                    $(document).bind('keyup.rgGallery', function (event) {
                        if (event.keyCode == 39)
                            _navigate('right');
                        else if (event.keyCode == 37)
                            _navigate('left');
                    });

                }
                else {
                    $navPrev.css('display', 'none');
                    $navNext.css('display', 'none');
                }

            },
            _navigate = function (dir) {

                // navigate through the large images
                if (anim) return false;
                anim = true;

                if (dir === 'right') {
                    if (current + 1 >= itemsCount)
                        current = 0;
                    else
                        ++current;
                }
                else if (dir === 'left') {
                    if (current - 1 < 0)
                        current = itemsCount - 1;
                    else
                        --current;
                }
                _showImage($items.eq(current));
            },
            _showImage = function ($item) {
                // shows the large image that is associated to the $item
                var $loader = $rgGallery.find('div.image-large-loader').show();
                $items.removeClass('selected');
                $item.addClass('selected');
                var $thumb = $item.find('img'),
                    largesrc = $thumb.parent().attr('href'),
                    title = $thumb.data('description');

                $('<img/>').load(
                    function () {
                        $rgGallery.find('div.image-large').empty().append('<img src="' + largesrc + '"/>');
                        // if (title)
                        // $rgGallery.find('div.rg-caption').show().children('p').empty().text(title);
                        $loader.hide();
                        $esCarousel.elastislide('reload');
                        $esCarousel.elastislide('setCurrent', current);
                        anim = false;
                    }).attr('src', largesrc);

            };

        return {
            init:init
        };

    })();


});