<cfparam name="form.title" type="string" default="">
<cfparam name="form.location" type="string" default="">
<cfparam name="form.notes" type="string" default="">

<cfmodule template="/include/layout.cfm" title="Add Bookmark">
	<cfif trim(form.location) NEQ "" and trim(form.title) NEQ "">
		<cfscript>
			application.beanFactory.getBean("bookmarkModel")
				.create(
					getAuthUser(),
					trim(form.location),
					trim(form.title),
					trim(form.notes)
				);
		</cfscript>
		
		<cflocation url="." addtoken="false">
	</cfif>

	<cfinclude template="/include/form/frmNewBookmark.cfm">
</cfmodule>