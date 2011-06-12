<form id="frmEditBookmark" method="post" action="edit.cfm">
	<fieldset class="panel">
		<legend>Edit Bookmark</legend>
		<cfoutput>
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
			<div>#bookmark.dateModified#</div>
		</div>
		<div>
			<label for="notes">Notes</label>	
			<textarea id="notes" name="notes" cols="30">#bookmark.notes#</textarea>
		</div>
		</cfoutput>
		<div class="controls">
			<input type="submit" value="Update"/>
		</div>
	</fieldset>
</form>