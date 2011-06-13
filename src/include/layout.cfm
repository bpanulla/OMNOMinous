﻿<cfparam name="attributes.title" default="" />
<cfparam name="attributes.class" default="" />

<cfparam name="application.properties.rootUri" default="/" />

<cfif thisTag.executionMode IS "start">
<cfcontent reset="true">
<!DOCTYPE html>
<html>
	<head>
		<cfoutput>
		<title>#attributes.title#</title>
		<base href="#application.properties.rootUri#">
		</cfoutput>
		
		<meta charset="utf-8">
		<link rel="stylesheet" media="all" type="text/css" href="css/style.css" />
		<link rel="stylesheet" media="all" type="text/css" href="css/forms.css" />
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.8/jquery-ui.min.js"></script>
		
		<!--[if lt IE 9]>
		  <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
	</head>
	<body lang="en"<cfif len(attributes.class)><cfoutput> class="#attributes.class#"></cfoutput></cfif>>
	
	<header>
		<div class="wrapper">
			<div id="masthead">
				<h1><a href=".">OMNOMino.us</a></h1>
				<em class="description">In yer folksonomy, semantifyin' yer tagz.</em>
			</div>
				
			<nav>
			    <ul>
				<cfif IsUserLoggedIn()>
					<li><a href="add.cfm">New Bookmark</a></li>
					<li><a href="logout">Log Out</a></li>
				<cfelse>
					<li><a href="login">Log In</a></li>
				</cfif>
				</ul>
			</nav>
		</div>
	</header>
	
	<section id="content">
	<div class="wrapper">
<cfelseif thisTag.executionMode IS "end">
	</div> <!--- id="content" --->
	</section>
	
	<footer>
	<div class="wrapper">
		<div prefix="dc: http://purl.org/dc/elements/1.1/">
		<p id="copyright" rel="copyright" property="dc:rights">Copyright &copy;
			<cfoutput><span property="dc:dateCopyrighted" content="#Year(now())#">#Year(now())#</span></cfoutput>
			<a href="http://brainpanlabs.com" target="_blank"><span property="dc:publisher" content="Brainpan Labs">Brainpan Labs</span></a>
		</p>
		</div>
	</div>
	</footer>
	
	</div> <!-- id="wrapper" --->
	</body>
</html>
</cfif>
