<!--- ******************************************************************\
| Local variables for any in-progress authentication/authorization values
\******************************************************************* --->
<cfset _username = "" />
<cfset _authMethod = "" />
<cfset _roles = "" />

<cfif isDefined("session.user.profile")>
	<!--- Check for successful OpenID authentication --->
	<cfset _username = trim(session.user.profile.uri) />
	<cfset _authMethod = "OpenID" />

<!--- Check for username/password tuple in request --->
<cfelseif isDefined("cflogin") AND trim(cflogin.name) NEQ "" AND trim(cflogin.password) NEQ ""
		AND application.controller.UserSession.login(cflogin.name, cflogin.password)>
			
	<cfset _username = trim(cflogin.name) />
	<cfset _authMethod = "Password" />

<!--- Check for Web server authentication and authorize user if possible --->
<cfelseif CGI.REMOTE_USER NEQ "">
	<cfset _username = CGI.REMOTE_USER />
	<cfset _authMethod = "Basic Auth" />
</cfif>

<!--- If one of the authentication methods, was successful, log the user in --->
<cfif _username NEQ "">
    <cfset _roles = "Authenticated" />

   	<cfloginuser name="#_username#" password="" roles="#_roles#" />
   	<cfset session.username = _username />
	<cfset session.authMethod = _authMethod />
</cfif>
