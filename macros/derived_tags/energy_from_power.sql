{% macro w_to_wh(power, interval_s='interval_s') %}
    {{ return(adapter.dispatch('w_to_wh', 'openoa')(power, interval_s)) }}
{% endmacro %}

{% macro default__w_to_wh(power, interval_s='interval_s') %}
    {{power}} * {{interval_s}} / 3600
{% endmacro %}
