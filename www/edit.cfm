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
			
			// Has this member bookmarked this resource?
			if (local.member.hasProperty( variables.vocab.omnom.bookmarked, local.bookmark ))
			{
				WriteOutput("found bookmark for this user!");
				local.bookmark.createProperty(variables.vocab.DCTerms.title).changeObject( form.title );
				local.bookmark.createProperty(variables.vocab.DCTerms.description).changeObject( form.notes );
				local.bookmark.createProperty(variables.vocab.DCTerms.modified, DateFormat(Now(), "yyyy/mm/dd"));
			}
				
				
		</cfscript>
		
		<cfdump var="#local#">
		<!---<cflocation url="." addtoken="false">--->
	
	<cfelse>
		<cfscript>
			bookmark = application.beanFactory.getBean("bookmarkModel").get(getAuthUser(), URL.resource);
		</cfscript>
		
		<cfinclude template="/include/form/frmEditBookmark.cfm">
		
	</cfif>
</cfmodule>