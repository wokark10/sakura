{% set friends = user.friends(1)|batch(12) %}

{% set paginationPages = friends %}
{% set paginationUrl %}{{ urls.format('SETTING_MODE', ['friends', 'listing']) }}{% endset %}

{% block js %}
<script type="text/javascript">
window.addEventListener("load", function() {
    var friendsListActions = document.querySelectorAll('[id^="friendslist-friend-action-"]');

    for (var i in friendsListActions) {
        prepareAjaxLink(friendsListActions[i], 'submitPost', ', true, "Please wait.."');
    }
});
</script>
{% endblock %}

{% block css %}
<style type="text/css">
    .pagination {
        float: right;
    }
</style>
{% endblock %}

{% if friends|length %}
    <div class="friends-list">
        {% for friend in friends[get.page|default(1) - 1] %}
            <div class="friend-container" id="friendslist-friend-{{ friend.id }}">
                <a class="friends-list-data clean" href="/u/{{ friend.id }}">
                    <img src="/a/{{ friend.id }}" alt="{{ friend.username }}" class="friends-list-avatar default-avatar-setting" style="width: 150px; height: 150px;" />
                    <div class="friends-list-name" style="color: {{ friend.colour }};">{{ friend.username }}</div>
                </a>
                <div class="friends-list-actions">
                    <a class="remove fill fa fa-remove" title="Remove friend" href="/friends?remove={{ friend.id }}&amp;session={{ php.sessionid }}&amp;time={{ php.time }}" id="friendslist-friend-action-remove-{{ friend.id }}"></a>
                    <div class="clear"></div>
                </div>
            </div>
        {% endfor %}
        <div class="clear"></div>
    </div>
    {% if friends|length > 1 %}
        <div>
            {% include 'elements/pagination.tpl' %}
        </div>
    {% endif %}
{% else %}
    <h1 class="stylised" style="margin: 2em auto; text-align: center;">You don't have any friends yet!</h1>
{% endif %}
