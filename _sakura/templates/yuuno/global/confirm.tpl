{% extends 'global/master.tpl' %}

{% block title %}Confirmation{% endblock %}

{% block content %}
    <div class="content standalone">
        <div>
            <h1>{% block header %}Confirmation{% endblock %}</h1>
            <hr class="default" />
            {{ message }}
            <form method="post" action="{{ sakura.currentPage }}" id="confirmationForm">
                <input type="hidden" name="sessionid" value="{{ php.sessionid }}" />
                <input type="hidden" name="timestamp" value="{{ php.time }}" />
                {% for key,value in conditions %}
                    <input type="hidden" name="{{ key }}" value="{{ value }}" />
                {% endfor %}
                <input type="submit" class="inputStyling" name="yes" value="Yes" />
                <input type="submit" class="inputStyling" name="no" value="No" />
            </form>
        </div>
    </div>
{% endblock %}
