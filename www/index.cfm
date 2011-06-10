<cfmodule template="/include/layout.cfm" title="Home :: NOM.ino.us">
<div id="content">
	
<cfif IsUserLoggedIn()>
	Hi
	<cfscript>
		bookmarks = application.beanFactory.getBean("bookmarkModel").getMemberBookmarks(getAuthUser());
	</cfscript>
	
	<cfdump var="#bookmarks#">
<cfelse>
Please log in!	
</cfif>

</div>
</cfmodule>