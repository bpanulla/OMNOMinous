<cfcomponent output="false">
<cfinclude template="functions.cfm">
<cfscript>
	// Get a handle on the Configuration component
	this.config = createObject("component", "AppConfig");
	
	// Wire up application methods and initialize the app
	init = this.config.init;
	onApplicationStart = this.config.onApplicationStart;
	onRequestStart = this.config.onRequestStart;
	
	init();
</cfscript>
</cfcomponent>