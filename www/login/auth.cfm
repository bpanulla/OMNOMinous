<!--- Default command --->
<cfparam name="form.cmd" type="string" default="process" />
<cfparam name="form.username" default="" />
<cfparam name="form.password" default="" />

<cfscript>	
	authType = "OpenID";
	success = false;
	newUser = false;
	message = "";
	
	if ( form.cmd eq "auth" )
	{
		oConsumer = CreateObject("component", "OpenID.OpenIDConsumer2").init();
	
		ax = {
				realm = "http://omnomino.us",
				email = "http://axschema.org/contact/email",
				fullname = "http://axschema.org/namePerson",
				firstname = "http://axschema.org/namePerson/first",
				lastname = "http://axschema.org/namePerson/last",
				nickname = "http://axschema.org/namePerson/friendly"
			};
	
		authArgs = {
				identifier = form.openid_identity,
				returnURL = "http#IIF(cgi.https eq 'on',DE('s'),DE(''))#://#cgi.http_host##cgi.script_name#",
				sregRequired = "nickname",
				sregOptional = "email,fullname,dob,country",
				axRequired = "email,fullname,firstname,lastname,nickname",
				ax = ax
			};
			
		if ( oConsumer.authenticate(authArgs) )
		{
			success = true;
		}
		else
		{
			message = "Can't find OpenID server";
		}
	}
	else if ( form.cmd eq "process" )
	{
		oConsumer = CreateObject("component", "OpenID.OpenIDConsumer2").init();
		creds = oConsumer.verifyAuthentication();
		
		success = creds.result is "success";
		message = creds.resultMsg;
	}
	else if ( form.cmd eq "fps" )
	{
		authType = "FPS";
		
		oConsumer = createObject("component", "psu.FPSConsumer" );
	
		// Where to send the user after login? Default is login error screen
		local.location = "index.cfm##frmPasswordLogin?msg=fail";
		
		authArgs = {
			username = trim(form.username),
			password = trim(form.password)
		};
	
		if ( oConsumer.authenticate( authArgs ) )
		{
			success = true;
		}

		creds = oConsumer.verifyAuthentication();
	}
	else
	{
		authType = "Unknown";
		message = "Unknown authentication type.";
	}
	
	if ( success )
	{
		memberModel = application.beanFactory.getBean("memberModel");

		userID = "";

		if ( not memberModel.openIdExists( creds.user_identity ) )
		{
			newUser = true;
			userID = memberModel.addUser( creds );
		}
		else
		{
			userID = memberModel.getOpenIDUser( creds.user_identity );
		}

		// Get user credentials		
		userProfile = memberModel.getUser( userID );
		
		member = {
			uri = userID,
			fullname = userProfile.fullname,
			nickname = userProfile.nickname,
			email = userProfile.email,
			roles = memberModel.getRoles(userID)
		};
		
		// Copy credentials to the session scope
		session.member = member;
	}
</cfscript>

<cfmodule template="/include/layout.cfm" title="Authentication">
	<section style="text-align:left">
	<cfoutput>	
	<h3>#authType# Result</h3>
	
	<cfif success>
		<p class="info">INFO: <span>#creds.resultMsg#</span></p>
		<p class="info">New User: <span>#newUser#</span></p>
		<p><a href="..">&larr; go Home</a></p>
	<cfelse>
		<p class="error">ERROR: <span>#creds.resultMsg#</span></p>
		<p><a href="index.cfm">&larr; go back</a></p>
	</cfif>
	</cfoutput>
	
	<cfdump var="#creds#">
	</section>
</cfmodule>