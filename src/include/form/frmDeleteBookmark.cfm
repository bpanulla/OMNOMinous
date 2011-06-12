<form id="frmNewBookmark" method="post" action="delete.cfm">
	<fieldset class="panel">
		<legend>Delete Bookmark</legend>
		<cfoutput>
		<input name="resource" type="hidden" value="#bookmark.resource#">
		<div>
			<label for="title">Title</label>
			<span>#bookmark.title#</span>
		</div>
		<div>
			<label>URL</label>
			<span>#bookmark.resource#</span>
		</div>
		<div>
			<label>Created</label>
			<span>#bookmark.dateCreated#</span>
		</div>
		</cfoutput>
		<div class="controls">
			<input name="acknowledge" type="submit" value="Delete"/>
		</div>
	</fieldset>
</form>