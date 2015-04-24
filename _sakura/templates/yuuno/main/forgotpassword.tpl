{% include 'global/header.tpl' %}
    <div class="content news settings">
        <div class="head">Forgot Password</div>
        <form method="post" action="/authenticate" id="passwordForm">
            <input type="hidden" name="redirect" value="//iihsalf.net/" />
            <input type="hidden" name="session" value="{{ php.sessionid }}" />
            <input type="hidden" name="time" value="{{ php.time }}" />
            <input type="hidden" name="mode" value="changepassword" />
            <div class="profile-field">
                <div><h2>Verification Key</h2></div>
                <div style="text-align: center;"><input type="text" name="verk" placeholder="The key that was sent to you in the e-mail" class="inputStyling"{% if auth.forgotKey is not null %} value="{{ auth.forgotKey }}" disabled="disabled"{% endif %} /></div>
            </div>
            <div class="profile-field">
                <div><h2>New Password</h2></div>
                <div style="text-align: center;"><input type="password" name="newpw" placeholder="Your new password, has to be at least 8 characters" class="inputStyling" /></div>
            </div>
            <div class="profile-field">
                <div><h2>Verify Password</h2></div>
                <div style="text-align: center;"><input type="password" name="verpw" placeholder="Your new password again to make sure you didn't typo anything" class="inputStyling" /></div>
            </div>
            <div class="profile-save">
                <input type="submit" value="Save" name="submit" class="inputStyling" /> <input type="reset" value="Reset" name="reset" class="inputStyling" />
            </div>
        </form>
    </div>
{% include 'global/footer.tpl' %}