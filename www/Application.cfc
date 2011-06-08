<cfcomponent output="false">
	
	<!--- Application settings --->
	<cfscript>
		this.name = "OMNOMno.us";
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
		this.mappings["/"] = this.projectRoot & "/src";
		
		this.properties = {
			    dsn = "nominous",
			    graphname = "DEMO",
				dbtype = "Derby",
			    createModelOnNew = true,
				infLevel = "OWL_DL_MEM",
			    rootUri = "/omnominous/",
			    webRoot = this.webRoot,
			    projectRoot = this.projectRoot,
			    debug = false,
			    resourceFolder = this.projectRoot & "/resources",
			    libFolder = this.projectRoot & "/lib",
				classpath = ""
			};
    </cfscript>
    
    <!--- ========================================================================================================== \
	|	Application
	\ =========================================================================================================== --->

	<cffunction name="onApplicationStart" returntype="boolean" output="false">
		<cfscript>
			var local = structNew();
			
			// Set up ColdSpring Object Factory
			local.beanFactory = CreateObject('component', 'coldspring.beans.DefaultXmlBeanFactory')
															.init(defaultProperties=this.properties);
			local.beanFactory.loadBeans(this.properties.resourceFolder & "/coldspring.xml");
			
			// Copy references to properties and bean factory to Application scope
			application.properties = this.properties;
			application.beanFactory = local.beanFactory;
			
			// Save timestamp of application initialization
			application.init = Now();
			
			return true;
		</cfscript>
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

		<cfscript>
			if ( isDefined("URL.debug") )
			{
				application.properties.debug = URL.debug EQ true;
			}
			
			if ( isDefined("URL.appReset") )
			{
				onApplicationStart();
			}
		</cfscript>

		<!--- ******************************************************************\
	    | Session authentication/authorization
	 	\******************************************************************* --->
	 	<cflogin>
		 	<!--- Check for member profile seed in session; if this struct exists,
			 	log the user into the application --->
			<cfif ( isDefined("session.member") )>
				<cfloginuser
					name="#session.member.uri#"
					roles="#session.member.roles#"
					password="" />
			</cfif>
		</cflogin>
		
		<cfsetting enablecfoutputonly="false" showdebugoutput="#application.properties.debug#" />

		<cfreturn true />
	</cffunction>

	<cffunction name="onRequestEnd" returntype="boolean" output="false">
		<cfreturn true />
	</cffunction>

</cfcomponent>