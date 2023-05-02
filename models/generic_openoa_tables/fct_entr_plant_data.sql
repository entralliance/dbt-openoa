with
    src as (select * from {{ ref("entr", "fct_entr_time_series") }}),
    asset_dim as (select * from {{ref("entr", "dim_entr_asset")}} where asset_type = 'plant'),
    tag_dim as (
        select * from {{ref("entr", "dim_entr_tag_list")}}
        where entr_tag_name in (
            'IAVL.DnWh',
            'IAVL.ExtPwrDnWh',
            'MMTR.SupWh'
        )
    )

select
    src.asset_id as plant_id,
    entr_tag_id,
    src.date_time,
    src.tag_value,
    src.interval_s,
    src.value_type,
    src.value_units
from src
inner join asset_dim using(asset_id)
inner join tag_dim using(entr_tag_id, tag_subtype_id)
