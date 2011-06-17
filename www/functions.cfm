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


<cffunction name="redirect" access="private" output="false">
	<cfargument name="location" type="string" required="true">	
	<cflocation url="#arguments.location#" addtoken="false" />
</cffunction>


<cffunction name="writeDump">
	<cfargument name="var" type="any" required="true" />
	<cfargument name="expand" type="boolean" required="false" default="true" />
	<cfargument name="abort" type="boolean" required="false" default="false" />
	<cfargument name="format" type="string" required="false" default="html" />
	
	<cfdump var="#arguments.var#" expand="#arguments.expand#" abort="#arguments.abort#" format="#arguments.format#">
	
	<cfif arguments.abort><cfabort /></cfif>
</cffunction>