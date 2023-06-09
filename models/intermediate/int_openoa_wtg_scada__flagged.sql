with
    src as (select * from {{ ref('int_openoa_wtg_scada__filtered') }}),
    bounds_dim as (select * from {{ ref('seed_openoa_wtg_scada_dq_params') }}),
    tag_dim as (select * from {{ ref('dim_entr_tag_list') }}),

bounds as (
    select
        tag_dim.entr_tag_id,
        cast(bounds_dim.min as {{ dbt.type_numeric()}}) as min,
        cast(bounds_dim.max as {{ dbt.type_numeric()}}) as max
    from bounds_dim
    left join tag_dim using(entr_tag_name)
)

select
    src.*,
    {{ openoa.flag_min_max_violation(target_col='tag_value', min='bounds.min', max='bounds.max')}},
    {{ openoa.flag_stale_violation(target_col='tag_value', datetime_col='date_time', partition_by_cols=['wind_turbine_id','entr_tag_id'])}},
    bounds.min,
    bounds.max
from src
left join bounds using(entr_tag_id)
