WYMeditor.SKINS['gko'] = {

    init:function (wym) {
        //render following sections as buttons
        $(wym._box).find(wym._options.toolsSelector)
            .addClass('wym_buttons');

        // auto add some margin to the main area sides if left area
        // or right area are not empty (if they contain sections)
        $(wym._box).find('div.wym_area_right ul')
            .parents('div.wym_area_right').show()
            .parents(wym._options.boxSelector)
            .find('div.wym_area_main')
            .css({'margin-right':'155px'});

        $(wym._box).find('div.wym_area_left ul')
            .parents('div.wym_area_left').show()
            .parents(wym._options.boxSelector)
            .find('div.wym_area_main')
            .css({'margin-left':'155px'});

        // show or hide CSS class options on hover
        $(wym._box).find('.wym_tools_class')
            .hover($.proxy(function () {
            this.toggleClassSelector();
        }, wym), $.proxy(function () {
            this.toggleClassSelector();
        }, wym));

        $(".wym_skin_gko").animate({
            opacity:1
        }, 800);
    }
};
