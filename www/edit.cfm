<cfparam name="URL.resource" type="string" default="">

<cfparam name="form.resource" type="string" default="">
<cfparam name="form.title" type="string" default="">
<cfparam name="form.notes" type="string" default="">

<cfmodule template="/include/layout.cfm" title="Edit Bookmark">
	<cfif trim(url.resource) NEQ "">
		
		
		
	<cfelseif trim(form.resource) NEQ "" and trim(form.title) NEQ "">
		<cfscript>
			application.beanFactory.getBean("memberModel")
				.updateBookmark(
					getAuthUser(),
					trim(form.resource),
					trim(form.title),
					trim(form.notes)
				);
		</cfscript>
		
		<cflocation url="." addtoken="false">
	</cfif>

	<cfinclude template="/include/form/frmEditBookmark.cfm">
</cfmodule>