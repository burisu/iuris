(function ($) {
    
    $(document).on("click", "button[data-add-tag-label][data-add-tag-url]", function (event) {
        var element = $(this), url, tags, field;
        url = element.data('add-tag-url');
        field = $('#' + element.data('add-tag-label'));
        tags = element.data('add-tag-to');
        if (tags !== null && tags !== undefined) {
            tags = $('#' + tags);
        }
        $.ajax(url, {
            data: {label: field.val()},
            dataType: 'html',
	    type: 'POST',
            success: function (data, status, request) {
                tags.html(data);
            }
        });
        return false;
    });

    $(document).on("click", "a[href][data-remove-tag]", function (event) {
        var element = $(this), url, tag;
        url = element.attr('href');
        tag = $('#' + element.data('remove-tag'));
        $.ajax(url, {
            dataType: 'html',
	    type: 'DELETE',
            success: function (data, status, request) {
		tag.remove();
		element.remove();
            }
        });
        return false;
    });

    $(document).ready(function () {
	$("input[data-autocomplete-with]").each(function (index) {
	    var element = $(this), url;
	    url = element.data("autocomplete-with");
	    element.autocomplete({
		source: url,
		minLength: 2
	    });
	});
    });

}) (jQuery);
