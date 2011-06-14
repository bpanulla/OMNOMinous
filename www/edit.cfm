<cfparam name="URL.resource" type="string" default="">

<cfparam name="form.resource" type="string" default="">
<cfparam name="form.title" type="string" default="">
<cfparam name="form.notes" type="string" default="">

<cfmodule template="/include/layout.cfm" title="Edit Bookmark">
	<cfif trim(form.resource) NEQ "" and trim(form.title) NEQ "">
		<cfscript>
			variables.vocab = application.beanFactory
				.getBean("vocab");
			
			variables.model = application.beanFactory
				.getBean("model");
				/*.getBean("bookmarkModel")
				.update(
					getAuthUser(),
					trim(form.resource),
					trim(form.title),
					trim(form.notes)
				);*/
			
			// Get handles on the member and resource
			local.member = variables.model.createResource(getAuthUser());
			local.bookmark = variables.model.createResource(form.resource);
			local.timestamp = DateFormat(Now(), "yyyy/mm/dd");
			
			// Has this member bookmarked this resource?
			if (local.member.hasProperty( variables.vocab.omnom.bookmarked, local.bookmark ))
			{
				WriteOutput("found bookmark for this user!");
				local.bookmark.getProperty(variables.vocab.DCTerms.title).changeObject( form.title );
				local.bookmark.getProperty(variables.vocab.DCTerms.description).changeObject( form.notes );
				
				if (local.bookmark.hasProperty(variables.vocab.DCTerms.modified))
				{
					local.bookmark.getProperty(variables.vocab.DCTerms.modified).changeObject( local.timestamp );
				}
				else
				{
					local.bookmark.addProperty(variables.vocab.DCTerms.modified, local.timestamp);
				}
			}
		</cfscript>
		
		<!--- Flag app to reload model --->
		<cfset request.appReset = true />		
		
		<cflocation url="index.cfm?appReset=true" addtoken="false">
	
	<cfelse>
		<cfscript>
			bookmark = application.beanFactory.getBean("bookmarkModel").get(getAuthUser(), URL.resource);
		</cfscript>
		
		<cfinclude template="/include/form/frmEditBookmark.cfm">
		
	</cfif>
</cfmodule>