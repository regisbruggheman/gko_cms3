$(document).ready(function () {
	var is_touch = ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch; //|| (hash['touch']&& hash['touch'].offsetTop) === 9;

	if (!is_touch) {
		$('.nav li.dropdown').on('hover.dropdown.data-api', function () {
			$(this).find('[data-toggle="dropdown"]:first').dropdown('toggle');
		}, function () {
			$(this).find('[data-toggle="dropdown"]:first').dropdown('toggle');
		})
	} else {
		$('.nav a.dropdown-toggle').attr('href', '#');
	}
});
