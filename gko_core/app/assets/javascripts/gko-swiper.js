jQuery(document).ready(function() {

  /* Initialize Slider */
  var swiper = jQuery('#swiper').swiper({
    loop: true,
    grabCursor: true,
    autoPlay: 4000
  });

  /* On Load swiper height should adjust to img size */
  jQuery('.swiper-slide img').load(function() {
    jQuery('#swiper').height(jQuery('.swiper-slide img').height());
    jQuery('.swiper-wrapper').height(jQuery('.swiper-slide img').height());
  });

  /* On Resize swiper height should adjust to img size */
  jQuery(window).resize(function() {
    jQuery('#swiper').height(jQuery('.swiper-slide img').height());
    jQuery('.swiper-wrapper').height(jQuery('.swiper-slide img').height());
  });

});
