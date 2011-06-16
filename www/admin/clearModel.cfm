<cfmodule template="/include/layout.cfm" title="Clear Model">
	<h1>Clear Model</h1>
	
	<cfscript>
		if (isDefined("form.ack") AND form.ack EQ "YES")
		{
			application.beanFactory.getBean("persistentModel")
					.removeAll();
			
			application.beanFactory.getBean("model")
					.removeAll();
					
			WriteOutput('<p class="info">Model cleared.<p>');
		}
	</cfscript>

	<cfoutput>
		<form name="frmClearModel" method="post" action="#CGI.SCRIPT_NAME#">
			<fieldset class="panel">
			<div>
				<label for="ack">Enter YES to clear model.</label>
				<input id="ack" name="ack" type="text" />
			</div>
			<div class="controls">
				<input type="submit" value="clear" />
			</div>
			</fieldset>
		</form>
	</cfoutput>
</cfmodule>