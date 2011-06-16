<div id="content">
	
<cfif IsUserLoggedIn()>
	<cfscript>
		bookmarks = application.beanFactory.getBean("bookmarkModel").getAllByMember(getAuthUser());
	</cfscript>
	
	<h2>My Bookmarks</h2>
	<cfif bookmarks.recordcount GT 0>
		<ul class="bookmarks">
		<cfoutput query="bookmarks" group="resource">
			<li>
				<ul class="cmd">
					<li><a href="edit.cfm?resource=#URLEncodedFormat(bookmarks.resource)#">Edit</a></li>
					<li><a href="delete.cfm?resource=#URLEncodedFormat(bookmarks.resource)#">Delete</a></li>
				</ul>
				<h2><a href="#bookmarks.location#">#bookmarks.title#</a></h3>
				<div>Created #bookmarks.dateCreated#</div>
				<ul class="tags">
					<cfoutput><li about="#bookmarks.tag#"><a href="#bookmarks.tag#">#listLast(bookmarks.tag,"/")#</a></li></cfoutput>
				</ul>
				<p>#bookmarks.notes#</p>
			</li>
		</cfoutput>
		</ul>
	<cfelse>
		<p>No bookmarks.</p>
	</cfif>
<cfelse>
<div id="ihazaflavor">
	<img src="img/nom.jpg" height="450px">
</div>
</cfif>

</div>
