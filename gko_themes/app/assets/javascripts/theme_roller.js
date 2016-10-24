(function ($) {

    $.widget("ui.themeroller", {
        options:{
            variables:{
                '@black':"#000", '@grayDarker':"#222", '@grayDark':"#333", '@gray':"#555", '@grayLight':"#999", '@grayLighter':"#eee", '@white':"#fff"
                // Accent colors
                // -------------------------, '@blue':"#049cdb", '@blueDark':"#0064cd", '@green':"#46a546", '@red':"#9d261d", '@yellow':"#ffc40d", '@orange':"#f89406", '@pink':"#c3325f", '@purple':"#7a43b6"
                // Scaffolding
                // -------------------------, '@bodyBackground':"@white", '@textColor':"@grayDark"
                // Links
                // -------------------------, '@linkColor':"#08c", '@linkColorHover':"darken(@linkColor, 15%)"
                // Typography
                // -------------------------, '@baseFontSize':"13px", '@baseFontFamily':'"Helvetica Neue", Helvetica, Arial, sans-serif', '@baseLineHeight':"18px", '@altFontFamily':'Georgia, "Times New Roman", Times, serif', '@headingsFontFamily':"inherit" // empty to use BS default, @baseFontFamily, '@headingsFontWeight':"bold"    // instead of browser default, bold, '@headingsColor':"inherit" // empty to use BS default, @textColor
                // Tables
                // -------------------------, '@tableBackground':"transparent" // overall background-color, '@tableBackgroundAccent':"#f9f9f9" // for striping, '@tableBackgroundHover':"#f5f5f5" // for hover, '@tableBorder':"#ddd" // table and cell border
                // Buttons
                // -------------------------, '@btnBackground':"@white", '@btnBackgroundHighlight':"darken(@white, 10%)", '@btnBorder':"darken(@white, 20%)", '@btnPrimaryBackground':"@linkColor", '@btnPrimaryBackgroundHighlight':"spin(@btnPrimaryBackground, 15%)", '@btnInfoBackground':"#5bc0de", '@btnInfoBackgroundHighlight':"#2f96b4", '@btnSuccessBackground':"#62c462", '@btnSuccessBackgroundHighlight':"#51a351", '@btnWarningBackground':"lighten(@orange, 15%)", '@btnWarningBackgroundHighlight':"@orange", '@btnDangerBackground':"#ee5f5b", '@btnDangerBackgroundHighlight':"#bd362f", '@btnInverseBackground':"@gray", '@btnInverseBackgroundHighlight':"@grayDarker"
                // Forms
                // -------------------------, '@inputBackground':"@white", '@inputBorder':"#ccc", '@inputDisabledBackground':"@grayLighter"
                // Dropdowns
                // -------------------------, '@dropdownBackground':"@white", '@dropdownBorder':"rgba(0,0,0,.2)", '@dropdownLinkColor':"@grayDark", '@dropdownLinkColorHover':"@white", '@dropdownLinkBackgroundHover':"@linkColor"
                // Z-index master list
                // -------------------------, '@zindexDropdown':1000, '@zindexPopover':1010, '@zindexTooltip':1020, '@zindexFixedNavbar':1030, '@zindexModalBackdrop':1040, '@zindexModal':1050
                // Sprite icons path
                // -------------------------, '@iconSpritePath':'"http://joufdesign.local/witter/bootstrap/glyphicons-halflings.png"', '@iconWhiteSpritePath':'"http://joufdesign.local/twitter/bootstrap/glyphicons-halflings-white.png"'
                // Input placeholder text color
                // -------------------------, '@placeholderText':"@grayLight"
                // Hr border color
                // -------------------------, '@hrBorder':"@grayLighter"
                // Navbar
                // -------------------------, '@navbarHeight':"40px", '@navbarBackground':"@grayDarker", '@navbarBackgroundHighlight':"@grayDark", '@navbarText':"@grayLight", '@navbarLinkColor':"@grayLight", '@navbarLinkColorHover':"@white", '@navbarLinkColorActive':"@navbarLinkColorHover", '@navbarLinkBackgroundHover':"transparent", '@navbarLinkBackgroundActive':"@navbarBackground", '@navbarSearchBackground':"lighten(@navbarBackground, 25%)", '@navbarSearchBackgroundFocus':"@white", '@navbarSearchBorder':"darken(@navbarSearchBackground, 30%)", '@navbarSearchPlaceholderColor':"#ccc"
                // Hero unit
                // -------------------------, '@heroUnitBackground':"@grayLighter", '@heroUnitHeadingColor':"inherit", '@heroUnitLeadColor':"inherit"
                // Form states and alerts
                // -------------------------, '@warningText':"#c09853", '@warningBackground':"#fcf8e3", '@warningBorder':"darken(spin(@warningBackground, -10), 3%)", '@errorText':"#b94a48", '@errorBackground':"#f2dede", '@errorBorder':"darken(spin(@errorBackground, -10), 3%)", '@successText':"#468847", '@successBackground':"#dff0d8", '@successBorder':"darken(spin(@successBackground, -10), 5%)", '@infoText':"#3a87ad", '@infoBackground':"#d9edf7", '@infoBorder':"darken(spin(@infoBackground, -10), 7%)"
                // GRID
                // --------------------------------------------------, '@gridColumns':12, '@gridColumnWidth':'60px', '@gridGutterWidth':'20px', '@gridRowWidth':'(@gridColumns * @gridColumnWidth) + (@gridGutterWidth * (@gridColumns - 1))'
                // Fluid grid
                // -------------------------, '@fluidGridColumnWidth':'6.382978723%', '@fluidGridGutterWidth':'2.127659574%'
            }
        }, _create:function () {
            var self = this,
                o = this.options;

            this.css = "";

        }, destroy:function () {
            // call the original destroy method since we overwrote it
            $.Widget.prototype.destroy.call(this);
        }, getCss:function () {
            return this.css
        }, getLessVariables:function () {
            var s = "",
                o = this.options,
                variables = o.variables;
            for (i in variables) {
                s += (i + ": " + variables[i] + ";\n")
            }
            return s;
        }, getVariables:function () {
            return this.options.variables;
        }, setVariable:function (key, value) {
            var c = this.options.variables;
            if (typeof c[key] != "undefined") {
                c[key] = value;
                this.updateValue(key, value);
            } else {
                console.log(key + " is undefined");
            }
        }, updateValue:function (key, value) {
            //	this.options.css = "@test: darken(@orange, 20%); body { background-color: @test;} a {color: @test;}";//.replace(key, value);


            //css = [this.getLessVariables(), this.options.css].join('\n');
            //console.log("test: " + this.getLessVariables());
            //	less.refreshCSS(css, { title: 'boost1' });


        }
    });

    $.extend($.ui.themeroller, {
        instances:[]
    });

})(jQuery);