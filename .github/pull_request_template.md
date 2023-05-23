Resolves #<!-- issue number -->

This is a:
- [ ] documentation update
- [ ] bug fix with no breaking changes
- [ ] new functionality
- [ ] a breaking change

All pull requests from community contributors should target the `dev` branch (default).

## Description & Motivation
<!---
Describe your changes, and why you're making them.
-->

## Checklist

- [ ] I have verified that these changes work locally on the following warehouses (Note: it's okay if you do not have access to all warehouses, this helps us understand what has been covered)
    - [ ] BigQuery
    - [ ] Postgres
    - [ ] Redshift
    - [ ] Snowflake
    - [ ] Other (please specify):
- [ ] I followed guidelines to ensure that my changes will work on "non-core" adapters by:
    - [ ] using the `limit_zero()` macro in place of the literal string: `limit 0`
    - [ ] using `dbt.type_*` macros instead of explicit datatypes (e.g. `dbt.type_timestamp()` instead of `TIMESTAMP`
    - [ ] dispatching any new macro(s) so non-core adapters can also use them (e.g. [the `star()` source](https://github.com/dbt-labs/dbt-utils/blob/main/macros/sql/star.sql))
- [ ] I have updated the README.md (if applicable)
- [ ] I have added tests & descriptions to my models (and macros if applicable)
