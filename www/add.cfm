<cfparam name="form.title" type="string" default="">
<cfparam name="form.location" type="string" default="">
<cfparam name="form.notes" type="string" default="">
<cfparam name="form.tag" type="string" default="">

<cfmodule template="/include/layout.cfm" title="Add Bookmark">
	<cfif trim(form.location) NEQ "" and trim(form.title) NEQ "">
		
		<cfset variables.tags = arrayNew(1) />

		<cfif len(trim(form.tag)) gt 0>
			<cfset variables.tags = listToArray(form.tag) />
		</cfif>
		
		
		<cfscript>
			application.beanFactory.getBean("bookmarkModel")
				.create(
					getAuthUser(),
					trim(form.location),
					trim(form.title),
					trim(form.notes),
					variables.tags
				);
		</cfscript>
		
		<cflocation url="." addtoken="false">
	</cfif>

	<cfinclude template="/include/form/frmNewBookmark.cfm">
</cfmodule>