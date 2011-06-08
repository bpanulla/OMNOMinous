<cfif IsUserLoggedIn()>
	<cfset structClear(session) />
	<cflogout />
</cfif>

<cflocation url=".." addtoken="false" />
