<cfmodule template="/include/layout.cfm" title="Home :: NOM.ino.us">
<div id="content">
	
<cfif IsUserLoggedIn()>
Hi!
<cfelse>
Please log in!	
</cfif>

</div>
</cfmodule>