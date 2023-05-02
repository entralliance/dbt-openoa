{% macro flag_min_violation(target_col, min, where, inclusive=false, quote=false) %}
    {{ return(adapter.dispatch('flag_min_violation', 'openoa')(target_col, min, where, inclusive, quote)) }}
{% endmacro %}

{% macro default__flag_min_violation(target_col, min, where, inclusive=false, quote=false) %}

    {% if quote==true %}
        {% set _target_col = adapter.quote(target_col) %}
        {% set _output_col = adapter.quote('flag_min_' + target_col) %}
    {% else %}
        {% set _target_col = target_col %}
        {% set _output_col = 'flag_min_' + target_col %}
    {% endif %}

    {% if inclusive is false %}
        {% set min_comparison = '<' %}
    {% else %}
        {% set min_comparison = '<=' %}
    {% endif %}

    case
        when {{ _target_col }} {{min_comparison}} {{min}} {% if where is defined %} and {{where}} {% endif %} then 1
        else 0
    end as {{ _output_col }}

{% endmacro %}
