{% include 'global/header.tpl' %}
    <div class="content homepage forum viewtopic">
        <div class="content-column">
            <div class="head">{{ forum.forum.forum_name }} / {{ topic.topic_title }}</div>
            <a href="/forum/thread/{{ topic.topic_id }}/reply" class="forumbtn"><span class="fa fa-reply-all"></span> Reply</a>
            <table class="posts">
                {% for post in posts %}
                    <tr class="post" id="p{{ post.post_id }}">
                        <td class="userpanel">
                            {% if post.user.rank_main > 1 %}<a href="/u/{{ post.user.id }}" class="default username" style="color: {% if post.user.name_colour %}{{ post.user.name_colour }}{% else %}{{ post.rank.colour }}{% endif %};" title="Go to {{ post.user.username }}'s profile">{{ post.user.username }}</a>
                            <img src="/a/{{ post.user.id }}" alt="{{ post.user.username }}" class="avatar" style="box-shadow: 0 3px 7px #{% if post.is_online %}484{% else %}844{% endif %};" />
                            <div class="userdata">
                                <div class="usertitle">{% if not post.user.usertitle %}{{ post.rank.title }}{% else %}{{ post.user.usertitle }}{% endif %}</div>
                                <img src="//{{ sakura.urls.content }}/images/tenshi.png" alt="Tenshi"{% if not post.is_premium %} style="opacity: 0;"{% endif %} /> <img src="//{{ sakura.urls.content }}/images/flags/{% if post.user.country|lower == 'eu' %}europeanunion{% else %}{{ post.user.country|lower }}{% endif %}.png" alt="{{ post.country }}" />
                                <div class="actions">
                                    {% if user.data.id == post.user.id %}
                                    <a class="fa fa-pencil-square-o" title="Edit this post" href="#"></a>
                                    {% else %}
                                    {% if post.is_friend != 0 %}<a class="fa fa-{% if post.is_friend == 2 %}heart{% else %}star{% endif %}" title="You are friends"></a>{% endif %}
                                    <a class="fa fa-user-{% if post.is_friend == 0 %}plus{% else %}times{% endif %}" title="{% if post.is_friend == 0 %}Add {{ post.user.username }} as a friend{% else %}Remove friend{% endif %}" href="//{{ sakura.urls.main }}/friends?{% if post.is_friend == 0 %}add{% else %}remove{% endif %}={{ post.user.id }}&amp;session={{ php.sessionid }}&amp;time={{ php.time }}&amp;redirect={{ sakura.currentpage }}"></a>
                                    <a class="fa fa-flag" title="Report {{ post.user.username }}" href="//{{ sakura.urls.main }}/u/{{ post.user.id }}/report"></a>
                                    {% endif %}
                                    {% else %}
                                    <a class="username">[deleted user]</a>
                                    <div class="actions">
                                    {% endif %}
                                    <a class="fa fa-reply" title="Quote this post" href="/forum/post/{{ post.post_id }}/quote"></a>
                                </div>
                            </div>
                        </td>
                        <td class="post-content">
                            <div class="details">
                                <div class="subject">
                                    <a href="#p{{ post.post_id }}" class="clean">{{ post.post_subject }}</a>
                                </div>
                                <div class="date">
                                    <a href="/forum/post/{{ post.post_id }}#p{{ post.post_id }}" class="clean">{{ post.post_time|date("r") }}</a>
                                </div>
                                <div class="clear"></div>
                            </div>
                            <div class="post-text markdown">
                                {{ post.parsed_post|raw }}
                            </div>
                            {% if post.enable_sig and post.signature %}
                            <div class="clear"></div>
                            <div class="signature">
                                {{ post.signature|raw }}
                            </div>
                            {% endif %}
                        </td>
                    </tr>
                {% endfor %}
            </table>
            <a href="/forum/thread/{{ topic.topic_id }}/reply" class="forumbtn"><span class="fa fa-reply-all"></span> Reply</a>
        </div>
    </div>
{% include 'global/footer.tpl' %}