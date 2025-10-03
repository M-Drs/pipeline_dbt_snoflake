SELECT
    PICKUP_HOUR,
    COUNT(*) AS trip_count,
    SUM(TOTAL_AMOUNT) AS total_revenue,
    AVG(AVG_SPEED_MPH) AS avg_speed
FROM {{ ref('curation_yellow_taxi') }}
GROUP BY PICKUP_HOUR
ORDER BY PICKUP_HOUR