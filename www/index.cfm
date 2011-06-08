<cfmodule template="/include/layout.cfm" title="Home :: NOM.ino.us">
<div id="content">
	
<cfif IsUserLoggedIn()>
Hi!
<!---<cfset app = CreateObject("component", "Application")>
<cfdump var="#app#">

<cfdump var="#application#">--->
<cfelse>
	
</cfif>

</div>
</cfmodule>