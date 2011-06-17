<cfcomponent output="false">
<cfscript>
	function init()
	{
		// Application settings
		this.name = "OMNOMno.us";
		this.applicationTimeout = createTimespan(5,0,0,0);
		this.loginStorage = "session";
		this.clientManagement = false;
		this.sessionManagement = true;
		this.sessionTimeout = createTimespan(0,1,0,0);
		
		// Application environment
		this.webRoot = GetDirectoryFromPath(GetCurrentTemplatePath());
		this.apiRoot = this.webRoot & "api";
		this.projectRoot = createObject("java", "java.io.File")
									.init(this.webRoot)
									.getParent();
		
		this.mappings = {};
		this.mappings["/"] = this.projectRoot & "/src";
		
		// Application properties
		this.properties = {
			    dsn = "nominous",
			    graphname = "DEMO",
				dbtype = "Derby",
			    createModelOnNew = true,
				infLevel = "OWL_DL_MEM",
			    rootUri = "/",
			    webRoot = this.webRoot,
			    apiRoot = this.apiRoot,
			    projectRoot = this.projectRoot,
			    debug = false,
			    resourceFolder = this.projectRoot & "/resources",
			    libFolder = this.projectRoot & "/lib",
				classpath = "",
				mappings = this.mappings
			};
	}
	
	
	function onApplicationStart()
	{
		var local = structNew();
		
		if (not isDefined("application.init"))
		{
			// Set up ColdSpring Object Factory
			local.beanFactory = CreateObject('component', 'coldspring.beans.DefaultXmlBeanFactory')
															.init(defaultProperties=this.properties);
			local.beanFactory.loadBeans(this.properties.resourceFolder & "/coldspring.xml");
			
			// Copy references to properties and bean factory to Application scope
			application.properties = this.properties;
			application.beanFactory = local.beanFactory;
			
			// Save timestamp of application initialization
			application.init = Now();
		}
		
		return true;
	}	

	
	function onRequestStart()
	{
		if ( isDefined("URL.debug") )
		{
			application.properties.debug = URL.debug EQ true;
		}
		
		if ( isDefined("URL.appReset") )
		{
			structDelete(Application, "init");
			onApplicationStart();
			redirect(application.properties.rootUri);
		}
		
		// Check debugging setting
		applySettings( showdebugoutput:application.properties.debug );
		
		return true;
	}
</cfscript>
</cfcomponent>