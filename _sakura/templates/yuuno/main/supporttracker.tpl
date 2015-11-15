{% extends 'global/master.tpl' %}

{% block title %}Donation Tracker{% endblock %}

{% set paginationPages = tracker.table|batch(20) %}
{% set paginationUrl %}{{ urls.format('SITE_DONATE_TRACK') }}{% endset %}

{% block css %}
    <style type="text/css">
        .pagination {
            float: right;
        }
    </style>
{% endblock %}

{% block content %}
    <div class="content support">
        <div class="head">Donation Tracker</div>
        <h1 class="stylised" style="margin: 1em auto; text-align: center;">Our current overall balance is &#8364;{{ tracker.balance|number_format(2) }}</h1>
        <div class="sectionHeader">
            Donation Log
        </div>
        <table>
            <thead>
                <tr>
                    <th>Supporter</th>
                    <th>Amount</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                    <th>Supporter</th>
                    <th>Amount</th>
                    <th>Action</th>
                </tr>
            </tfoot>
            <tbody>
                {% for supporter in tracker.table|batch(20)[get.page|default(1) - 1] %}
                    <tr>
                        <td>
                            <a href="{{ urls.format('USER_PROFILE', [tracker.users[supporter.user_id].id]) }}" class="default" style="color: {{ tracker.users[supporter.user_id].colour }}; text-shadow: 0 0 7px {% if tracker.users[supporter.user_id].colour != 'inherit' %}{{ tracker.users[supporter.user_id].colour }}{% else %}#222{% endif %};">{{ tracker.users[supporter.user_id].username }}</a>
                        </td>
                        <td style="color: {% if supporter.transaction_amount > 0 %}#0A0{% else %}#A00{% endif %};">
                            &#8364;{{ supporter.transaction_amount|number_format(2) }}
                        </td>
                        <td>
                            {{ supporter.transaction_comment }}
                        </td>
                    </tr>
                {% endfor %}
            </tbody>
        </table>
        {% if tracker.table|batch(20)|length > 1 %}
        <div>
            {% include 'elements/pagination.tpl' %}
            <div class="clear"></div>
        </div>
        {% endif %}
    </div>
{% endblock %}
