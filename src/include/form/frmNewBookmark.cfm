<script type="text/javascript" src="js/util.js"></script>

<form id="frmNewBookmark" method="post" action="add.cfm">
	<fieldset class="panel">
		<legend>New Bookmark</legend>
		
		<div>
			<label for="title">Title</label>
			<input id="title" name="title" type="text" size="60" />
		</div>
		<div>
			<label for="location">URL</label>
			<input id="location" name="location" type="text" size="60" />
		</div>
		<div>
			<label for="notes">Notes</label>	
			<textarea id="notes" name="notes" cols="30"></textarea>
		</div>
		<div>
			<label for="tags">Tags</label>
			<ul id="selectedTags"></ul>
		</div>
		<div>
			<label for="tags">New Tag</label>	
			<input id="tagInput" name="tagInput" type="text" size="60"
					onkeyup="lookup(this.value)" onblur="fill()" />

			<!-- hide our suggestion box to begin with-->
			<div class="suggestionsBox" id="suggestions" style="display: none;position: relative; top: 0px; left: 250px;">
				<img src="img/upArrow.png" style="position: relative; top: -18px; left: 30px;" alt="upArrow" />
				<div class="suggestionList" id="autoSuggestionsList"></div>
			</div>
		</div>
		
		<div class="controls">
			<input type="submit" value="Add"/>
		</div>
	</fieldset>
</form>