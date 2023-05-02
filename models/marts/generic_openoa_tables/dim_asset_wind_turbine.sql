select
    cast(plant_id as {{ dbt.type_int()}}) as plant_id,
    asset_id as wind_turbine_id,
    asset_name as wind_turbine_name,
    cast(latitude as {{ dbt.type_numeric()}}) as latitude,
    cast(longitude as {{ dbt.type_numeric()}}) as longitude,
    cast(elevation as {{ dbt.type_numeric()}}) as elevation,
    cast(hub_height as {{ dbt.type_numeric()}}) as hub_height,
    cast(rotor_diameter as {{ dbt.type_numeric()}}) as rotor_diameter,
    cast(rated_power as {{ dbt.type_numeric()}}) as rated_power,
    cast(manufacturer as {{ dbt.type_string()}}) as manufacturer,
    cast(model as {{ dbt.type_string()}}) as model
from {{ref('dim_entr_asset')}}
where asset_type = 'wtg'