This is a demo dbt project to be used in mutiple POC

### Seeds
As this is a demo project we are not loading any data directly to Snowflake, we have created seed files that pushes the data to snowflake. This was we don't have to worry about data everytime we re-use this project.

This project uses hotel bookings data:
- [bookings_1](seeds/bookings_1.csv)
- [bookings_2](seeds/bookings_2.csv)
- [customers](seeds/customers.csv)

### Models
- Transform : Preps the data for further report generation
    - [combined_bookings](models/transform/combined_bookings.sql)
    - [customer](models/transform/customer.sql)
    - [prepped_data](models/transform/prepped_data.sql)
- Analysis : Uses models from transform to form the final data product
    - [hotel_count_by_day](models/analysis/hotel_count_by_day.sql)
    - [thirty_day_avg_cost](models/analysis/thirty_day_avg_cost.sql)