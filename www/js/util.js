	function lookup(inputString)
	{
		if(inputString.length == 0)
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
					if(data.length >0)
					{
						$('#suggestions').show();
						$('#autoSuggestionsList').html(data);
					}
				});
		}
	} //end
		
	// if user clicks a suggestion, fill the text box.
	function fill(item)
	{
		//console.log(item);
		var deleteLink = $(' <span>x</span>');
		deleteLink.click( function() { alert('hi!') });
		$(item).append(deleteLink);
		$('#selectedTags').append(item);
		setTimeout("$('#suggestions').hide();", 200);
		
		// Clear the input box		
		$('#tagInput').val('');
	}