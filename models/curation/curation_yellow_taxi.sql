

WITH cleaned_trips AS (
    SELECT
        VENDORID,
        TO_TIMESTAMP(TPEP_PICKUP_DATETIME/1000000) AS pickup_datetime,
        TO_TIMESTAMP(TPEP_DROPOFF_DATETIME/1000000) AS dropoff_datetime,
        PASSENGER_COUNT,
        TRIP_DISTANCE,
        PULOCATIONID,
        DOLOCATIONID,
        FARE_AMOUNT,
        TOTAL_AMOUNT,
        TIP_AMOUNT
    FROM NYC_TAXI_DB.RAW.YELLOW_TAXI_TRIPS
    WHERE 
        -- Éliminer les montants négatifs
        FARE_AMOUNT >= 0
        AND TOTAL_AMOUNT >= 0
        -- Pickup avant dropoff
        AND TPEP_PICKUP_DATETIME < TPEP_DROPOFF_DATETIME
        -- Distances plausibles
        AND TRIP_DISTANCE BETWEEN 0.1 AND 100
        -- Exclure zones NULL
        AND PULOCATIONID IS NOT NULL
        AND DOLOCATIONID IS NOT NULL
)
SELECT
    VENDORID,
    pickup_datetime,
    dropoff_datetime,
    PASSENGER_COUNT,
    TRIP_DISTANCE,
    PULOCATIONID,
    DOLOCATIONID,
    FARE_AMOUNT,
    TOTAL_AMOUNT,
    TIP_AMOUNT,

    -- Durée du trajet en minutes
    DATEDIFF('minute', pickup_datetime, dropoff_datetime) AS trip_duration_min,

    -- Dimensions temporelles
    DATE_PART('hour', pickup_datetime)  AS pickup_hour,
    DATE_PART('day', pickup_datetime)   AS pickup_day,
    DATE_PART('month', pickup_datetime) AS pickup_month,

    -- Vitesse moyenne (miles par heure)
    CASE 
        WHEN DATEDIFF('minute', pickup_datetime, dropoff_datetime) > 0 
        THEN TRIP_DISTANCE / (DATEDIFF('minute', pickup_datetime, dropoff_datetime) / 60.0)
        ELSE NULL
    END AS avg_speed_mph,

    -- % de pourboire (par rapport au total sans négatifs)
    CASE 
        WHEN TOTAL_AMOUNT > 0 
        THEN (TIP_AMOUNT / TOTAL_AMOUNT) * 100
        ELSE NULL
    END AS tip_percentage

FROM cleaned_trips 