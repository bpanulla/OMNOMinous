<cfparam name="attributes.title" default="" />
<cfparam name="attributes.class" default="" />

<cfparam name="application.properties.rootUri" default="/" />

<cfif thisTag.executionMode IS "start">
<cfcontent reset="true">
<!DOCTYPE html>
<html lang="en">
	<head>
		<cfoutput>
		<title>#attributes.title#</title>
		<link rel="stylesheet" type="text/css" href="#application.properties.rootUri#css/style.css" />
		<link rel="stylesheet" type="text/css" href="#application.properties.rootUri#css/forms.css" />
		</cfoutput>
	
		<meta charset="utf-8">
		<!--[if lt IE 9]>
		  <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
	</head>
	<body<cfif len(attributes.class)><cfoutput> class="#attributes.class#"></cfoutput></cfif>>
	
	<header>
		<div id="hdrContainer">
			<div id="hdrLeft">
				<h1><cfoutput><a class="hdr white" href="#application.properties.rootUri#">OMNOMino.us</a></cfoutput></h1>
				<em class="description">In yer folksonomy, semantifyin' yer tagz.</em>
			</div>
			
			<nav>
			    <ul>
					<cfoutput>
					<cfif IsUserLoggedIn()>
						<li><a href="#application.properties.rootUri#logout">Log Out</a></li>
					<cfelse>
						<li><a href="#application.properties.rootUri#login">Log In</a></li>
					</cfif>
				    </cfoutput>
				</ul>
			</nav>
		</div>
	</header>

	<section id="container">
<cfelseif thisTag.executionMode IS "end">
	</section>
	
	<footer>
		<section prefix="dc: http://purl.org/dc/elements/1.1/">
		<p id="copyright" rel="copyright" property="dc:rights">Copyright &copy;
			<cfoutput><span property="dc:dateCopyrighted" content="#Year(now())#">#Year(now())#</span></cfoutput>
			<a href="http://brainpanlabs.com" target="_blank"><span property="dc:publisher" content="Brainpan Labs">Brainpan Labs</span></a>
		</p>
		</section>
	</footer>
	
	</body>
</html>
</cfif>
