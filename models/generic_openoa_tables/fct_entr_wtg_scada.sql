with
    src as (select * from {{ ref("fct_entr_time_series") }}),
    asset_dim as (select * from {{ref("dim_entr_asset")}} where asset_type = 'wtg'),
    tag_dim as (
        select * from {{ref("dim_entr_tag_list")}}
        where entr_tag_name in (
            'WMET.EnvTmp',
            'WMET.HorWdDir',
            'WMET.HorWdDirRel',
            'WMET.HorWdSpd',
            'WNAC.Dir',
            'WROT.BlPthAngVal',
            'WTUR.W'
        )
    )

select
    src.asset_id as wind_turbine_id,
    entr_tag_id,
    src.date_time,
    src.tag_value,
    src.interval_s,
    src.value_type,
    src.value_units,
    tag_dim.standard_units
from src
inner join asset_dim using(asset_id)
inner join tag_dim using(entr_tag_id, tag_subtype_id)
