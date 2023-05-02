{% macro wind_direction_from_components(u, v) %}
    {{ return(adapter.dispatch('wind_direction_from_components', 'openoa')(u, v)) }}
{% endmacro %}

{% macro default__wind_direction_from_components(u, v) %}
    180 + atan2({{u}}, {{v}}) * 180 / pi()
{% endmacro %}

{% macro bigquery__wind_direction_from_components(u, v) %}
    180 + atan2({{u}}, {{v}}) * 180 / acos(-1)
{% endmacro %}
