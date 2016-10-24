init_images = function () {
  // Toggle 'upload input' and 'image preview' in image form
  $(".change-upload-file-btn").bind('click',
      function (e) {
          e.preventDefault();
          var btnText = $(this).find(".ui-btn-text:first");
          if (!btnText.length) {
              btnText = $(this);
          }
          var html = btnText.html();
          var data = $(this).attr("data-text");
          btnText.html(data);
          $(this).attr("data-text", html);
          $(this).parent().parent().find(".js-file-preview:first").toggle("fast").parent().find(".file-field:first").slideToggle("fast");
      });
  $('.delete-file-btn').bind('click',
      function (e) {
          e.preventDefault();
          $(this).parent().parent().find(".js-file-preview:first").toggle("fast").parent().find(".file-field:first").slideToggle("fast").find("input.file").val("");
      });
  /*/////////////////////////////////////////////*/
  // Image folder to filter image library
  $('ol#image_folders_nested_set li a').live("click", function (e) {
      $('ol#image_folders_nested_set li').removeClass('ui-selected');
      $(this).parent().addClass('ui-selected');
  });
}
