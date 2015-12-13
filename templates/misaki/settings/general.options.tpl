<form enctype="multipart/form-data" method="post" action="{{ sakura.currentPage }}" class="box">
    <input type="hidden" name="sessid" value="{{ php.sessionid }}" />
    <input type="hidden" name="timestamp" value="{{ php.time }}" />
    <input type="hidden" name="mode" value="options" />
    {% for field in options.fields %}
        <div>
            <div>
                <h2>{{ field.option_name }}</h2>
                <h4>{{ field.option_description }}</h4>
            </div>
            <div>
                <input type="{{ field.option_type }}" name="option_{{ field.option_id }}" class="inputStyling"{% if user.optionFields[field.option_id] %}{% if field.option_type == 'checkbox' and user.optionFields[field.option_id] %} checked="checked" value="option_{{ field.option_id }}"{% else %} value="{{ user.optionFields[field.option_id] }}"{% endif %}{% endif %} />
            </div>
        </div>
    {% endfor %}
    <input type="submit" value="Save" name="submit" class="inputStyling" />
    <input type="reset" value="Reset" name="reset" class="inputStyling" />
</form>
