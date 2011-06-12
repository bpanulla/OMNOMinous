<cfparam name="URL.resource" type="string" default="">

<cfparam name="form.resource" type="string" default="">

<cfmodule template="/include/layout.cfm" title="Delete Bookmark">
	<cfif trim(form.resource) NEQ "" and isDefined("form.acknowledge")>
		<cfscript>
			application.beanFactory.getBean("bookmarkModel")
				.delete(
					getAuthUser(),
					trim(form.resource)
				);
		</cfscript>
		
		<cflocation url="." addtoken="false">
	
	<cfelse>
		<cfscript>
			bookmark = application.beanFactory.getBean("bookmarkModel")
						.get(getAuthUser(), URL.resource);
		</cfscript>
		
		<cfinclude template="/include/form/frmDeleteBookmark.cfm">
	</cfif>
</cfmodule>
