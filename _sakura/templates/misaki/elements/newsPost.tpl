<div class="news-post" id="n{{ post.news_id }}">
    <div class="news-header">
        <a class="news-title floatLeft" href="{{ urls.format('SITE_NEWS_POST', [post.news_id]) }}">{{ post.news_title }}</a>
        <div class="news-details floatRight">
            <div>{{ post.news_timestamp|date(sakura.dateFormat) }}</div>
            <div>Posted by <a class="username" style="color: {{ post.news_poster.colour }};" href="{{ urls.format('USER_PROFILE', [post.news_poster.data.user_id]) }}">{{ post.news_poster.data.username }}</a>{% if not (viewPost and postExists) %} / <a class="default" href="{{ urls.format('SITE_NEWS_POST', [post.news_id]) }}#comments">{{ post.news_comments.count }} comment{% if post.news_comments.count != 1 %}s{% endif %}</a>{% endif %}</div>
        </div>
        <div class="clear"></div>
    </div>
    <div class="news-content">
        <div class="news-avatar">
            <img src="{{ urls.format('IMAGE_AVATAR', [post.news_poster.data.user_id]) }}" alt="{{ post.news_poster.data.username }}" />
        </div>
        <div class="news-text">
            {{ post.news_content_parsed|raw }}
        </div>
        <div class="clear"></div>
    </div>
</div>
