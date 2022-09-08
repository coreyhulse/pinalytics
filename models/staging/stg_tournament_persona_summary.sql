SELECT
  ifpa_tournament_results.tournament_id
, COUNT(DISTINCT CASE WHEN stg_player_stats.player_persona = 'WPPRtunist' THEN ifpa_tournament_results.player_id ELSE NULL END) AS count_wpprtunist
, COUNT(DISTINCT CASE WHEN stg_player_stats.player_persona = 'Traveler' THEN ifpa_tournament_results.player_id ELSE NULL END) AS count_traveler
, COUNT(DISTINCT CASE WHEN stg_player_stats.player_persona = 'Local Supporter' THEN ifpa_tournament_results.player_id ELSE NULL END) AS count_localsupporter
, COUNT(DISTINCT CASE WHEN stg_player_stats.player_persona = 'One-Timer' THEN ifpa_tournament_results.player_id ELSE NULL END) AS count_onetimer
, COUNT(DISTINCT CASE WHEN stg_player_stats.player_persona = 'Non-Active' THEN ifpa_tournament_results.player_id ELSE NULL END) AS count_nonactive
FROM {{ ref('ifpa_tournament_results') }} ifpa_tournament_results
LEFT JOIN {{ ref('stg_player_stats') }} stg_player_stats
ON ifpa_tournament_results.player_id = stg_player_stats.player_id
GROUP BY 1

{{
  config({
    "post-hook": 'ALTER TABLE {{ target.schema }}.{{ this.name }} add PRIMARY KEY(tournament_id)'
    })
}}
