{#
    TODO:
        - add support for lag to check all values between record and lag # (not just record vs. lag # value)
        - add support for time-based (instead of record count-based) staleness
#}

{% macro flag_stale_violation(target_col, datetime_col, partition_by_cols, exclude_values=[], lag_length=1, quote=false) %}
    {{ return(adapter.dispatch('flag_stale_violation', 'openoa')(target_col, datetime_col, partition_by_cols, exclude_values, lag_length, quote)) }}
{% endmacro %}

{% macro default__flag_stale_violation(target_col, datetime_col, partition_by_cols, exclude_values=[], lag_length=1, quote=false) %}

    {% if quote==true %}
        {% set _target_col = adapter.quote(target_col) %}
        {% set _datetime_col = adapter.quote(target_col) %}
        {% set _output_col = adapter.quote('flag_stale_' + target_col) %}
    {% else %}
        {% set _target_col = target_col %}
        {% set _datetime_col = datetime_col %}
        {% set _output_col = 'flag_stale_' + target_col %}
    {% endif %}

    {% set _stale_condition %}
        {% if partition_by_cols is defined %} 
            {{ _target_col }} = lag( {{ _target_col }}, {{ lag_length }} ) over ( partition by {{ entr.jinja_list_to_sql(partition_by_cols, quote_identifiers=quote )}} order by {{ _datetime_col }})
        {%- else -%}
            {{ _target_col }} = lag( {{ _target_col }}, {{ lag_length }} ) over ( order by {{ _datetime_col }})
        {% endif %}
        {% if exclude_values|length > 0 %} 
            and {{ _target_col }} not in ({{ entr.jinja_list_to_sql(exclude_values) }})
        {% endif %}
    {% endset %}

    case
        when {{_stale_condition}} then 1
        else 0
    end as {{ _output_col }}

{% endmacro %}
