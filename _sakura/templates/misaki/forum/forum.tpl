<div class="forumListing">
    {% for forum in forum.forums %}
        {% if forum.type == 1 %}
            {% if forum.forums|length %}
            <div class="forumCategory">
                <div class="forumCategoryHead">
                    <div class="forumCategoryTitle">{% if forum.type != 1 %}Subforums{% else %}<a href="{{ urls.format('FORUM_SUB', [forum.id]) }}">{{ forum.name }}</a>{% endif %}</div>
                    <div class="forumCategoryDescription">{{ forum.description }}</div>
                </div>
                {% for forum in forum.forums %}
                    {% include 'forum/forumEntry.tpl' %}
                {% endfor %}
            </div>
            {% endif %}
        {% else %}
            {% include 'forum/forumEntry.tpl' %}
        {% endif %}
    {% endfor %}
</div>
