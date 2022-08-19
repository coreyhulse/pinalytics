SELECT
    date
  , month(date) AS month
  , year(date) AS year
  , CONCAT(year(date), '-', RIGHT(CONCAT('00', month(date)),2)) AS yearmonth
  , CASE WHEN year(CURDATE()) = year(date) THEN 1 ELSE 0 END AS current_year_flag
  , DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY) AS date_check
  , CASE WHEN date < DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY) THEN 1 ELSE 0 END AS rolling_all_time
  , CASE WHEN date >= DATE_SUB(DATE_ADD(CURDATE(), INTERVAL -5 YEAR), INTERVAL DAYOFMONTH(DATE_ADD(CURDATE(), INTERVAL -5 YEAR)) - 1 DAY) AND date < DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY) THEN 1 ELSE 0 END AS rolling_60_month
  , CASE WHEN date >= DATE_SUB(DATE_ADD(CURDATE(), INTERVAL -4 YEAR), INTERVAL DAYOFMONTH(DATE_ADD(CURDATE(), INTERVAL -4 YEAR)) - 1 DAY) AND date < DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY) THEN 1 ELSE 0 END AS rolling_48_month
  , CASE WHEN date >= DATE_SUB(DATE_ADD(CURDATE(), INTERVAL -3 YEAR), INTERVAL DAYOFMONTH(DATE_ADD(CURDATE(), INTERVAL -3 YEAR)) - 1 DAY) AND date < DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY) THEN 1 ELSE 0 END AS rolling_36_month
  , CASE WHEN date >= DATE_SUB(DATE_ADD(CURDATE(), INTERVAL -2 YEAR), INTERVAL DAYOFMONTH(DATE_ADD(CURDATE(), INTERVAL -2 YEAR)) - 1 DAY) AND date < DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY) THEN 1 ELSE 0 END AS rolling_24_month
  , CASE WHEN date >= DATE_SUB(DATE_ADD(CURDATE(), INTERVAL -1 YEAR), INTERVAL DAYOFMONTH(DATE_ADD(CURDATE(), INTERVAL -1 YEAR)) - 1 DAY) AND date < DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY) THEN 1 ELSE 0 END AS rolling_12_month
  , CASE WHEN date >= DATE_SUB(DATE_ADD(CURDATE(), INTERVAL -3 MONTH), INTERVAL DAYOFMONTH(DATE_ADD(CURDATE(), INTERVAL -3 MONTH)) - 1 DAY) AND date < DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY) THEN 1 ELSE 0 END AS rolling_03_month
  , CASE WHEN date >= DATE_SUB(DATE_ADD(CURDATE(), INTERVAL -1 MONTH), INTERVAL DAYOFMONTH(DATE_ADD(CURDATE(), INTERVAL -1 MONTH)) - 1 DAY) AND date < DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY) THEN 1 ELSE 0 END AS rolling_01_month
  , CASE WHEN date >= DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY) THEN 1 ELSE 0 END AS future_dates
FROM {{ ref('date_spine') }}

{{
config({
  "post-hook": 'ALTER TABLE {{ target.schema }}.{{ this.name }} add PRIMARY KEY(date)',
  "post-hook": 'ALTER TABLE {{ target.schema }}.{{ this.name }} add INDEX index_yearmonth (yearmonth(7))'
  })
}}
