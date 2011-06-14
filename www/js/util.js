	function lookup(inputString)
	{
		if (inputString.length == 0)
		{
			// Hide the suggestion box.
			$('#suggestions').hide();
		}
		else
		{
			// post data to our php processing page and if there is a return greater than zero
			// show the suggestions box
			$.get("search.cfm?keywords="+inputString,
				function(data)
				{
					$('#autoSuggestionsList').html(data);
					$('#suggestions').show();
				});
		}
	} //end
	
	// if user clicks a suggestion, fill the text box.
	function fill( item )
	{
		var newTag = $(item);
		
		// Remove click handler and add delete link
		newTag.removeAttr('onclick').unbind('click', fill);
		newTag.append('<span onclick="remove(this)">x</span>');
		newTag.append('<input name="tag" type="hidden" value="'+$(item).attr('about') +'">');

		$('#selectedTags').append(newTag);
		setTimeout("$('#suggestions').hide();", 200);
		
		// Clear the input box		
		$('#tagInput').val('');
	}
	
	function remove(item)
	{
		$(item).parent().remove();
	}
