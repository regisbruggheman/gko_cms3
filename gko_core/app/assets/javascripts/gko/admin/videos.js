init_videos = function() {
  // Toggle 'upload input' and 'video preview' in video form
  $(".change-upload-video-btn").bind('click',
    function(e) {
      e.preventDefault();
      var btnText = $(this).find(".ui-btn-text:first");
      if (!btnText.length) {
        btnText = $(this);
      }
      var html = btnText.html();
      var data = $(this).attr("data-text");
      btnText.html(data);
      $(this).attr("data-text", html);
      $(this).parent().parent().find("iframe:first").toggle("fast").parent().find(".js-video-field:first").slideToggle("fast");
    });
  $('.delete-video-btn').bind('click',
    function(e) {
      e.preventDefault();
      $(this).parent().parent().find("iframe:first")
      .toggle("fast").parent().find(".js-video-field:first")
      .slideToggle("fast").find("input.video").val("");
    });
}
