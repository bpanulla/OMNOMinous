<script src="https://www.idselector.com/selector/c7749d5e1939c42dbf5db85bdac728d02fc5fe91" id="__openidselector" type="text/javascript" charset="utf-8"></script>

<form id="frmOpenIDLogin" method="post" action="login/auth.cfm">
	<fieldset class="panel">
		<legend>OpenID Login</legend>
		
		<input type="hidden" name="cmd" value="auth" />
		
		<div>
			<label for="openid_identifier" style="width:15%">OpenID Identity</label>
			<input id="openid_identifier" name="openid_identity" type="text" value="" />
		</div>
		<div class="controls">
			<input type="submit" value="Log In" />			
		</div>
	</fieldset>
</form>