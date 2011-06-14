<cfparam name="URL.keywords" default="">

<cfset result = "" />

<cfif len(trim(URL.keywords)) GT 2>
	<cfset variables.serviceURI = "http://lookup.dbpedia.org/api/search.asmx/PrefixSearch" />
	
	<cfset variables.search = variables.serviceURI &'?QueryClass=&MaxHits=5&QueryString='& trim(URL.keywords) />
	
	<cftry>
		<cfhttp method="get" url="#variables.search#" />
		
		<cfscript>
			result = "";
			resultXml = xmlParse(CFHTTP.FileContent);
			
			if (isDefined("resultXml.ArrayOfResult") and arrayLen(resultXml.ArrayOfResult.XmlChildren) GT 0)
			{
				itemIter = resultXml.ArrayOfResult.XmlChildren.iterator();
				while( itemIter.hasNext() )
				{
					itemXml = itemIter.next();
					result = result & '<li onclick="fill(this)" about="#itemXml["URI"].XmlText#" title="#itemXml["Description"].XmlText#">#itemXml["Label"].XmlText#</li>';
				}
			}
		</cfscript>

		<cfcatch type="any">
			<cfheader statuscode="500" statustext="Search Error. #cfcatch.message#">
		</cfcatch>
	</cftry>
</cfif>

<cfcontent reset="true" type="text/html">
<cfoutput>#result#</cfoutput>
