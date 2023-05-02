<h1 align="center">dbt-openoa</h1>
<p align="center">
<a href="https://www.getdbt.com/">
<img alt="dbt-logo" width="10%" src="https://github.com/entralliance/entralliance.github.io/raw/main/images/dbt-logo.png?" />
<img alt="openoa-logo" width="20%" src="https://github.com/NREL/OpenOA/raw/develop/Open%20OA%20Final%20Logos/Color/Open%20OA%20Color%20Transparent%20Background.png?format=1500w" />
</p>

<p align="center">
<a href="https://circleci.com/gh/entralliance/dbt-openoa/tree/main">
<img alt="CircleCI" src="https://circleci.com/gh/entralliance/dbt-openoa.svg?style=shield"/>
</a>
<img alt="License" src="https://img.shields.io/badge/License-MIT-yellow.svg"/>
</p>


<hr/>

## Data Warehouse Compatibility


This package has been tested for compatibility with the following warehouse types:

* [x] **Postgres**  ![](https://raw.githubusercontent.com/elementary-data/elementary/master/static/postgres-16.png)
* [x] **Snowflake** ![](https://raw.githubusercontent.com/elementary-data/elementary/master/static/snowflake-16.png) 
* [x] **BigQuery**  ![](https://raw.githubusercontent.com/elementary-data/elementary/master/static/bigquery-16.svg) 
* [x] **Spark/Databricks**  ![](https://raw.githubusercontent.com/elementary-data/elementary/master/static/databricks-16.png)

*Note:* this package may work with other warehouse types not listed above but their compatibility has not been tested.


### Important note about BigQuery

Some column names will appear different when materializing this package's models in BigQuery due to its incompatibility with having "`.`" in field names:

* openoa_curtailment_and_availability
* openoa_reanalysis
* openoa_revenue_meter
* openoa_wtg_scada