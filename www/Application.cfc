<cfcomponent output="false">
	
	<!--- Application settings --->
	<cfscript>
		this.name = "Nominous";
		this.applicationTimeout = createTimespan(5,0,0,0);
		this.loginStorage = "session";
		this.clientManagement = false;
		this.sessionManagement = true;
		this.sessionTimeout = createTimespan(0,1,0,0);
	
		this.webRoot = GetDirectoryFromPath(GetCurrentTemplatePath());
		this.projectRoot = createObject("java", "java.io.File")
									.init(this.webRoot)
									.getParent();
		
		this.mappings = {};
		this.mappings["/"] = this.webRoot;
		this.mappings["/include"] = this.projectRoot & "/src/include";
		this.mappings["/nominous"] = this.projectRoot & "/src/nominous";
		
		this.properties = {
			    dsn = "nominous",
			    graphname = "DEMO",
				dbtype = "Derby",
			    createModelOnNew = true,
				infLevel = "OWL_DL_MEM",
			    rootUri = "/",
			    webRoot = this.webRoot,
			    projectRoot = this.projectRoot,
			    debug = false
			};
    </cfscript>
    
    <!--- ========================================================================================================== \
	|	Application
	\ =========================================================================================================== --->

	<cffunction name="onApplicationStart" returntype="boolean" output="false">
		<cfscript>
			var local = structNew();
			
			// Derived filesystem paths
			local.properties = this.properties;
			local.properties.resourceFolder = this.projectRoot & "/resources";
						
			// Set up ColdSpring Object Factory
			local.beanFactory = CreateObject('component', 'coldspring.beans.DefaultXmlBeanFactory')
															.init(defaultProperties=local.properties);
			local.beanFactory.loadBeans(local.properties.resourceFolder & "/coldspring.xml");
			
			application.properties = local.properties;
			application.beanFactory = local.beanFactory;
			
			// Save timestamp of application initialization
			application.init = Now();
		</cfscript>

		<cfreturn true />
	</cffunction>
	
	<cffunction name="onApplicationEnd" returntype="boolean" output="false">
		<cfreturn true />
	</cffunction>


	<!--- ========================================================================================================== \
	|	Session
	\ =========================================================================================================== --->

	<cffunction name="onSessionStart" returntype="boolean" output="false">
		<cfreturn true />
	</cffunction>

	<cffunction name="onSessionEnd" returntype="boolean" output="false">
		<cfreturn true />
	</cffunction>

	<!--- ========================================================================================================== \
	|	Request
	\ =========================================================================================================== --->

	<cffunction name="onRequestStart" returntype="boolean" output="false">
		<cfargument name="request" required="true" />

		<cfif isDefined("URL.debug")>
			<cfset application.properties.debug = URL.debug EQ true />
		</cfif>

		<cfif isDefined("URL.appReset")>
			<cfset onApplicationStart() />
		</cfif>

		<cfsetting enablecfoutputonly="false" showdebugoutput="#application.properties.debug#" />

		<!--- ******************************************************************\
	    | Session authentication/authorization
	 	\******************************************************************* --->
	 	<cflogin>
			<cfinclude template="/include/auth.cfm">
		</cflogin>
		
		<cfreturn true />
	</cffunction>

	<cffunction name="onRequestEnd" returntype="boolean" output="false">
		<cfreturn true />
	</cffunction>
</cfcomponent>