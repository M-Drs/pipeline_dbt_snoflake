SELECT
    PULOCATIONID AS pickup_zone,
    COUNT(*) AS trip_count,
    AVG(TOTAL_AMOUNT) AS avg_revenue,
    SUM(TOTAL_AMOUNT) AS total_revenue
FROM {{ ref('CURATION_YELLOW_TAXI') }} -- va directement se sourcer dans la table clean_trip dans le schéma STAGGING
GROUP BY PULOCATIONID
ORDER BY trip_count DESC