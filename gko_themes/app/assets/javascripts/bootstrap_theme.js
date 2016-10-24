// Variables.less
// Variables to customize the look and feel of Bootstrap
// -----------------------------------------------------

$.fn.ThemeColor = function () {

    this.defaultOptions = {
        class:'DataBar',
        text:'Enter Text Here'
    };

    this.greet = function () {
        alert(this.defaultOptions.text);
    };
};

var q = new $.fn.ThemeColor();
q.greet();

// GLOBAL VALUES
// --------------------------------------------------

// Grays
// -------------------------
var bootstrapTheme = {

        black:"#000", grayDarker:"#222", grayDark:"#333", gray:"#555", grayLight:"#999", grayLighter:"#eee", white:"#fff"


        // Accent colors
        // -------------------------
        accent_colors:{
            blue:"#049cdb", blueDark:"#0064cd", green:"#46a546", red:"#9d261d", yellow:"#ffc40d", orange:"#f89406", pink:"#c3325f", purple:"#7a43b6"
        },



// Scaffolding
// -------------------------
    , bodyBackground
:
"white"
    , textColor
:
"grayDark"


    // Links
    // -------------------------
    , linkColor
:
"#08c"
//, linkColorHover: darken(linkColor, 15%)

}


// personKeys will contain this JavaScript array after execution:
//  ['name', 'website', 'twitter']
var bootstrapThemeKeys = $.map(bootstrapTheme, function (value, key) {
    console.log(key + ": " + value);
});