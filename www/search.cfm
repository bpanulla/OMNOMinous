<cfparam name="URL.keywords" default="">

<cfset result = "" />

<cfif len(trim(URL.keywords)) GT 2>
	<cfset variables.serviceURI = "http://lookup.dbpedia.org/api/search.asmx/PrefixSearch" />
	
	<cfset variables.search = variables.serviceURI &'?QueryClass=&MaxHits=5&QueryString='& trim(URL.keywords) />
	
	<!---<cfoutput>#variables.search#</cfoutput>--->
	
	<cftry>
		<cfhttp url="#variables.search#" method="get" />
		
		<cfset resultXml = xmlParse(CFHTTP.FileContent)>
		
		<cfif isDefined("resultXml.ArrayOfResult") and arrayLen(resultXml.ArrayOfResult.XmlChildren) GT 0>
			<cfset matches = resultXml.ArrayOfResult.XmlChildren />
			<cfloop index="i" array="#matches#">
				<cfset item = '<li onclick="fill(this)" about="#i["URI"].XmlText#" title="#i["Description"].XmlText#">'>
				<cfset item = item & i["Label"].XmlText>
				<cfset item = item & '</li>'>
				
				<cfset result = result & item  />
			</cfloop>
		<cfelse>
			<cfset result = "<p>No results.</p>" />
		</cfif>

		<cfcatch type="any">
		<cfheader statuscode="500" statustext="Search Error. #cfcatch.message#">
	</cfcatch>
	</cftry>
</cfif>

<cfcontent reset="true">
<cfoutput>#result#</cfoutput>
