<cfparam name="form.query" type="string" default="" />
<cfparam name="form.inferencing" type="boolean" default="false" />


<cfsavecontent variable="sampleSparql">
SELECT ?subj ?pred ?obj
WHERE {
	?subj ?pred ?obj
}
</cfsavecontent>


<cfmodule template="/include/layout.cfm" title="SPARQL">
	
	<cfif trim(form.query) NEQ "">
		<div id="sparqlResults">
		<cftry>
			<cfset variables.vocab = application.beanFactory.getBean("vocab") />
			
			<cfif form.inferencing>
				<cfset modelBean = "persistentModel" />
			<cfelse>
				<cfset modelBean = "model" />
			</cfif>
			
			<cfset variables.model = application.beanFactory.getBean(modelBean) />


			<cf_sparql name="qryToRun" model="# variables.model#" debug="true">
				
				<cf_sparqlns prefix="rdf" uri="#variables.vocab.RDF.uri#" />
				<cf_sparqlns prefix="rdfs" uri="#variables.vocab.RDFS.uri#" />
				<cf_sparqlns prefix="owl" uri="#variables.vocab.OWL.uri#" />
				<cf_sparqlns prefix="foaf" uri="#variables.vocab.FOAF.uri#" />
				<cf_sparqlns prefix="dct" uri="#variables.vocab.DCTerms.uri#" />
				<cf_sparqlns prefix="xsd" uri="#variables.vocab.XSD.uri#" />
				<cf_sparqlns prefix="omnom" uri="#variables.vocab.omnom.uri#" />
				
				<cfoutput>#form.query#</cfoutput>
			</cf_sparql>
			
			<h3><cfoutput>Results (#qryToRun.recordcount#)</cfoutput></h3>
			<table>
				
				<thead>
				<tr>
					<cfoutput>
					<cfloop index="binding" list="#qryToRun.ColumnList#">
					<th>#binding#</th>
					</cfloop>
					</cfoutput>
					<th style="width:12px"></th>		
				</tr>
				</thead>
			
				<tbody style="height:300px;overflow-y:scroll;overflow-x:hidden;">
				<cfoutput query="qryToRun">
				<cfif qryToRun.CurrentRow MOD 2><tr class="on"><cfelse><tr></cfif>
					<cfloop index="binding" list="#qryToRun.ColumnList#">
						<td><cfif trim(qryToRun[binding][qryToRun.CurrentRow]) NEQ "">
									#qryToRun[binding][qryToRun.CurrentRow]#
								<cfelse>
									&nbsp;
								</cfif>
						</td>
					</cfloop>
					<td style="width:12px"></td>		
				</tr>
				</cfoutput>
				</tbody>
			
			</table>
	
			<cfcatch type="any">
				<cfdump var="#cfcatch#">
				<!---<cfset error = { type = cfcatch.type, detail = cfcatch.detail, message = cfcatch.message } />--->
			</cfcatch>
		</cftry>
		
		<cfif isDefined("error")>
			<cfdump var="#error#">
		</cfif>
		
		</div>
	
	<cfelse>
		<cfset form.query = sampleSparql />
	</cfif>
	
	<h2>Query</h2>
	<cfoutput>
		<form name="sparql" method="post" action="#CGI.SCRIPT_NAME#">
			<fieldset>
				<div>
					<label for="inferencing">Use Inferencing?</label>
					<select name="useInferencing"><option>Yes</option><option>No</option></select>
				</div>
				<div>
					<textarea name="query" rows="20" cols="80">#form.query#</textarea>
				</div>
				<div id="controls">
					<input type="submit" value="run" />
				</div>
			</fieldset>
		</form>
	</cfoutput>
</cfmodule>