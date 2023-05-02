{% set src_model = 'int_openoa_plant_data__resampled' %}

with
    src as (select * from {{ ref(src_model) }})

{% if target.type == 'bigquery' %}
    {% set quote_piv_cols = false %}
{% else %}
    {% set quote_piv_cols = true %}
{% endif %}

select
    plant_id,
    plant_name,
    date_time,
    {{  
        dbt_utils.pivot(
            column = 'entr_tag_name',
            values = dbt_utils.get_column_values(table=ref(src_model), column='entr_tag_name'),
            then_value = 'tag_value',
            else_value = 'null',
            agg = 'avg',
            quote_identifiers = quote_piv_cols) 
    }}
from src
where entr_tag_id in (2553, 2555)
{{ dbt_utils.group_by(n=3) }}
