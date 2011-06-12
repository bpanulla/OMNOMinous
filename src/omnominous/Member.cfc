<cfcomponent output="false">
	
	<!--- Constructor to receive injected references --->
	<cffunction name="init" access="public" returntype="Member">
		<cfargument name="model" type="org.panulla.semweb.Model" required="true" />
		<cfargument name="vocab" type="org.panulla.semweb.VocabularyModel" required="true" />
		
		<cfscript>
			variables.model = arguments.model;
			variables.vocab = arguments.vocab;
			
			return this;
		</cfscript>
	</cffunction>
	
	
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
	
	
	<cffunction name="getByOpenID" access="public" output="false" returntype="string">
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
	
	
	<cffunction name="get" access="public" output="false" returntype="query">
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
	
		
	<cffunction name="create" access="public" output="false" returntype="string">
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
	
</cfcomponent>