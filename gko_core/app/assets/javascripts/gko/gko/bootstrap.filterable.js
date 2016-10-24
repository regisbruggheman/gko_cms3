var values = []
function init_categories_filters() {

    // Setting up our variables
    var $filterList = $('.games-categories .nav-list');
    var $filter = 'all';
    // Set our filter
    var $container = $('ul.grid');
    var $filterable_items;

    $filterList.prepend($("<li id='all' class='filterable active'><a href='#'>Toutes</a></li>"));

    // Adding a data-id attribute. Required by the Quicksand plugin:
    $container.find('li.filterable').each(function (i) {
        $(this).attr('data-id', i);
    });

    // Clone our container
    $containerClone = $container.clone();

    // Store elements that have tags
    $filterable_items = $containerClone.find('li[data-tags*=]');

    // Apply our Quicksand to work
    $('#sidebar li.filterable a').on('click',
        function (e) {
            //	e.stopPropagation();
            //	e.preventDefault();

            var li = $(this).parent()
                , id = li.attr('id')
                , ul = li.parent()
                , actives = []
                , result = [];

            if (ul.hasClass('dropdown-menu')) {
                //console.log('dropdown-menu ' + ul.parent(".nav-list"))
                //var index = $("#tabs ul li").index($("li a[href='#All']"))
                ul.parent(".nav-list").css("font-size", 40)
            }

            // toogle the 'active' class to the clicked link
            li.toggleClass('active');
            actives = ul.find('li.active');
            if (id == 'all' || actives.length == 0) {
                actives.each(function () {
                    $(this).removeClass('active');
                })
                ul.find('li#all').addClass('active');
                result = $containerClone.find('li.filterable');
            }
            else {
                ul.find('li#all').removeClass('active');
                values = []
                actives.each(function () {
                    values.push($(this).attr('id').toLowerCase());
                })
                $filterable_items.each(function () {
                    var elm = $(this)
                        , tags = elm.data('tags')
                        , presence = false;
                    values.map(function (tag, ind) {
                        $.grep(tags, function (item_tag) {
                            if (~item_tag.toLowerCase().indexOf(tag)) {
                                presence = true;
                            }
                        })
                    })
                    if (presence) {
                        result.push(elm[0]);
                    }
                })
            }


            // Finally call the Quicksand function
            $container.quicksand(result,
                {
                    // The duration for the animation
                    duration:750,
                    // The easing effect when animating
                    easing:'easeInOutCirc',
                    // Height adjustment set to dynamic
                    adjustHeight:'dynamic'
                });
        });
}