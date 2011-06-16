<cfmodule template="/include/layout.cfm" title="Load RDF Data To Model">
	<h1>Load RDF Data To Model</h1>
	
	<cfif isDefined("form.source") AND len(form.source) GT 0>
		<cfset model = application.beanFactory.getBean("model") />
		
		<cffile action="upload" 
     		fileField="form.source"
		 		destination="#getTempDirectory()#"
				nameconflict="makeunique">
		
		<cfset model.load(fileRead(CFFILE.serverFile), "") />
	</cfif>

	<cfoutput>
		<form name="frmRubricUpload" enctype="multipart/form-data" method="post" action="#CGI.SCRIPT_NAME#">
			<div>
				<input name="source" type="file" />
			</div>
			<div>
				<input type="submit" value="Upload" />
			</div>
		</form>
	</cfoutput>
</cfmodule>