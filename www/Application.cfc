<cfcomponent output="false">
<cfscript>

	// Application settings
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
		    rootUri = "/",
		    webRoot = this.webRoot,
		    projectRoot = this.projectRoot,
		    debug = false,
		    resourceFolder = this.projectRoot & "/resources",
		    libFolder = this.projectRoot & "/lib",
			classpath = ""
		};
    
	/* ========================================================================================================== \
	|	Application
	\ =========================================================================================================== */

	function onApplicationStart()
	{
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
	}	
	
	function onApplicationEnd() { return true; }

	/* ========================================================================================================== \
	|	Session
	\ =========================================================================================================== */

	function onSessionStart() { return true; }
	
	function onSessionEnd() { return true; }

	/* ========================================================================================================== \
	|	Request
	\ =========================================================================================================== */

	function onRequestStart( request ) {
		if ( isDefined("URL.debug") )
		{
			application.properties.debug = URL.debug EQ true;
		}
		
		if ( isDefined("URL.appReset") )
		{
			onApplicationStart();
		}
		
		// Check debugging setting
		applySettings( showdebugoutput:application.properties.debug );
	}
	
	function onRequestEnd() { return true; }

</cfscript>


<!--- ========================================================================================================== \
|	Helper functions that require tag syntax
\ =========================================================================================================== --->

<cffunction name="applySettings" access="private" output="false">
	<cfargument name="enablecfoutputonly" type="boolean" default="false">	
	<cfargument name="showdebugoutput" type="boolean" default="false">
	<cfargument name="requesttimeout" type="numeric" default="30">

	<cfsetting enablecfoutputonly="#arguments.enablecfoutputonly#"
			   requesttimeout="#arguments.requesttimeout#"
			   showdebugoutput="#arguments.showdebugoutput#" />
</cffunction>

</cfcomponent>