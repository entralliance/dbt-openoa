with
    src as (select * from {{ ref("fct_entr_time_series") }}),
    asset_dim as (select * from {{ref("dim_entr_asset")}} where asset_type = 'plant'),
    tag_dim as (
        select * from {{ref("dim_entr_tag_list")}}
        where entr_tag_name in (
            'WMETR.AirDen',
            'WMETR.EnvPres',
            'WMETR.EnvTmp',
            'WMETR.HorWdDir',
            'WMETR.HorWdSpd',
            'WMETR.HorWdSpdU',
            'WMETR.HorWdSpdV'
        )
    )

select    
    src.asset_id as plant_id,
    case
        when upper(tag_dim.tag_subtype_description) like '%MERRA-2%' then 1
        when upper(tag_dim.tag_subtype_description) like '%ERA5%' then 2
        else null
    end as reanalysis_dataset_id,
    entr_tag_id,
    src.date_time,
    src.tag_value,
    src.interval_s,
    src.value_type,
    src.value_units
from src
inner join asset_dim using(asset_id)
inner join tag_dim using(entr_tag_id, tag_subtype_id)
