<cfcomponent extends="org.panulla.semweb.VocabularyModel">
	
	<cfset variables.uri = "http://omnomino.us/ontology##" />
	
	<cffunction name="init" access="public" hint="Constructor" returntype="Vocabulary" output="false">
		<cfargument name="loader" type="org.panulla.util.JavaLoaderFacade" required="false">
		
		<cfscript>
			var local = {};
			
			if (isDefined("arguments.loader"))
			{
				super.init(arguments.loader);
			}
			else
			{
				// Instantiate a default loader
				super.init();
			}
			
			variables.m = application.beanFactory.getBean("modelFactory").getModel();
			
			this.omnom = {
				uri = variables.uri,
				Member = variables.m.createResource( variables.uri & "Member" ),
				bookmarked = variables.m.createProperty( variables.uri & "bookmarked" ),
				Resource = variables.m.createResource( variables.uri & "Resource" )
			};
			
			return this;
		</cfscript>
	</cffunction>

</cfcomponent>