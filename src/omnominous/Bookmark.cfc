<cfcomponent output="false">
	
	<!--- Constructor to receive injected references --->
	<cffunction name="init" access="public" returntype="Bookmark">
		<cfargument name="model" type="org.panulla.semweb.Model" required="true" />
		<cfargument name="vocab" type="org.panulla.semweb.VocabularyModel" required="true" />
		
		<cfscript>
			variables.model = arguments.model;
			variables.vocab = arguments.vocab;
			
			return this;
		</cfscript>
	</cffunction>
	
	
	<cffunction name="getAllByMember" access="public" output="false" returntype="query">
		<cfargument name="member" type="string" required="true" />
		
		<cfset var local = {} />
		
		<cf_sparql name="local.qMemberBookmarks" model="#variables.model#">
			<cf_sparqlns prefix="foaf" uri="#variables.vocab.FOAF.uri#" />
			<cf_sparqlns prefix="dct" uri="#variables.vocab.DCTerms.uri#" />
			<cf_sparqlns prefix="omnom" uri="#variables.vocab.omnom.uri#" />
						
			SELECT DISTINCT ?resource ?title ?notes ?dateCreated ?dateModified
			WHERE {
				?member omnom:bookmarked ?resource.
				?resource dct:title ?title;
						dct:created ?dateCreated.
				
				OPTIONAL { ?resource dct:description ?notes }
				OPTIONAL { ?resource dct:modified ?dateModified }
				
				FILTER (?member = <cf_sparqlparam value="#arguments.member#" type="iri">).
			}
		</cf_sparql>
	
		<cfreturn local.qMemberBookmarks />
	</cffunction>
	
	
	<cffunction name="get" access="public" returntype="query">
		<cfargument name="member" type="string" required="true" />
		<cfargument name="resource" type="string" required="true" />
		
		<cfset var local = {} />
		
		<cf_sparql name="local.qMemberBookmarks" model="#variables.model#">
			<cf_sparqlns prefix="foaf" uri="#variables.vocab.FOAF.uri#" />
			<cf_sparqlns prefix="dct" uri="#variables.vocab.DCTerms.uri#" />
			<cf_sparqlns prefix="omnom" uri="#variables.vocab.omnom.uri#" />
						
			SELECT DISTINCT ?resource ?title ?notes ?dateCreated ?dateModified
			WHERE {
				?member omnom:bookmarked ?resource.
				?resource dct:title ?title;
						dct:created ?dateCreated.
				
				OPTIONAL { ?resource dct:description ?notes }
				OPTIONAL { ?resource dct:modified ?dateModified }
	
				FILTER (?member = <cf_sparqlparam value="#arguments.member#" type="iri">)
				FILTER (?resource = <cf_sparqlparam value="#arguments.resource#" type="iri">)
			}
		</cf_sparql>
	
		<cfreturn local.qMemberBookmarks />
	</cffunction>
	
	
	<cffunction name="create" access="public" output="false" returntype="boolean">
		<cfargument name="member" type="string" required="true" />
		<cfargument name="resource" type="string" required="true" />
		<cfargument name="title" type="string" required="true" />
		<cfargument name="notes" type="string" required="false" default="" />
		
		<cfscript>
			var local = {};
		
			local.bookmark = variables.model.createResource(arguments.resource)
										.addProperty(variables.vocab.RDF.type, variables.vocab.omnom.Resource)
										.addProperty(variables.vocab.DCTerms.title, arguments.title)
										.addProperty(variables.vocab.DCTerms.description, arguments.notes)
										.addProperty(variables.vocab.DCTerms.created, DateFormat(Now(), "yyyy/mm/dd"));
										
			variables.model.getResource(arguments.member)
										.addProperty(variables.vocab.omnom.bookmarked, local.bookmark);
			
		</cfscript>
	
		<cfreturn true />
	</cffunction>
	
	
	<cffunction name="update" access="public" output="false" returntype="boolean">
		<cfargument name="member" type="string" required="true" />
		<cfargument name="resource" type="string" required="true" />
		<cfargument name="title" type="string" required="true" />
		<cfargument name="notes" type="string" required="false" default="" />
		
		<cfscript>
			var local = {};
			
			// Get handles on the member and resource
			local.member = variables.model.getResource(arguments.member);
			local.bookmark = variables.model.getResource(arguments.resource);
			
			// Has this member bookmarked this resource?
			if (local.member.hasProperty( variables.vocab.omnom.bookmarked, local.bookmark ))
			{
				local.bookmark.getProperty(variables.vocab.DCTerms.title).changeObject( arguments.title );
				local.bookmark.getProperty(variables.vocab.DCTerms.description).changeObject( arguments.notes );
				local.bookmark.addProperty(variables.vocab.DCTerms.modified, DateFormat(Now(), "yyyy/mm/dd"));
			}
			else
			{
				addBookmark(arguments.member, arguments.resource, arguments.title, arguments.notes);
			}							
		</cfscript>
	
		<cfreturn true />
	</cffunction>
</cfcomponent>