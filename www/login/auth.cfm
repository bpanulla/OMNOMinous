<!--- Default command --->
<cfparam name="form.cmd" type="string" default="process" />
<cfparam name="form.username" default="" />
<cfparam name="form.password" default="" />


<cffunction name="openIdExists" access="public" output="false" returntype="boolean">
	<cfargument name="openid" type="string" required="true" />
	
	<cfset var local = {} />
	
	<cf_sparql name="local.qOpenIdExists" model="#variables.model#">
		<cf_sparqlns prefix="foaf" uri="#variables.vocab.FOAF.uri#" />
					
		ASK {
			?uri foaf:openid <cf_sparqlparam value="#arguments.openid#" type="iri">.
		}
	</cf_sparql>

	<cfreturn local.qOpenIdExists />
</cffunction>


<cffunction name="getOpenIDUser" access="public" output="false" returntype="string">
	<cfargument name="openid" type="string" required="true" />
	
	<cfset var local = {} />
	
	<cf_sparql name="local.qOpenIdUser" model="#variables.model#">
		<cf_sparqlns prefix="foaf" uri="#variables.vocab.FOAF.uri#" />
					
		SELECT DISTINCT ?uri
		WHERE {
			?uri foaf:openid <cf_sparqlparam value="#arguments.openid#" type="iri">.
		}
	</cf_sparql>

	<cfreturn local.qOpenIdUser.uri />
</cffunction>


<cffunction name="getUser" access="public" output="false" returntype="query">
	<cfargument name="uri" type="string" required="true" />
	
	<cfset var local = {} />
	
	<cf_sparql name="local.qUserProfileByUri" model="#variables.model#">
		<cf_sparqlns prefix="foaf" uri="#variables.vocab.FOAF.uri#" />
		
		SELECT DISTINCT ?uri ?fullname ?nickname ?email
		WHERE {
			?uri a foaf:Person.
			OPTIONAL {
				?uri foaf:name ?fullname;
					 foaf:nick ?nickname;
					 foaf:mbox ?email.
			}
			FILTER (?uri = <cf_sparqlparam value="#arguments.uri#" type="iri">)
		}
	</cf_sparql>
			
	<cfreturn local.qUserProfileByUri />
</cffunction>


<cffunction name="getRoles" access="public" output="false" returntype="string">
    <cfargument name="uri" type="string" required="true" />
		
	<cfset var local = {} />
	
	<cf_sparql name="local.qUserAppRoles" model="#variables.model#">
		<cf_sparqlns prefix="foaf" uri="#variables.vocab.FOAF.uri#" />
		
		SELECT DISTINCT ?groupname
		WHERE {
			<cf_sparqlparam value="#arguments.uri#" type="iri"> foaf:member ?group.
			?group foaf:name ?groupname.
		}
	</cf_sparql>
	
	<cfreturn valueList(local.qUserAppRoles.groupname) />
</cffunction>

	
<cffunction name="addUser" access="public" output="false" returntype="string">
	<cfargument name="credentials" type="struct" required="true" />
		
	<cfscript>
		var local = {};
		
		local.uri = "http://omnomino.us/member/" & createUUID();
		local.fullname = "";
		local.nickname = "";
		local.email = "";
		
		local.newUser = variables.model.createResource(local.uri)
							.addProperty(variables.vocab.RDF.type, variables.vocab.FOAF.Person)
							.addProperty(variables.vocab.FOAF.openid, variables.model.createResource(arguments.credentials.user_identity));

		// Full name
		if ( structKeyExists(arguments.credentials.ax, "fullname") )
		{
			local.fullname = arguments.credentials.ax.fullname;
		}
		else if ( structKeyExists(arguments.credentials.ax, "firstname")
					and structKeyExists(arguments.credentials.ax, "lastname") )
		{
			local.fullname = arguments.credentials.ax.firstname & " " & arguments.credentials.ax.lastname;
		}
		
		if (len(local.fullname)) local.newUser.addProperty(variables.vocab.FOAF.name, local.fullname);
		

		// Nickname
		if ( structKeyExists(arguments.credentials.ax, "nickname") )
		{
			local.nickname = arguments.credentials.ax.nickname;
		}
		else if ( structKeyExists(arguments.credentials.ax, "email") )
		{
			local.nickname = arguments.credentials.ax.email;
		}
		
		if (len(local.nickname)) local.newUser.addProperty(variables.vocab.FOAF.nick, local.nickname);
		

		// Email
		if ( structKeyExists(arguments.credentials.ax, "email") )
		{
			local.email = arguments.credentials.ax.email;
		}
		
		if (len(local.email)) local.newUser.addProperty(variables.vocab.FOAF.mbox, local.email);
		
		return local.uri;
	</cfscript>
</cffunction>


<cfscript>
	model = application.beanFactory.getBean("persistentInfModel");
	vocab = application.beanFactory.getBean("vocabDictionary");
	
	authType = "OpenID";
	success = false;
	newUser = false;
	message = "";
	
	if ( form.cmd eq "auth" )
	{
		oConsumer = CreateObject("component", "OpenID.OpenIDConsumer2").init();
	
		ax = {
				realm = "http://omnomino.us",
				email = "http://axschema.org/contact/email",
				fullname = "http://axschema.org/namePerson",
				firstname = "http://axschema.org/namePerson/first",
				lastname = "http://axschema.org/namePerson/last",
				nickname = "http://axschema.org/namePerson/friendly"
			};
	
		authArgs = {
				identifier = form.openid_identity,
				returnURL = "http#IIF(cgi.https eq 'on',DE('s'),DE(''))#://#cgi.http_host##cgi.script_name#",
				sregRequired = "nickname",
				sregOptional = "email,fullname,dob,country",
				axRequired = "email,fullname,firstname,lastname,nickname",
				ax = ax
			};
			
		if ( oConsumer.authenticate(authArgs) )
		{
			success = true;
		}
		else
		{
			message = "Can't find OpenID server";
		}
	}
	else if ( form.cmd eq "process" )
	{
		oConsumer = CreateObject("component", "OpenID.OpenIDConsumer2").init();
		creds = oConsumer.verifyAuthentication();
		
		success = creds.result is "success";
		message = creds.resultMsg;
	}
	else if ( form.cmd eq "fps" )
	{
		authType = "FPS";
		
		oConsumer = createObject("component", "psu.FPSConsumer" );
	
		// Where to send the user after login? Default is login error screen
		local.location = "index.cfm##frmPasswordLogin?msg=fail";
		
		authArgs = {
			username = trim(form.username),
			password = trim(form.password)
		};
	
		if ( oConsumer.authenticate( authArgs ) )
		{
			success = true;
		}

		creds = oConsumer.verifyAuthentication();
	}
	else
	{
		authType = "Unknown";
		message = "Unknown authentication type.";
	}
	
	if ( success )
	{
		userID = "";
		
		if ( not openIdExists( creds.user_identity ) )
		{
			newUser = true;
			userID = addUser( creds );
		}
		else
		{
			userID = getOpenIDUser( creds.user_identity );
		}

		// Get user credentials		
		userProfile = getUser( userID );
		
		member = {
			uri = userID,
			fullname = userProfile.fullname,
			nickname = userProfile.nickname,
			email = userProfile.email,
			roles = getRoles(userID)
		};
		
		// Copy credentials to the session scope
		session.member = member;
	}
</cfscript>

<cfmodule template="/include/layout.cfm" title="Authentication">
	<section style="text-align:left">
	<cfoutput>	
	<h3>#authType# Result</h3>
	
	<cfif success>
		<p class="info">INFO: <span>#creds.resultMsg#</span></p>
		<p class="info">New User: <span>#newUser#</span></p>
		<p><a href="..">&larr; go Home</a></p>
	<cfelse>
		<p class="error">ERROR: <span>#creds.resultMsg#</span></p>
		<p><a href="index.cfm">&larr; go back</a></p>
	</cfif>
	</cfoutput>
	
	<cfdump var="#creds#">
	</section>
</cfmodule>