<form id="frmNewBookmark" method="post" action="add.cfm">
	<fieldset class="panel">
		<legend>New Bookmark</legend>
		
		<div>
			<label for="title">Title</label>
			<input id="title" name="title" type="text" size="60" />
		</div>
		<div>
			<label for="resource">URL</label>
			<input id="resource" name="resource" type="text" size="60" />
		</div>
		<div>
			<label for="notes">Notes</label>	
			<textarea id="notes" name="notes" cols="30"></textarea>
		</div>
		<div class="controls">
			<input type="submit" value="Add"/>
		</div>
	</fieldset>
</form>