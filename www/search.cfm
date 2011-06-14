<cfparam name="URL.keywords" default="">

<cfset result = "" />

<cfif len(trim(URL.keywords)) GT 2>
	<cfset variables.serviceURI = "http://lookup.dbpedia.org/api/search.asmx/PrefixSearch" />
	
	<cfset variables.search = variables.serviceURI &'?QueryClass=&MaxHits=5&QueryString='& trim(URL.keywords) />
	
	<cftry>
		<cfhttp method="get" url="#variables.search#" />
		
		<cfscript>
			resultXml = xmlParse(CFHTTP.FileContent);
			
			if (isDefined("resultXml.ArrayOfResult") and arrayLen(resultXml.ArrayOfResult.XmlChildren) GT 0)
			{
				result = arrayNew(1);
				
				itemIter = resultXml.ArrayOfResult.XmlChildren.iterator();
				while( itemIter.hasNext() )
				{
					itemXml = itemIter.next();
					item = {
						about = itemXml["URI"].XmlText,
						description = itemXml["Description"].XmlText,
						label = itemXml["Label"].XmlText
					};
					
					arrayAppend(result, item);
				}
			}
		</cfscript>

		<cfcatch type="any">
			<cfheader statuscode="500" statustext="Search Error. #cfcatch.message#">
		</cfcatch>
	</cftry>
</cfif>

<cfcontent reset="true" type="application/json">
<cfoutput>#serializeJSON(result)#</cfoutput>
