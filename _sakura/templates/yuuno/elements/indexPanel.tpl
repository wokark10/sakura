<div id="indexPanel">
    {% if session.checkLogin %}
        <div class="head">Hi, {{ user.username }}!</div>
        <a href="{{ urls.format('SETTING_MODE', ['appearance', 'avatar']) }}"><img src="{{ urls.format('IMAGE_AVATAR', [user.id]) }}" alt="{{ user.username }}" class="default-avatar-setting homepage-menu-avatar" /></a>
        <ul class="panelQuickLinks">
            <li><a href="{{ urls.format('SETTING_MODE', ['friends', 'requests']) }}" title="Pending friend requests"><span class="fa fa-user-plus"></span><span class="count">{{ user.friends(-1, true)|length }}</span></a></li>
            <li><a href="{{ urls.format('MESSAGES_INDEX') }}" title="View private messages"><span class="fa fa-envelope"></span><span class="count">0</span></a></li>
        </ul>
        <div class="clear"></div>
    {% else %}
        {% if sakura.lockAuth %}
            <div class="head">Whoops!</div>
            You caught the site at the wrong moment! Right now registration <i>and</i> logging in is disabled for unspecified reasons. Sorry for the inconvenience but please try again later!
            <div class="indexSidePanelLinks">
                <a class="fa fa-lock" href="#" title="Authentication is locked"></a>
            </div>
        {% else %}
            <div class="head">Welcome!</div>
            Welcome to Flashii! This is a site for a bunch of friends to hang out, nothing special. Anyone is pretty much welcome to register so why not have a go?
            <div class="indexSidePanelLinks">
                <a class="fa fa-magic" href="{{ urls.format('SITE_REGISTER') }}" title="Register" id="indexSidePanelRegister"></a>
                <a class="fa fa-sign-in" href="{{ urls.format('SITE_LOGIN') }}" title="Login" id="indexSidePanelLogin"></a>
            </div>
        {% endif %}
    {% endif %}
    <div class="head">Stats</div>
    We have <b>{{ stats.userCount }} user{% if stats.userCount != 1 %}s{% endif %}</b>,
    <b><a href="{{ urls.format('USER_PROFILE', [stats.newestUser.id]) }}" style="color: {{ stats.newestUser.colour }};" class="default">{{ stats.newestUser.username }}</a></b> is the newest user,
    it has been <b>{{ stats.lastRegDate }}</b> since the last user registered and the forum has <b>{{ stats.topicCount }} thread{% if stats.topicCount != 1 %}s{% endif %}</b> and <b>{{ stats.postCount }} post{% if stats.postCount != 1 %}s{% endif %}</b>.
    <div class="head">Online Users</div>
    {% if stats.onlineUsers %}
        All active users in the past {{ sakura.onlineTimeout / 60 }} minute{% if sakura.onlineTimeout != 60 %}s{% endif %}:<br />
        {% for amount,onlineUser in stats.onlineUsers %}
            <a href="{{ urls.format('USER_PROFILE', [onlineUser.id]) }}" style="font-weight: bold; color: {{ onlineUser.colour }};" class="default">{{ onlineUser.username }}</a>{% if amount != (stats.onlineUsers|length - 1) %}, {% endif %}
        {% endfor %}
    {% else %}
        There were no online users in the past {{ sakura.onlineTimeout / 60 }} minute{% if sakura.onlineTimeout != 60 %}s{% endif %}.
    {% endif %}
    {#<div class="ad-container ad-sidebar" id="sideAd">
        <div class="head">Advertisment</div>
        <div class="ad-box">
            <img src="http://i.flash.moe/1445793369-523-9238.png" />
            <div><a href="#">Click here to meow!</a></div>
        </div>
    </div>#}
</div>
