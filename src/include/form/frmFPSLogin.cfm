<form id="frmFPSLogin" method="post" action="login/auth.cfm">
	<fieldset class="panel">
		<legend><a href="https://fps.psu.edu/">Friends of Penn State</a> Login</legend>
		
		<input type="hidden" name="cmd" value="fps" />
		
		<div>
			<label for="username">Username</label>
			<input id="username" name="username" type="text" />
		</div>
		<div>
			<label for="password">Password</label>
			<input id="password" name="password" type="password" />
		</div>
		<div class="controls">
			<input type="submit" value="Log In"/>
		</div>
	</fieldset>
</form>