///////////////////////////////
//minimal
G.make(0, {
    defaults:{
        transition:"pulse",
        thumbCrop:true,
        imageCrop:true,
        carousel:false,
        imagePan:true,
        clicknext:true,
        _locale:{
            enter_fullscreen:"Enter fullscreen",
            exit_fullscreen:"Exit fullscreen",
            click_to_close:"Click to close",
            show_thumbnails:"Show thumbnails",
            show_info:"Show info"
        }
    },
    init:function (s) {
        var v = this,
            Q = false,
            M;
        M = 0;
        var O,
            X,
            da;
        this.addElement("desc", "dots", "thumbs", "fs", "more");
        this.append({
            container:["desc", "dots", "thumbs", "fs", "info-description", "more"]
        });
        da = this.$("thumbnails-container").hide().css("visibility",
            "visible");
        var V = function (Y) {
            return k("<div>").click(function (ia) {
                return function (R) {
                    R.preventDefault();
                    v.show(ia)
                }
            }(Y))
        };
        for (M = 0; M < this.getDataLength(); M++) this.$("dots").append(V(M));
        M = this.$("dots").outerWidth();
        O = this.$("desc").hide().hover(
            function () {
                k(this).addClass("hover")
            },
            function () {
                k(this).removeClass("hover")
            }).click(function () {
                k(this).hide()
            });
        X = this.$("loader");
        this.bindTooltip({
            fs:function () {
                return Q ? s._locale.exit_fullscreen : s._locale.enter_fullscreen
            },
            desc:s._locale.click_to_close,
            more:s._locale.show_info,
            thumbs:s._locale.show_thumbnails
        });
        this.bind("loadstart",
            function (Y) {
                Y.cached || this.$("loader").show().fadeTo(200, 0.4)
            });
        this.bind("loadfinish",
            function (Y) {
                var ia = v.getData().title,
                    R = v.getData().description;
                O.hide();
                X.fadeOut(200);
                this.$("dots").children("div").eq(Y.index).addClass("active").siblings(".active").removeClass("active");
                if (ia && R) {
                    O.empty().append("<strong>" + ia + "</strong>", "<p>" + R + "</p>").css({
                        marginTop:this.$("desc").outerHeight() / -2
                    });
                    this.$("more").show()
                } else this.$("more").hide();
                da.fadeOut(s.fadeSpeed);
                v.$("thumbs").removeClass("active")
            });
        this.bind("thumbnail",
            function (Y) {
                k(Y.thumbTarget).hover(function () {
                        v.setInfo(Y.index)
                    },
                    function () {
                        v.setInfo()
                    })
            });
        this.$("fs").click(function () {
            v.toggleFullscreen();
            Q = !Q
        });
        this.$("thumbs").click(function (Y) {
            Y.preventDefault();
            da.toggle();
            k(this).toggleClass("active");
            O.hide()
        });
        this.$("more").click(function () {
            O.toggle()
        });
        this.$("info").css({
            width:this.getStageWidth() - M - 30,
            left:M + 10
        })
    }
});

///////////////////////////////
//Twelve
G.make(1, {
    defaults:{
        transition:"pulse",
        transitionSpeed:500,
        imageCrop:true,
        thumbCrop:true,
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
        _showTooltip:true
    },
    init:function (s) {
        this.addElement("bar", "fullscreen", "play", "popout", "thumblink", "s1", "s2", "s3", "s4", "progress");
        this.append({
            stage:"progress",
            container:["bar", "tooltip"],
            bar:["fullscreen", "play", "popout", "thumblink", "info", "s1", "s2", "s3", "s4"]
        });
        this.prependChild("info", "counter");
        var v = this,
            Q = this.$("thumbnails-container"),
            M = this.$("thumblink"),
            O = this.$("fullscreen"),
            X = this.$("play"),
            da = this.$("popout"),
            V = this.$("bar"),
            Y = this.$("progress"),
            ia = s.transition,
            R = s._locale,
            ja = false,
            ga = false,
            ka = !!s.autoplay,
            c = false,
            aa = function () {
                Q.height(v.getStageHeight()).width(v.getStageWidth()).css("top", ja ? 0 : v.getStageHeight() + 30)
            },
            $ = function () {
                if (ja && c) v.play();
                else {
                    c = ka;
                    v.pause()
                }
                Galleria.utils.animate(Q, {
                        top:ja ? v.getStageHeight() + 30 : 0
                    },
                    {
                        easing:"galleria",
                        duration:400,
                        complete:function () {
                            v.defineTooltip("thumblink", ja ? R.show_thumbnails : R.hide_thumbnails);
                            M[ja ? "removeClass" : "addClass"]("open");
                            ja = !ja
                        }
                    })
            };
        aa();
        s._showTooltip && v.bindTooltip({
            thumblink:R.show_thumbnails,
            fullscreen:R.enter_fullscreen,
            play:R.play,
            popout:R.popout_image,
            caption:function () {
                var j = v.getData(),
                    ha = "";
                if (j) {
                    if (j.title && j.title.length) ha += "<strong>" + j.title + "</strong>";
                    if (j.description &&
                        j.description.length) ha += "<br>" + j.description
                }
                return ha
            },
            counter:function () {
                return R.showing_image.replace(/\%s/, v.getIndex() + 1).replace(/\%s/, v.getDataLength())
            }
        });
        s.showInfo || this.$("info").hide();
        this.bind("play",
            function () {
                ka = true;
                X.addClass("playing")
            });
        this.bind("pause",
            function () {
                ka = false;
                X.removeClass("playing");
                Y.width(0)
            });
        s._showProgress && this.bind("progress",
            function (j) {
                Y.width(j.percent / 100 * this.getStageWidth())
            });
        this.bind("loadstart",
            function (j) {
                j.cached || this.$("loader").show()
            });
        this.bind("loadfinish",
            function () {
                Y.width(0);
                this.$("loader").hide();
                this.refreshTooltip("counter", "caption")
            });
        this.bind("thumbnail",
            function (j) {
                k(j.thumbTarget).hover(
                    function () {
                        v.setInfo(j.thumbOrder);
                        v.setCounter(j.thumbOrder)
                    },
                    function () {
                        v.setInfo();
                        v.setCounter()
                    }).click(function () {
                        $()
                    })
            });
        this.bind("fullscreen_enter",
            function () {
                ga = true;
                v.setOptions("transition", false);
                O.addClass("open");
                V.css("bottom", 0);
                this.defineTooltip("fullscreen", R.exit_fullscreen);
                Galleria.TOUCH || this.addIdleState(V,
                    {
                        bottom:-31
                    })
            });
        this.bind("fullscreen_exit",
            function () {
                ga = false;
                Galleria.utils.clearTimer("bar");
                v.setOptions("transition", ia);
                O.removeClass("open");
                V.css("bottom", 0);
                this.defineTooltip("fullscreen", R.enter_fullscreen);
                Galleria.TOUCH || this.removeIdleState(V, {
                    bottom:-31
                })
            });
        this.bind("rescale", aa);
        if (!Galleria.TOUCH) {
            this.addIdleState(this.get("image-nav-left"), {
                left:-36
            });
            this.addIdleState(this.get("image-nav-right"), {
                right:-36
            })
        }
        M.click($);
        if (s._showPopout) da.click(function (j) {
            v.openLightbox();
            j.preventDefault()
        });
        else {
            da.remove();
            if (s._showFullscreen) {
                this.$("s4").remove();
                this.$("info").css("right", 40);
                O.css("right", 0)
            }
        }
        X.click(function () {
            v.defineTooltip("play", ka ? R.play : R.pause);
            if (ka) v.pause();
            else {
                ja && M.click();
                v.play()
            }
        });
        if (s._showFullscreen) O.click(function () {
            ga ? v.exitFullscreen() : v.enterFullscreen()
        });
        else {
            O.remove();
            if (s._show_popout) {
                this.$("s4").remove();
                this.$("info").css("right", 40);
                da.css("right", 0)
            }
        }
        if (!s._showFullscreen && !s._showPopout) {
            this.$("s3,s4").remove();
            this.$("info").css("right", 10)
        }
        s.autoplay &&
        this.trigger("play")
    }
});

///////////////////////////////
//fullscreen
G.make(2, {
    defaults:{
        transition:"none",
        imageCrop:true,
        thumbCrop:"height",
        easing:"galleriaOut",
        _hideDock:Galleria.TOUCH ? false : true,
        _closeOnClick:false
    },
    init:function (s) {
        this.addElement("thumbnails-tab");
        this.appendChild("thumbnails-container", "thumbnails-tab");
        var v = this.$("thumbnails-tab"),
            Q = this.$("loader"),
            M = this.$("thumbnails-container"),
            O = this.$("thumbnails-list"),
            X = this.$("info-text"),
            da = this.$("info"),
            V = !s._hideDock,
            Y = 0;
        if (Galleria.IE) {
            this.addElement("iefix");
            this.appendChild("container",
                "iefix");
            this.$("iefix").css({
                zIndex:3,
                position:"absolute",
                backgroundColor:"#000",
                opacity:0.4,
                top:0
            })
        }
        s.thumbnails === false && M.hide();
        var ia = this.proxy(function (R) {
            if (R || R.width) {
                R = Math.min(R.width, k(window).width());
                X.width(R - 40);
                Galleria.IE && this.getOptions("showInfo") && this.$("iefix").width(da.outerWidth()).height(da.outerHeight())
            }
        });
        this.bind("rescale",
            function () {
                Y = this.getStageHeight() - v.height() - 2;
                M.css("top", V ? Y - O.outerHeight() + 2 : Y);
                var R = this.getActiveImage();
                R && ia(R)
            });
        this.bind("loadstart",
            function (R) {
                R.cached || Q.show().fadeTo(100, 1);
                k(R.thumbTarget).css("opacity", 1).parent().siblings().children().css("opacity", 0.6)
            });
        this.bind("loadfinish",
            function () {
                Q.fadeOut(300);
                this.$("info, iefix").toggle(this.hasInfo())
            });
        this.bind("image",
            function (R) {
                ia(R.imageTarget)
            });
        this.bind("thumbnail",
            function (R) {
                k(R.thumbTarget).parent(":not(.active)").children().css("opacity", 0.6);
                k(R.thumbTarget).click(function () {
                    V && s._closeOnClick && v.click()
                })
            });
        this.trigger("rescale");
        if (!Galleria.TOUCH) {
            this.addIdleState(M,
                {
                    opacity:0
                });
            this.addIdleState(this.get("info"), {
                opacity:0
            })
        }
        Galleria.IE && this.addIdleState(this.get("iefix"), {
            opacity:0
        });
        this.$("image-nav-left, image-nav-right").css("opacity", 0.01).hover(
            function () {
                k(this).animate({
                        opacity:1
                    },
                    100)
            },
            function () {
                k(this).animate({
                    opacity:0
                })
            }).show();
        if (s._hideDock) v.click(this.proxy(function () {
            v.toggleClass("open", !V);
            V ? M.animate({
                    top:Y
                },
                400, s.easing) : M.animate({
                    top:Y - O.outerHeight() + 2
                },
                400, s.easing);
            V = !V
        }));
        else {
            this.bind("thumbnail",
                function () {
                    M.css("top", Y - O.outerHeight() +
                        2)
                });
            v.css("visibility", "hidden")
        }
        this.$("thumbnails").children().hover(function () {
                k(this).not(".active").children().stop().fadeTo(100, 1)
            },
            function () {
                k(this).not(".active").children().stop().fadeTo(400, 0.6)
            });
        this.enterFullscreen();
        this.attachKeyboard({
            escape:function () {
                return false
            },
            up:function (R) {
                V || v.click();
                R.preventDefault()
            },
            down:function (R) {
                V && v.click();
                R.preventDefault()
            }
        })
    }
});
///////////////////////////////
//classic
G.make(3, {
    defaults:{
        transition:"slide",
        thumbCrop:"height",
        _toggleInfo:true
    },
    init:function (s) {
        this.addElement("info-link",
            "info-close");
        this.append({
            info:["info-link", "info-close"]
        });
        var v = this.$("info-link,info-close,info-text"),
            Q = Galleria.TOUCH,
            M = Q ? "touchstart" : "click";
        this.$("loader,counter").show().css("opacity", 0.4);
        if (!Q) {
            this.addIdleState(this.get("image-nav-left"), {
                left:-50
            });
            this.addIdleState(this.get("image-nav-right"), {
                right:-50
            });
            this.addIdleState(this.get("counter"), {
                opacity:0
            })
        }
        if (s._toggleInfo === true) v.bind(M,
            function () {
                v.toggle()
            });
        else {
            v.show();
            this.$("info-link, info-close").hide()
        }
        this.bind("thumbnail",
            function (O) {
                if (Q) k(O.thumbTarget).css("opacity", O.index == s.show ? 1 : 0.6);
                else {
                    k(O.thumbTarget).css("opacity", 0.6).parent().hover(function () {
                            k(this).not(".active").children().stop().fadeTo(100, 1)
                        },
                        function () {
                            k(this).not(".active").children().stop().fadeTo(400, 0.6)
                        });
                    O.index === s.show && k(O.thumbTarget).css("opacity", 1)
                }
            });
        this.bind("loadstart",
            function (O) {
                O.cached || this.$("loader").show().fadeTo(200, 0.4);
                this.$("info").toggle(this.hasInfo());
                k(O.thumbTarget).css("opacity", 1).parent().siblings().children().css("opacity",
                    0.6)
            });
        this.bind("loadfinish",
            function () {
                this.$("loader").fadeOut(200)
            })
    }
});

///////////////////////////////
//folio
G.make(4, {
    defaults:{
        transition:"pulse",
        thumbCrop:"width",
        imageCrop:false,
        carousel:false,
        show:false,
        easing:"galleriaOut",
        fullscreenDoubleTap:false,
        _webkitCursor:true,
        _animate:true
    },
    init:function (s) {
        this.addElement("preloader", "loaded", "close").append({
            container:"preloader",
            preloader:"loaded",
            stage:"close"
        });
        var v = this,
            Q = this.$("stage"),
            M = this.$("thumbnails"),
            O = this.$("images"),
            X = this.$("info"),
            da = this.$("loader"),
            V = this.$("target"),
            Y = 0,
            ia = V.width(),
            R = 0,
            ja = s.show,
            ga = false,
            ka = function (aa) {
                v.$("info").css({
                    left:Math.max(20, k(window).width() / 2 - aa / 2 + 10)
                })
            },
            c = function (aa, $) {
                $ = k.extend({
                        speed:400,
                        width:190,
                        onbrick:function () {
                        },
                        onheight:function () {
                        },
                        delay:0,
                        debug:false
                    },
                    $);
                aa = k(aa);
                var j = aa.children(),
                    ha = aa.width(),
                    z = Math.floor(ha / $.width),
                    d = [],
                    h,
                    m,
                    n;
                ha = {
                    "float":"none",
                    position:"absolute",
                    display:k.browser.safari ? "inline-block" : "block"
                };
                if (aa.data("colCount") !== z) {
                    aa.data("colCount", z);
                    if (j.length) {
                        for (h = 0; h < z; h++) d[h] = 0;
                        aa.css("position",
                            "relative");
                        j.css(ha).each(function (B, C) {
                            C = k(C);
                            for (h = z - 1; h > -1; h--) if (d[h] === Math.min.apply(window, d)) m = h;
                            n = {
                                top:d[m],
                                left:$.width * m
                            };
                            if (!(typeof n.top !== "number" || typeof n.left !== "number")) {
                                if ($.speed) window.setTimeout(function (D, A, q) {
                                    return function () {
                                        Galleria.utils.animate(D, q, {
                                            easing:"galleriaOut",
                                            duration:A.speed,
                                            complete:A.onbrick
                                        })
                                    }
                                }(C, $, n), B * $.delay);
                                else {
                                    C.css(n);
                                    $.onbrick.call(C)
                                }
                                C.data("height") || C.data("height", C.outerHeight(true));
                                d[m] += C.data("height")
                            }
                        });
                        j = Math.max.apply(window, d);
                        if (!(j < 0)) if (typeof j === "number") if ($.speed) aa.animate({
                                height:Math.max.apply(window, d)
                            },
                            $.speed, $.onheight);
                        else {
                            aa.height(Math.max.apply(window, d));
                            $.onheight.call(aa)
                        }
                    }
                }
            };
        Galleria.OPERA && this.$("stage").css("display", "none");
        this.bind("fullscreen_enter",
            function () {
                O.css("visibility", "hidden");
                Q.show();
                this.$("container").css("height", "100%");
                ga = true
            });
        this.bind("fullscreen_exit",
            function () {
                Q.hide();
                M.show();
                X.hide();
                ga = false
            });
        this.bind("thumbnail",
            function (aa) {
                this.addElement("plus");
                var $ = aa.thumbTarget,
                    j = this.$("plus").css({
                        display:"block"
                    }).insertAfter($),
                    ha = k($).parent().data("index", aa.index);
                s.showInfo && this.hasInfo(aa.index) && j.append("<span>" + this.getData(aa.index).title + "</span>");
                R = R || k($).parent().outerWidth(true);
                k($).css("opacity", 0);
                ha.unbind(s.thumbEventType);
                Galleria.IE ? j.hide() : j.css("opacity", 0);
                Galleria.TOUCH ? ha.bind("touchstart",
                    function () {
                        j.css("opacity", 1)
                    }).bind("touchend",
                    function () {
                        j.hide()
                    }) : ha.hover(function () {
                        Galleria.IE ? j.show() : j.stop().css("opacity", 1)
                    },
                    function () {
                        Galleria.IE ?
                            j.hide() : j.stop().animate({
                                opacity:0
                            },
                            300)
                    });
                Y++;
                this.$("loaded").css("width", Y / this.getDataLength() * 100 + "%");
                if (Y === this.getDataLength()) {
                    this.$("preloader").fadeOut(100);
                    c(M, {
                        width:R,
                        speed:s._animate ? 400 : 0,
                        onbrick:function () {
                            var z = k(this).find("img");
                            window.setTimeout(function (d) {
                                return function () {
                                    Galleria.utils.animate(d, {
                                            opacity:1
                                        },
                                        {
                                            duration:s.transition_speed
                                        });
                                    d.parent().bind(Galleria.TOUCH ? "mouseup" : "click",
                                        function () {
                                            M.hide();
                                            X.hide();
                                            var h = k(this);
                                            v.enterFullscreen(function () {
                                                v.show(h.data("index"));
                                                if (h.data("index") === ja) {
                                                    O.css("visibility", "visible");
                                                    X.toggle(v.hasInfo())
                                                }
                                            })
                                        })
                                }
                            }(z), s._animate ? z.parent().data("index") * 100 : 0)
                        },
                        onheight:function () {
                            V.height(M.height())
                        }
                    })
                }
            });
        this.bind("loadstart",
            function (aa) {
                aa.cached || da.show()
            });
        this.bind("loadfinish",
            function (aa) {
                X.hide();
                ja = this.getIndex();
                O.css("visibility", "visible");
                da.hide();
                if (this.hasInfo() && s.showInfo) X.fadeIn(s.transition ? s.transitionSpeed : 0);
                ka(aa.imageTarget.width)
            });
        if (!Galleria.TOUCH) {
            this.addIdleState(this.get("image-nav-left"),
                {
                    left:-100
                });
            this.addIdleState(this.get("image-nav-right"), {
                right:-100
            });
            this.addIdleState(this.get("info"), {
                opacity:0
            });
            this.addIdleState(this.get("close"), {
                top:-50
            })
        }
        this.$("container").css({
            width:s.width,
            height:"auto"
        });
        s._webkitCursor && Galleria.WEBKIT && this.$("image-nav-right,image-nav-left").addClass("cur");
        if (Galleria.TOUCH) {
            this.setOptions({
                transition:"fadeslide",
                initialTransition:false
            });
            this.$("image-nav").hide()
        }
        this.$("close").click(function () {
            v.exitFullscreen()
        });
        k(window).resize(function () {
            if (ga) v.getActiveImage() &&
            ka(v.getActiveImage().width);
            else {
                var aa = V.width();
                if (aa !== ia) {
                    ia = aa;
                    c(M, {
                        width:R,
                        delay:50,
                        debug:true,
                        onheight:function () {
                            V.height(M.height())
                        }
                    })
                }
            }
        })
    }
})