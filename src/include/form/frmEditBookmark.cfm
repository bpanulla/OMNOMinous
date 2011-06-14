<script type="text/javascript" src="js/util.js"></script>

<form id="frmEditBookmark" method="post" action="edit.cfm">
	<fieldset class="panel">
		<legend>Edit Bookmark</legend>
		<cfoutput query="bookmark" group="resource">
		<input name="resource" type="hidden" value="#bookmark.resource#">
		<div>
			<label for="title">Title</label>
			<input id="title" name="title" type="text" size="60" value="#bookmark.title#" />
		</div>
		<div>
			<label>URL</label>
			<span>#bookmark.resource#</span>
		</div>
		<div>
			<label>Created</label>
			<span>#bookmark.dateCreated#</span>
		</div>
		<div>
			<label>Modified</label>
			<span>#bookmark.dateModified#</span>
		</div>
		<div>
			<label for="notes">Notes</label>	
			<textarea id="notes" name="notes" cols="30">#bookmark.notes#</textarea>
		</div>
		<div>
			<label for="tags">Tags</label>
			<ul id="selectedTags"><cfoutput>
				<li>#bookmark.tag#</li>
			</cfoutput></ul>
		</div>
		</cfoutput>
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
			<input type="submit" value="Update"/>
		</div>
	</fieldset>
</form>