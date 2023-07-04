{{
    config(
        materialized="table"
    )
}}
SELECT
  *
FROM {{ ref('hotel_count_by_day') }}