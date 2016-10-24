Galleria.addTheme({

    name:'globe',
    author:'JoufDesign',
    version:'1',
    defaults:{
        transition:"pulse",
        transition_speed:800,
        image_crop:"width",
        image_pan:true,
        thumb_crop:true,
        carousel:false,
        _locale:{
            show_thumbnails:"Show thumbnails",
            hide_thumbnails:"Hide thumbnails",
            play:"Play slideshow",
            pause:"Pause slideshow",
            enter_fullscreen:"Enter fullscreen",
            exit_fullscreen:"Exit fullscreen",
            popout_image:"Popout image",
            showing_image:"Showing image %s of %s"
        },
        _showFullscreen:true,
        _showPopout:true,
        _showProgress:true,
        _showTooltip:true,
        _showGrid:true,
        _showDots:true,
        _showPlayStart:true
    },
    init:function (options) {
        if (this.getDataLength() < 2) {
            return;
        }
        //alert($("#main").innerWidth());
        this.addElement("bar", "fullscreen", "play", "popout", "thumblink", "dots", "s1", "s2", "s3", "s4", "progress");
        this.append({
            stage:"progress",
            container:["bar", "tooltip", "dots"],
            bar:["fullscreen", "play", "popout", "thumblink",
                "info", "s1", "s2", "s3", "s4"]
        });
        this.prependChild("info", "counter");
        var u = this,
            thumbs_box = this.$("thumbnails-container"),
            grid_btn = this.$("thumblink"),
            fs_btn = this.$("fullscreen"),
            play_btn = this.$("play"),
            pop_btn = this.$("popout"),
            bar = this.$("bar"),
            progress = this.$("progress"),
            ga = options.transition,
            lang = options._locale,
            ea = false,
            is_fullscreen = false,
            is_playing = !!options.autoplay;

        /////////////////////////////////////
        /// NEXT PREVIOUS BTN ANIMATION
        /////////////////////////////////////
        this.addIdleState(this.get("image-nav-left"), {left:-36});
        this.addIdleState(this.get("image-nav-right"), {right:-36});
        /////////////////////////////////////
        /// SHOW ToolTip
        /////////////////////////////////////
        options._showTooltip && u.bindTooltip({
            thumblink:lang.show_thumbnails,
            fullscreen:lang.enter_fullscreen,
            play:lang.play,
            popout:lang.popout_image,
            caption:function () {
                var y = u.getData(),
                    d = "";
                if (y) {
                    if (y.title && y.title.length) d += "<strong>" + y.title + "</strong>";
                    if (y.description && y.description.length) d += "<br>" + y.description
                }
                return d
            },
            counter:function () {
                return lang.showing_image.replace(/\%s/, u.getIndex() + 1).replace(/\%s/, u.getDataLength())
            }
        });
        /////////////////////////////////////
        /// SHOW PROGRESS
        /////////////////////////////////////
        if (options._showProgress) {
            this.bind("progress", function (e) {
                progress.width(e.percent / 100 * this.getStageWidth())
            });
            this.bind("loadstart",
                function (e) {
                    e.cached || this.$("loader").show()
                });
            this.bind("loadfinish", function () {
                progress.width(0);
                this.$("loader").hide();
                this.refreshTooltip("counter", "caption")
            });
        }
        ;

        /////////////////////////////////////
        /// SHOW GRID
        /////////////////////////////////////
        if (options._showGrid) {
            rescale_grid = function () {
                thumbs_box.height(u.getStageHeight()).width(u.getStageWidth()).css("top", ea ? 0 : u.getStageHeight() + 30)
            };
            rescale_grid();
            this.bind("rescale", rescale_grid);

            this.bind("thumbnail",
                function (e) {
                    $(e.thumbTarget).hover(
                        function () {
                            u.setInfo(e.thumbOrder);
                            u.setCounter(e.thumbOrder)
                        },
                        function () {
                            u.setInfo();
                            u.setCounter()
                        }).click(function () {
                            grid_btn.click()
                        })
                });

            grid_btn.click(function () {
                if (ea && c) {
                    u.play();
                } else {
                    c = is_playing;
                    u.pause();
                }
                thumbs_box.animate({
                        top:ea ? u.getStageHeight() + 30 : 0
                    },
                    {
                        easing:"galleria",
                        duration:400,
                        complete:function () {
                            u.defineTooltip("thumblink", ea ? lang.show_thumbnails : lang.hide_thumbnails);
                            grid_btn[ea ? "removeClass" : "addClass"]("open");
                            ea = !ea
                        }
                    })
            });
        } else {
            grid_btn.remove();
            this.$("s1").remove();
            this.$("info").css("right", 0);
        }
        /////////////////////////////////////
        /// SHOW POP UP
        /////////////////////////////////////
        if (options._showPopout) {
            pop_btn.click(function (event) {
                u.openLightbox();
                event.preventDefault()
            });
        } else {
            pop_btn.remove();
            if (options._showFullscreen) {
                this.$("s4").remove();
                this.$("info").css("right", 40);
                fs_btn.css("right", 0)
            }
        }
        /////////////////////////////////////
        /// SHOW PLAY START
        /////////////////////////////////////
        if (options._showPlayStart) {
            this.bind("play",
                function () {
                    is_playing = true;
                    play_btn.addClass("playing")
                });
            this.bind("pause",
                function () {
                    is_playing = false;
                    play_btn.removeClass("playing");
                    progress.width(0)
                });

            play_btn.click(function () {
                u.defineTooltip("play", is_playing ? lang.play : lang.pause);
                if (is_playing) u.pause();
                else {
                    ea && grid_btn.click();
                    u.play();
                }
            });
        } else {
            play_btn.remove();
        }
        /////////////////////////////////////
        /// SHOW FULLSCREEN
        /////////////////////////////////////
        if (options._showFullscreen) {

            this.bind("fullscreen_enter",
                function () {
                    is_fullscreen = true;
                    u.setOptions("transition", "none");
                    fs_btn.addClass("open");
                    bar.css("bottom", 0);
                    this.defineTooltip("fullscreen", lang.exit_fullscreen);
                    this.addIdleState(bar, {
                        bottom:-31
                    })
                });
            this.bind("fullscreen_exit",
                function () {
                    is_fullscreen = false;
                    Galleria.utils.clearTimer("bar");
                    u.setOptions("transition", ga);
                    fs_btn.removeClass("open");
                    bar.css("bottom", 0);
                    this.defineTooltip("fullscreen", lang.enter_fullscreen);
                    this.removeIdleState(bar, {
                        bottom:-31
                    })
                });


            fs_btn.click(function () {
                is_fullscreen ? u.exitFullscreen() : u.enterFullscreen()
            });
        } else {
            fs_btn.remove();
// TODO Separator shoud be in button
            if (options._show_popout) {
                this.$("s4").remove();
                this.$("info").css("right", 40);
                pop_btn.css("right", 0)
            }
        }
        if (!options._showFullscreen && !options._showPopout) {
            this.$("s3,s4").remove();
            this.$("info").css("right", 10)
        }
    }
});