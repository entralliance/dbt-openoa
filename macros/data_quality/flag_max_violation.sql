{% macro flag_max_violation(target_col, max, where, inclusive=false, quote=false) %}
    {{ return(adapter.dispatch('flag_max_violation', 'openoa')(target_col, max, where, inclusive, quote)) }}
{% endmacro %}

{% macro default__flag_max_violation(target_col, max, where, inclusive=false, quote=false) %}

    {% if quote==true %}
        {% set _target_col = adapter.quote(target_col) %}
        {% set _output_col = adapter.quote('flag_max_' + target_col) %}
    {% else %}
        {% set _target_col = target_col %}
        {% set _output_col = 'flag_max_' + target_col %}
    {% endif %}

    {% if inclusive is false %}
        {% set max_comparison = '>' %}
    {% else %}
        {% set max_comparison = '>=' %}
    {% endif %}

    case
        when {{ _target_col }} {{max_comparison}} {{max}} {% if where is defined %} and {{where}} {% endif %} then 1
        else 0
    end as {{ _output_col }}

{% endmacro %}
