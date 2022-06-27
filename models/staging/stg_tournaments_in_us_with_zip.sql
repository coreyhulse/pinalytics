SELECT
  tournament_id
, postal_code
FROM {{ ref('stg_ifpa_tournaments') }}
WHERE country_us = 1
AND postal_code_known = 1

{{
  config({
    "post-hook": 'ALTER TABLE {{ target.schema }}.{{ this.name }} add PRIMARY KEY(tournament_id)',
    "post-hook": 'ALTER TABLE {{ target.schema }}.{{ this.name }} add INDEX index_postal_code (postal_code)'
    })
}}