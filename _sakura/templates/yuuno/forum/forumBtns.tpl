{% set paginationClass = 'rightSide' %}

<div class="buttonRow pagination">
    <div class="leftSide">
        {% if forumBackLink %}
            <a href="{{ forumBackLink }}" class="forumbtn"><span class="fa fa-backward"></span> Back</a>
        {% endif %}
        {% if forumReplyLink %}
            <a href="{{ forumReplyLink }}" class="forumbtn"><span class="fa fa-reply-all"></span> Reply</a>
        {% endif %}
        {% if forumNewLink %}
            <a href="{{ forumNewLink }}" class="forumbtn"><span class="fa fa-pencil-square-o"></span> New Thread</a>
        {% endif %}
        {% if forumMarkRead %}
            <a href="{{ forumMarkRead }}" class="forumbtn"><span class="fa fa-check-square-o"></span> Mark as Read</a>
        {% endif %}
    </div>
    {% include 'elements/pagination.tpl' %}
    <div class="clear"></div>
</div>
