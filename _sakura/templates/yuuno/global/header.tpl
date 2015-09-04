<!DOCTYPE html>
<html>
    <head>
        <!-- META -->
        <meta charset="{{ sakura.charset }}" />
        <title>{{ page.title }}</title>
        <meta name="description" content="{{ sakura.siteDesc }}" />
        <meta name="keywords" content="{{ sakura.siteTags }}" />
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
        <meta name="msapplication-TileColor" content="#fbeeff" />
        <meta name="msapplication-TileImage" content="/content/images/icons/ms-icon-144x144.png" />
        <meta name="theme-color" content="#9475B2" />
        {% if page.redirect %}
            <meta http-equiv="refresh" content="3; URL={{ page.redirect }}" />
        {% endif %}
        <link rel="apple-touch-icon" sizes="57x57" href="/content/images/icons/apple-icon-57x57.png" />
        <link rel="apple-touch-icon" sizes="60x60" href="/content/images/icons/apple-icon-60x60.png" />
        <link rel="apple-touch-icon" sizes="72x72" href="/content/images/icons/apple-icon-72x72.png" />
        <link rel="apple-touch-icon" sizes="76x76" href="/content/images/icons/apple-icon-76x76.png" />
        <link rel="apple-touch-icon" sizes="114x114" href="/content/images/icons/apple-icon-114x114.png" />
        <link rel="apple-touch-icon" sizes="120x120" href="/content/images/icons/apple-icon-120x120.png" />
        <link rel="apple-touch-icon" sizes="144x144" href="/content/images/icons/apple-icon-144x144.png" />
        <link rel="apple-touch-icon" sizes="152x152" href="/content/images/icons/apple-icon-152x152.png" />
        <link rel="apple-touch-icon" sizes="180x180" href="/content/images/icons/apple-icon-180x180.png" />
        <link rel="icon" type="image/png" sizes="192x192"  href="/content/images/icons/android-icon-192x192.png" />
        <link rel="icon" type="image/png" sizes="32x32" href="/content/images/icons/favicon-32x32.png" />
        <link rel="icon" type="image/png" sizes="96x96" href="/content/images/icons/favicon-96x96.png" />
        <link rel="icon" type="image/png" sizes="16x16" href="/content/images/icons/favicon-16x16.png" />
        <link rel="manifest" href="/manifest.json" />
        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="{{ sakura.resources }}/css/yuuno.css" />
        {% if page.style %}
        <style type="text/css">
            {% for element,properties in page.style %}
                {{ element|raw }} {
                    {% for property,value in properties %}
                        {{ property|raw }}: {{ value|raw }};
                    {% endfor %}
                }
            {% endfor %}
        </style>
        {% endif %}
        <!-- JS -->
        <script type="text/javascript" src="{{ sakura.resources }}/js/yuuno.js"></script>
        <script type="text/javascript">

            // Create an object so we can access certain settings from remote JavaScript files
            var sakuraVars = {

                "cookie": {

                    "prefix":   "{{ sakura.cookie.prefix }}",
                    "domain":   "{{ sakura.cookie.domain }}",
                    "path":     "{{ sakura.cookie.path }}"

                },

                "urlMain":          "{{ sakura.urlMain }}",
                "content":          "{{ sakura.contentPath }}",
                "resources":        "{{ sakura.resources }}",
                "recaptchaEnabled": "{{ sakura.recaptchaEnabled }}",

                "minUserLen":       {{ sakura.minUsernameLength }},
                "maxUserLen":       {{ sakura.maxUsernameLength }},
                "minPwdEntropy":    {{ sakura.minPwdEntropy }},
                "checkLogin":       {% if session.checkLogin %}true{% else %}false{% endif %}

            };

        // Space for things that need to happen onload
        window.addEventListener("load", function() {

            // Alter the go to top button
            var gotop = document.getElementById('gotop');
            gotop.setAttribute('href',      'javascript:void(0);');
            gotop.setAttribute('onclick',   'scrollToTop();');

            {% if session.checkLogin %}
            // Convert href to object in logout link
            prepareAjaxLink('headerLogoutLink', 'submitPost', ', true, "Logging out..."');
            {% elseif not sakura.lockAuth and php.self != '/authenticate.php' %}
            // Make the header login form dynamic
            var headerLoginForm = document.getElementById('headerLoginForm');
            var createInput     = document.createElement('input');
            var submit          = headerLoginForm.querySelector('[type="submit"]');

            createInput.setAttribute('name', 'ajax');
            createInput.setAttribute('value', 'true');
            createInput.setAttribute('type', 'hidden');
            headerLoginForm.appendChild(createInput);

            submit.setAttribute('type', 'button');
            submit.setAttribute('onclick', 'submitPost(\''+ headerLoginForm.action +'\', formToObject(\'headerLoginForm\'), true, \'Logging in...\');');
            {% endif %}

            {% if session.checkLogin %}
            // Make notification requests (there's a seperate one to make it happen before the first 60 seconds)
            notifyRequest('{{ php.sessionid }}');

            // Create interval
            setInterval(function() {
                notifyRequest('{{ php.sessionid }}');
            }, 60000);
            {% endif %}

            {% if php.self == '/profile.php' and session.checkLogin and user.data.id != profile.user.id %}
            // Make friend button dynamic
            prepareAjaxLink('profileFriendToggle', 'submitPost', ', true, "{% if profile.friend == 0 %}Adding{% else %}Removing{% endif %} friend..."');
            {% endif %}

            {% if php.self == '/viewtopic.php' and session.checkLogin %}
                var forumFriendToggles = document.querySelectorAll('.forum-friend-toggle');

                for(var i in forumFriendToggles) {
                    prepareAjaxLink(forumFriendToggles[i], 'submitPost', ', true, "Please wait..."');
                }
            {% endif %}

            {% if php.self == '/authenticate.php' and not sakura.lockAuth %}
            // AJAX Form Submission
            var forms = {
                {% if not auth.changingPass %}
                "loginForm": 'Logging in...',
                {% if not sakura.disableRegistration %}"registerForm": 'Processing registration...',{% endif %}
                {% if not sakura.requireActivation %}"resendForm": 'Attempting to resend activation...',{% endif %}
                "passwordForm": 'Sending password recovery mail...'
                {% else %}
                "passwordForm": 'Changing password...'
                {% endif %}
            };

            for(var i in forms) {
                var form    = document.getElementById(i);
                var submit  = form.querySelector('[type="submit"]');

                form.setAttribute('onkeydown', 'formEnterCatch(event, \''+ submit.id +'\');');

                submit.setAttribute('href',     'javascript:void(0);');
                submit.setAttribute('onclick',  'submitPost(\''+ form.action +'\', formToObject(\''+ i+ '\'), true, \''+ forms[i] +'\', '+ (i == 'registerForm' ? 'true' : 'false') +');');
                submit.setAttribute('type',     'button');

                var createInput = document.createElement('input');
                createInput.setAttribute('name', 'ajax');
                createInput.setAttribute('value', 'true');
                createInput.setAttribute('type', 'hidden');
                form.appendChild(createInput);
            }
            {% endif %}

            {% if php.self == '/profile.php' ? profile.data.userData.profileBackground : (user.checkPermission('SITE', 'CREATE_BACKGROUND') and user.data.userData.userOptions.profileBackgroundSiteWide and user.data.userData.profileBackground) %}
                initialiseParallax('userBackground');
            {% endif %}

        });
        </script>
    </head>
    <body>
        <div id="container">
            <span id="top"></span>
            <div class="header" id="header">
                <a class="logo" href="//{{ sakura.urlMain }}/">{{ sakura.siteName }}</a>
                <div class="menu">
                    <div class="menu-nav fa" id="navMenuSite">
                        <!-- Navigation menu, displayed on left side of the bar. -->
                        <a class="menu-item fa-home" href="{{ urls.format('SITE_HOME') }}" title="Home"></a>
                        <a class="menu-item fa-newspaper-o" href="{{ urls.format('SITE_NEWS') }}" title="News"></a>
                        <a class="menu-item fa-commenting" href="//chat.{{ sakura.urlMain }}/" title="Chat"></a>
                        <a class="menu-item fa-list" href="{{ urls.format('FORUM_INDEX') }}" title="Forums"></a>
                        <a class="menu-item fa-search" href="{{ urls.format('SITE_SEARCH') }}" title="Search"></a>
                        {% if session.checkLogin %}
                            <a class="menu-item fa-users" href="{{ urls.format('SITE_MEMBERS') }}" title="Members"></a>
                            <a class="menu-item fa-heart" href="{{ urls.format('SITE_PREMIUM') }}" title="Support us"></a>
                        {% endif %}
                    </div>
                    <div class="menu-ucp fa" id="navMenuUser">
                        <!-- User menu, displayed on right side of the bar. -->
                        {% if session.checkLogin %}
                            <a class="menu-item avatar" href="{{ urls.format('USER_PROFILE', [user.data.id]) }}" title="Logged in as {{ user.data.username }}" style="background-image: url('{{ urls.format('IMAGE_AVATAR', [user.data.id]) }}'); width: auto; color: {{ user.colour }}; font-weight: 700;"></a>
                            <a class="menu-item fa-envelope" href="{{ urls.format('SETTING_CAT', ['messages']) }}" title="Messages"></a>
                            <a class="menu-item fa-gavel" href="{{ urls.format('MANAGE_INDEX') }}" title="Manage"></a>
                            <a class="menu-item fa-cogs" href="{{ urls.format('SETTINGS_INDEX') }}" title="Settings"></a>
                            <a class="menu-item fa-sign-out" href="{{ urls.format('USER_LOGOUT', [php.time, php.sessionid, sakura.currentPage]) }}" title="Logout" id="headerLogoutLink"></a>
                        {% else %}
                            {% if sakura.lockAuth %}
                            <div class="menu-item fa-lock" style="padding-left: 10px; padding-right: 10px;" title="Authentication is locked"></div>
                            {% else %}
                            <a class="menu-item fa-sign-in" href="{{ urls.format('SITE_LOGIN') }}" title="Login"></a>
                            {% endif %}
                        {% endif %}
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <div id="contentwrapper">
                <div id="notifications"></div>
                {% if php.self == '/profile.php' ? profile.data.userData.profileBackground : (user.checkPermission('SITE', 'CREATE_BACKGROUND') and user.data.userData.userOptions.profileBackgroundSiteWide and user.data.userData.profileBackground) %}
                    <div id="userBackground" style="background-image: url('{{ urls.format('IMAGE_BACKGROUND', [(php.self == '/profile.php' ? profile : user).data.id]) }}');"></div>
                {% endif %}
                {% if not session.checkLogin and php.self != '/authenticate.php' %}
                    <form method="post" action="{{ urls.format('AUTH_ACTION') }}" id="headerLoginForm" onkeydown="formEnterCatch(event, 'headerLoginButton');">
                        <input type="hidden" name="redirect" value="{{ sakura.currentPage }}" />
                        <input type="hidden" name="session" value="{{ php.sessionid }}" />
                        <input type="hidden" name="time" value="{{ php.time }}" />
                        <input type="hidden" name="mode" value="login" />
                        <div>
                            <label for="headerLoginUserName">Username:</label>
                            <input type="text" id="headerLoginUserName" name="username" class="inputStyling" placeholder="Username" />
                        </div>
                        <div>
                            <label for="headerLoginPassword">Password:</label>
                            <input type="password" id="headerLoginPassword" name="password" class="inputStyling" placeholder="Password" />
                        </div>
                        <div>
                            <input type="checkbox" name="remember" id="headerLoginRemember" />
                            <label for="headerLoginRemember">Remember me</label>
                        </div>
                        <div>
                            <input type="submit" id="headerLoginButton" name="submit" class="inputStyling small" value="Login" />
                        </div>
                    </form>
                {% endif %}
                {% if user.checkPermission('SITE', 'RESTRICTED') %}
                    <div class="headerNotify" style="padding-top: 10px; padding-bottom: 10px; background: repeating-linear-gradient(-45deg, #B33, #B33 10px, #B00 10px, #B00 20px); text-align: center; color: #FFF; border: 1px solid #C00; box-shadow: 0px 0px 3px #C00;">
                        <h1>Your account is current in <span style="font-width: 700 !important;">restricted mode</span>!</h1>
                        <div>A staff member has set your account to restricted mode most likely due to violation of the rules. While restricted you won't be able to use most public features of the site. If you think this is a mistake please <a href="{{ urls.format('INFO_PAGE', ['contact']) }}" style="color: inherit;">get in touch with one of our staff members</a>.</div>
                    </div>
                {% endif %}
                <noscript>
                    <div class="headerNotify" style="padding-top: 10px; padding-bottom: 10px; background: repeating-linear-gradient(-45deg, #C2AFFE, #C2AFFE 10px, #D3BFFF 10px, #D3BFFF 20px);">
                        <h1>You have JavaScript disabled!</h1>
                        <p style="padding: 0 10px;">A lot of things on this site require JavaScript to be enabled (e.g. the chat), we try to keep both sides happy but it is highly recommended that you enable it (you'll also have to deal with this message being here if you don't enable it).</p>
                    </div>
                </noscript>
