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
						
			SELECT DISTINCT ?resource ?location ?title ?notes ?dateCreated ?dateModified ?tag
			WHERE {
				?member omnom:bookmarked ?resource.
				?resource foaf:page ?location;
						dct:title ?title;
						dct:created ?dateCreated.
						
				OPTIONAL { ?resource foaf:topic ?tag }
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
						
			SELECT DISTINCT ?resource ?location ?title ?notes ?dateCreated ?dateModified ?tag
			WHERE {
				?member omnom:bookmarked ?resource.
				?resource foaf:page ?location;
						dct:title ?title;
						dct:created ?dateCreated.
				
				OPTIONAL { ?resource foaf:topic ?tag }
				OPTIONAL { ?resource dct:description ?notes }
				OPTIONAL { ?resource dct:modified ?dateModified }
				
				FILTER (?member = <cf_sparqlparam value="#arguments.member#" type="iri">)
				FILTER (?resource = <cf_sparqlparam value="#arguments.resource#" type="iri">)
			}
		</cf_sparql>
	
		<cfreturn local.qMemberBookmarks />
	</cffunction>
	
	
	<cffunction name="create" access="public" output="false" returntype="string">
		<cfargument name="member" type="string" required="true" />
		<cfargument name="location" type="string" required="true" />
		<cfargument name="title" type="string" required="true" />
		<cfargument name="notes" type="string" required="false" default="" />
		<cfargument name="tag" type="array" required="false" />
		
		<cfscript>
			var local = {};
			local.resource = "http://omnomino.us/resource/" & createUUID();
			
			local.bookmark = variables.model.createResource(local.resource)
										.addProperty(variables.vocab.RDF.type, variables.vocab.omnom.Member)
										.addProperty(variables.vocab.FOAF.page, arguments.location)
										.addProperty(variables.vocab.DCTerms.title, arguments.title)
										.addProperty(variables.vocab.DCTerms.description, arguments.notes)
										.addProperty(variables.vocab.DCTerms.created, DateFormat(Now(), "yyyy/mm/dd"));
			
			for (i = 1; i <= arrayLen(tag); i = i + 1)
			{
				local.bookmark.addProperty(variables.vocab.FOAF.topic, tag[i]);
			}
			
			variables.model.getResource(arguments.member)
										.addProperty(variables.vocab.omnom.bookmarked, local.bookmark);
			
		</cfscript>
			
		<cfreturn local.resource />
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
		</cfscript>
	
		<cfreturn true />
	</cffunction>
	
	
	<cffunction name="delete" access="public" output="false" returntype="boolean">
		<cfargument name="member" type="string" required="true" />
		<cfargument name="resource" type="string" required="true" />
		
		<cfscript>
			var local = {};
			
			// Get handles on the member and resource
			local.member = variables.model.getResource(arguments.member);
			local.bookmark = variables.model.getResource(arguments.resource);
			
			// Has this member bookmarked this resource?
			if (local.member.hasProperty( variables.vocab.omnom.bookmarked, local.bookmark ))
			{
				// Clean up any references to this bookmark
				variables.model.removeAll( subject:local.bookmark );
				variables.model.removeAll( subject:local.member, predicate:variables.vocab.omnom.bookmarked, object:local.bookmark );
			}
		</cfscript>
	
		<cfreturn true />
	</cffunction>
</cfcomponent>