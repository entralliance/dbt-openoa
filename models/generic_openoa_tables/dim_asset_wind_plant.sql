select
    asset_id as plant_id,
    asset_name as plant_name,
    cast(latitude as {{ dbt.type_numeric()}}) as latitude,
    cast(longitude as {{ dbt.type_numeric()}}) as longitude,
    cast(plant_capacity as {{ dbt.type_numeric()}}) as plant_capacity,
    cast(number_of_turbines as {{ dbt.type_int()}}) as number_of_turbines,
    cast(turbine_capacity as {{ dbt.type_numeric()}}) as turbine_capacity
from {{ref('entr', 'dim_entr_asset')}}
where asset_type = 'plant'
