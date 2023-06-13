# dbt-openoa

<p align="center">
<a href="https://www.getdbt.com/">
<img alt="dbt-logo" width="10%" src="https://github.com/entralliance/entralliance.github.io/raw/main/images/dbt-logo.png?" />
<img alt="openoa-logo" width="25%" src="https://github.com/NREL/OpenOA/raw/develop/Open%20OA%20Final%20Logos/Color/Open%20OA%20Color%20Transparent%20Background.png?format=1500w" />
</p>

<p align="center">
<a href="https://circleci.com/gh/entralliance/dbt-openoa/tree/main">
<img alt="CircleCI" src="https://circleci.com/gh/entralliance/dbt-openoa.svg?style=shield"/>
</a>
<img alt="License" src="https://img.shields.io/badge/License-MIT-yellow.svg"/>
</p>

<hr/>

The `dbt-openoa` dbt package creates analysis-ready warehouse models for use within NREL's [OpenOA](https://github.com/NREL/OpenOA) (Open Operational Assessment) package. The models within this package build upon the ENTR standard table schema and tag naming conventions embodied in the [`dbt-entr`](https://github.com/entralliance/dbt-entr) package.

## Data Warehouse Compatibility

This package has been tested for compatibility with the following warehouse types:

* [x] **Postgres** <img alt="Postgres" src="https://raw.githubusercontent.com/entralliance/entralliance.github.io/main/images/postgres-icon.png" />
* [x] **Snowflake** <img alt="Snowflake" src="https://raw.githubusercontent.com/entralliance/entralliance.github.io/main/images/snowflake-icon.png" />
* [x] **BigQuery** <img alt="BigQuery" src="https://raw.githubusercontent.com/entralliance/entralliance.github.io/main/images/bigquery-icon.svg" /> 
* [x] **Spark/Databricks** <img alt="Databricks" src="https://raw.githubusercontent.com/entralliance/entralliance.github.io/main/images/databricks-icon.png" />

*Note:* this package may work with other warehouse types not listed above but their compatibility has not been tested.

## Installation

To install this package, add it to your `packages.yml` file in your dbt project's root directory along with the desired package version:

```yaml
packages:
  - git: "https://github.com/entralliance/dbt-openoa.git"
    revision: 0.0.4
```

*Note*: installing this package will install [`dbt-entr`](https://github.com/entralliance/dbt-entr) as well.

## Configuration

The models within this package require configuration of the `dbt-entr` package - once the standard models within `dbt-entr` have been configured to read in data from upstream models (see the `dbt-entr` [configuration docs](https://github.com/entralliance/dbt-entr#configuration)), this package's models will be produced based on data contained within the ENTR standard table schema.

### Specifying Materialization Types

You may also want to change the materialization type (or other properties such as the database or schema in which models are materialized) of the standard ENTR models, which can be done by specifying those materialization properties in your `dbt_project.yml`:

```yaml
models:
    openoa:
        +materialized: view
        generic_openoa_tables:
            +materialized: table
```

### Required Data

In order to successfully run all models in this package, the following data must be present `dim_entr_asset` (i.e. models listed in the `dim_entr_asset_models` project variable):

- At least one asset of type `plant` (a wind energy plant) containing columns included in the [`dim_asset_wind_plant` dbt-openoa project docs](https://entralliance.github.io/dbt-openoa/#!/model/model.openoa.dim_asset_wind_plant).

- At least one asset of type `wtg` (a wind turbine generator) containing columns included in the [`dim_asset_wind_turbine` dbt-openoa project docs](https://entralliance.github.io/dbt-openoa/#!/model/model.openoa.dim_asset_wind_turbine).

- At least one record of time series data for each of the following tags (see the `dim_entr_tag_list` table produced by the `dbt-entr` package or the [ENTR standard tag list seed file](https://github.com/entralliance/dbt-entr/blob/main/seeds/seed_entr_tag_list.csv) for tag descriptions) - models containing these time series data must be included in the `fct_entr_time_series_models` list in your dbt_project.yml:
    - Wind turbine SCADA tags:
        - WMET.EnvTmp
        - WMET.HorWdDir
        - WMET.HorWdDirRel
        - WMET.HorWdSpd
        - WNAC.Dir
        - WROT.BlPthAngVal
        - WTUR.W
    - Satellite reanalysis tags:
        - WMETR.AirDen
        - WMETR.EnvPres
        - WMETR.EnvTmp
        - WMETR.HorWdDir
        - WMETR.HorWdSpd
        - WMETR.HorWdSpdU
        - WMETR.HorWdSpdV
    - Plant-level tags:
        - IAVL.DnWh
        - IAVL.ExtPwrDnWh
        - MMTR.SupWh

For example data and configuration, please see the [`entr-warehouse` reference dbt project](https://github.com/entralliance/entr_warehouse) for example data and configuration.

### Important note about BigQuery

Some column names will appear different when materializing this package's models in BigQuery due to its incompatibility with having "`.`" in field names:

* openoa_curtailment_and_availability
* openoa_reanalysis
* openoa_revenue_meter
* openoa_wtg_scada
