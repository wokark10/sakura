{% set alerts = alerts|batch(10) %}

{% set paginationPages = alerts %}
{% set paginationUrl %}{{ urls.format('SETTING_MODE', ['notifications', 'history']) }}{% endset %}

{% block css %}
<style type="text/css">
    .pagination {
        float: right;
    }
</style>
{% endblock %}

{% if alerts %}
    <div class="notification-history">
        {% for alert in alerts[get.page|default(1) - 1] %}
        <a id="notif-hist-{{ alert.id }}" class="clean {% if alert.alert_read %}read{% endif %}"{% if alert.alert_link %} href="{{ alert.alert_link }}"{% endif %}>
            <div class="notif-hist-icon">
            {% if 'FONT:' in alert.alert_img %}
                <div class="font-icon fa {{ alert.alert_img|replace({'FONT:': ''}) }} fa-4x"></div>
            {% else %}
                <img src="{{ alert.alert_img }}" alt="Notification" />
            {% endif %}
            </div>
            <div class="notif-hist-content">
                <div class="notif-hist-inside">
                    <div class="notif-hist-title">
                        {{ alert.alert_title }}
                    </div>
                    <div class="notif-hist-text">
                        {{ alert.alert_text }}
                    </div>
                </div>
                <div class="notif-hist-time">
                    {{ alert.alert_timestamp|date(sakura.dateFormat) }}
                </div>
            </div>
            <div class="clear"></div>
        </a>
        {% endfor %}
    </div>
    {% if alerts|length > 1 %}
        <div>
            {% include 'elements/pagination.tpl' %}
        </div>
    {% endif %}
{% else %}
    <h1 class="stylised" style="margin: 2em auto; text-align: center;">You don't have any notifications in your history!</h1>
{% endif %}
