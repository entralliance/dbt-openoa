{% set src_relation = ref('fct_entr_reanalysis_data') %}
{% set src_colnames = dbt_utils.get_filtered_columns_in_relation(from=src_relation)|map('lower')|list %}
{% set coalesce_fields = ['tag_value', 'value_type', 'value_units'] %}

with
    src as (select * from {{src_relation}}),
    reanalysis_dim as (select * from {{ ref('dim_asset_reanalysis_dataset') }}),
    plant_dim as (select * from {{ ref('dim_asset_wind_plant') }}),
    tag_dim as (select * from {{ ref('entr', 'dim_entr_tag_list') }}),

src_filt as (
    select * from src
    where entr_tag_id in (2556, 2557, 2558, 2559, 2560, 2561, 2562)
),

u_component as (
    select * from src_filt where entr_tag_id = 2557
),

v_component as (
    select * from src_filt where entr_tag_id = 2558
),

derived_wd as (
    select
        2559 as entr_tag_id, -- WMETR.HORWdDir
        plant_id,
        reanalysis_dataset_id,
        date_time,
        {{wind_direction_from_components('u_component.tag_value', 'v_component.tag_value')}} as tag_value,
        interval_s,
        'derived' as value_type,
        'deg' value_units
    from u_component
    left join v_component
        using(plant_id, reanalysis_dataset_id, date_time, interval_s, value_type, value_units)
),

derived_tags_join as (
    select
        {% for col in src_colnames %}
            {% if col in coalesce_fields %}
                coalesce(src_filt.{{col}}, derived_wd.{{col}}) as {{col}}
            {% else %}
                {{col}}
            {% endif %}{% if not loop.last %}, {% endif %}
        {% endfor %}
    from src_filt
    full outer join derived_wd
        using({{ entr.jinja_list_to_sql( src_colnames|reject('in', coalesce_fields)|list ) }})
)

select
    plant_dim.plant_name,
    reanalysis_dim.reanalysis_dataset_name,
    tag_dim.entr_tag_name,
    derived_tags_join.*
from derived_tags_join
left join reanalysis_dim using(reanalysis_dataset_id)
left join plant_dim using(plant_id)
left join tag_dim using(entr_tag_id)
