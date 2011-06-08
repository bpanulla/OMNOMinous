<cfcomponent hint="Handles authentication for Friends of Penn State accounts" output="false">

	<!--- Private variable containing user identity --->
	<cfset variables.creds = {} />
	<cfset variables.raw = xmlNew() />
	
	<cfset variables.serviceURI = "https://fps.psu.edu/api/auth_identity.cgi" />
	
	<!--- Property to receive injected references --->
	<cffunction name="init" access="public" returntype="FPSConsumer">
		<cfreturn this />
	</cffunction>
	
	<!--- ============================================
	|	Public Interface	
	 \============================================ --->
	
	<cffunction name="authenticate" access="public" output="false" returntype="boolean" hint="Authenticates user against Friends of Penn State account.">
		<cfargument name="authArgs" type="struct" required="true" />
		
		<cfif NOT structKeyExists(arguments.authArgs, "username")>
			<cfthrow type="FPSAuth" message="Username argument required for authenticate() method" />
			
		<cfelseif NOT structKeyExists(arguments.authArgs, "password")>
			<cfthrow type="FPSAuth" message="Password argument required for authenticate() method" />
		</cfif>
	
		<cfreturn authenticateFPSUser(arguments.authArgs.username, arguments.authArgs.password) />
	</cffunction>
	
	
	<cffunction name="verifyAuthentication" access="public" output="false" returntype="struct" hint="Account profile, including name, email address, etc.">
		<cfreturn variables.creds />
	</cffunction>
	
	<cffunction name="getRawResults" access="public" output="false" returntype="xml" hint="Actual XML result of API call.">
		<cfreturn variables.raw />
	</cffunction>
	
	<!--- ============================================
	|	Private Implementation	
	 \============================================ --->
	
	<cffunction name="authenticateFPSUser" access="private" output="false" returntype="string">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />

		<cfset var local = {} />
		<cfset local.authSuccessful = false />

		<cftry>		
			<!--- Authenticate username and password via Friends Of Penn State (FPS) --->
			<cfhttp url="#variables.serviceURI#" method="post">
				<cfhttpparam name="userid" type="formfield" value="#trim(arguments.username)#" />
				<cfhttpparam name="password" type="formfield" value="#trim(arguments.password)#" />
				<cfhttpparam name="group_id" type="formfield" value="0" />
				<cfhttpparam name="in_fields" type="formfield" value="userid,password" />
				<cfhttpparam name="min_flds" type="formfield" value="userid,password" />
			</cfhttp>
			
			<!--- If contents of http result contains the word SUCCESS, the username/password were correct;
				this is a successful login. Put the full result of the call in the request scope --->
			<cfset variables.raw = xmlParse(cfhttp.FileContent) />
			<cfif cfhttp.FileContent CONTAINS "SUCCESS">
				<cfset local.authSuccessful = true /> 
				<cfset variables.creds = parseUserInfo(trim(arguments.username), variables.raw) />
			</cfif>
			
			<cfcatch type="any">
				<cfthrow type="FPSAuth" message="#cfcatch.message#" detail="#cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<cfreturn local.authSuccessful />
	</cffunction>
	
	
	<cffunction name="parseUserInfo" access="public" returntype="struct">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="authXml" type="xml" required="true" />
		
		<cfscript>
			var local = {};
			local.credentials = arguments.authXml["authentication"];
			
			if ( local.credentials.realm.XmlText EQ "internal" )
			{
				local.domain = "psu.edu";	
			}
			else
			{
				local.domain = "fps.psu.edu";
			}
			
			local.uri = "http://" & local.domain &"/person/"& local.credentials.personID.XmlText;
			local.profile.identity = local.uri;
			local.profile.user_identity = local.uri;
			local.profile.result = lcase(local.credentials.status.XmlText);
			local.profile.resultMsg = "INFO: Identity has been successfully authenticated";
			local.profile.openid_server = variables.serviceURI;
			local.profile.sreg = {};
			
			local.profile.ax = {};
			local.profile.ax["nickname"] = trim(arguments.username);
			local.profile.ax["firstname"] = local.credentials.name.first.XmlText;
			local.profile.ax["lastname"] = local.credentials.name.last.XmlText;
			local.profile.ax["email"] = local.credentials.emailAddress.XmlText;
			local.profile.ax["roles"] = local.credentials.roleList.XmlText;
			
			return local.profile;
		</cfscript>
	</cffunction>

</cfcomponent>
