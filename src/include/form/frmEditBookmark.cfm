<cfparam name="variables.title" type="string" default="" />
<cfparam name="variables.resource" type="string" default="" />
<cfparam name="variables.notes" type="string" default="" />

<form id="frmEditBookmark" method="post" action="update.cfm">
	<fieldset class="panel">
		<legend>Edit Bookmark</legend>
		<cfoutput>
		<div>
			<label for="title">Title</label>
			<input id="title" name="title" type="text" size="60" value="#variables.title#" />
		</div>
		<div>
			<label for="resource">URL</label>
			<input id="resource" name="resource" type="text" size="60" value="#variables.resource#" />
		</div>
		<div>
			<label for="notes">Notes</label>	
			<textarea id="notes" name="notes" cols="30">#variables.notes#</textarea>
		</div>
		</cfoutput>
		<div class="controls">
			<input type="submit" value="Add"/>
		</div>
	</fieldset>
</form>