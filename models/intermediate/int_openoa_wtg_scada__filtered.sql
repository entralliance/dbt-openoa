with
    src as (select * from {{ ref('fct_entr_wtg_scada') }}),
    wtg_dim as (select * from {{ ref('dim_asset_wind_turbine') }}),
    plant_dim as (select * from {{ ref('dim_asset_wind_plant') }}),
    tag_dim as (select * from {{ ref('dim_entr_tag_list') }}),

power_vals as (select * from src where entr_tag_id = 2456),

power_to_energy as (
    select
        wind_turbine_id,
        2378 as entr_tag_id, -- WTUR.SupWh
        date_time,
        {{w_to_wh('tag_value')}} as tag_value,
        interval_s,
        cast('derived' as {{dbt.type_string()}}) as value_type,
        {{ dbt.concat(['value_units', "'h'"])}} as value_units,
        {{ dbt.concat(['standard_units', "'h'"])}} as standard_units
    from power_vals
),

energy_union as (
    select * from src
    where entr_tag_id in (
        1349,
        2456,
        1104,
        1089,
        1058,
        1162,
        1074
    )

    union all

    select * from power_to_energy
),

-- FIXME
{% set _360 %}
( cast( 360 as {{dbt.type_numeric()}} ) )
{% endset %}

{% set convert_winddir_sql %}
    {% if target.type == 'bigquery' %}
        case
            when mod( ( mod(tag_value, {{_360}} ) + {{_360}} ), {{_360}} ) > 180 then 
                 mod( ( mod(tag_value, {{_360}} ) + {{_360}} ), {{_360}} ) - 360
            else mod( ( mod(tag_value, {{_360}} ) + {{_360}} ), {{_360}} )
        end
    {% else %}
        case 
            when ( (tag_value % 360) + 360) % 360 > 180 then 
                 ( (tag_value % 360) + 360) % 360 - 360
            else ( (tag_value % 360) + 360) % 360
        end
    {% endif %}
{% endset %}

unit_conversions as (
    {{entr_multiple_tag_unit_conversions(
        relation_for_table_structure=ref('fct_entr_wtg_scada'),
        entr_tag_ids=[
            1349,
            2456,
            2378
        ],
        operations=[
            convert_winddir_sql,
            'tag_value * 1000',
            'tag_value * 1000'
        ],
        new_units=[
            'deg',
            'W',
            'Wh'
        ],
        cte='energy_union'
    )}}
)

select
    plant_id,
    plant_dim.plant_name,
    wtg_dim.wind_turbine_name,
    tag_dim.entr_tag_name,
    cte.*
from unit_conversions cte
left join wtg_dim using(wind_turbine_id)
left join plant_dim using(plant_id)
left join tag_dim using(entr_tag_id)
