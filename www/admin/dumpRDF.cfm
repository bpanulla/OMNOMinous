<cfmodule template="/include/layout.cfm" title="Dump Model to RDF">
	<h1>Dump Model</h1>
	
	<cfset formats = {
			rdf = { type= "RDF/XML-ABBREV", name= "RDF/XML", default= false },
			n3 = { type= "N3", name= "Notation-3", default= true },
			nt = { type= "N-TRIPLE", name= "N-Triples", default= false },
			ttl = { type= "TTL", name= "Turtle", default= false }
	} />
	
	<cfparam name="form.dumpformat" default="N3">
	
	<cfif isDefined("form.dump") and structKeyExists(formats, form.dumpformat)>
		<cfscript>
		output = "Initializing...";
		
		try
		{
			model = application.beanFactory.getBean('persistentModel');
			exportPath = application.properties.dataFolder & "/modeldump-"
							& DateFormat(Now(), 'yyyymmdd-')
							& TimeFormat(now(), 'HHmm.ss')
							& "." & LCase(form.dumpformat);
			
			message = "Dumping model... ";
			output = model.dump( formats[form.dumpformat].type );

			message = message & "complete. Writing to " & exportPath & "...";			
			fileWrite( exportPath, output );

			message = message & " done.";			
		}
		catch (any e)
		{	
			message = message & " Failed: " & e.message;
		}
		</cfscript>
		
		<cfoutput>
		<p>#message#</p>
		
		<a href="#CGI.SCRIPT_NAME#">Back</a>
		</cfoutput>
		
	<cfelse>
		<cfoutput>
		<form name="frmRDFUpload" enctype="multipart/form-data" method="post" action="#CGI.SCRIPT_NAME#">
			<div>
				<select name="dumpformat">
				<cfloop index="thisFormat" list="#listSort(structKeyList(formats), "text")#">
					<option value="#LCase(thisFormat)#" <cfif formats[thisFormat].default>selected</cfif>>#formats[thisFormat].name# (.#LCase(thisFormat)#)</option>
				</cfloop>
				
				</select>
				<input name="dump" type="submit" value="Dump" />
			</div>
		</form>
		</cfoutput>
		
	</cfif>

</cfmodule>