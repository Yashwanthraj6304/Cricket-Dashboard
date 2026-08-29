select*from pitch_performance;

--1. Top 10 players who scored more than 5,000 runs on flat pitches

SELECT
    "player_name",
    "runs_flat_pitch"
FROM pitch_performance
WHERE "runs_flat_pitch" > 5000
ORDER BY "runs_flat_pitch" DESC
LIMIT 10;

--2.Top 10 players with the most total dismissals
SELECT
    player_name,
    dismissals_flat_pitch,
    dismissals_red_soil_pitch,
    dismissals_black_soil_pitch,
    (
        dismissals_flat_pitch +
        dismissals_red_soil_pitch +
        dismissals_black_soil_pitch
    ) AS total_dismissals
FROM pitch_performance
ORDER BY total_dismissals DESC
LIMIT 10;

--3. Each player’s minimum and maximum runs across all pitch types

SELECT
    player_name,
    LEAST(
        runs_flat_pitch,
        runs_red_soil_pitch,
        runs_black_soil_pitch
    ) AS minimum_runs,
    GREATEST(
        runs_flat_pitch,
        runs_red_soil_pitch,
        runs_black_soil_pitch
    ) AS maximum_runs
FROM pitch_performance;

--4. Players whose names start with a specific letter
--Players whose names start with A:
SELECT *
FROM pitch_performance
WHERE player_name ILIKE 'A%';


SELECT *
FROM pitch_performance
WHERE player_name ILIKE 'A%'
   OR player_name ILIKE 'B%';
   
--5.Players whose total runs are greater than total dismissals

SELECT
    player_name,
    (
        runs_flat_pitch +
        runs_red_soil_pitch +
        runs_black_soil_pitch
    ) AS total_runs,
    (
        dismissals_flat_pitch +
        dismissals_red_soil_pitch +
        dismissals_black_soil_pitch
    ) AS total_dismissals
FROM pitch_performance
WHERE
    (
        runs_flat_pitch +
        runs_red_soil_pitch +
        runs_black_soil_pitch
    )
    >
    (
        dismissals_flat_pitch +
        dismissals_red_soil_pitch +
        dismissals_black_soil_pitch
    )
ORDER BY total_runs DESC;

--7. Players with more runs on red-soil pitches than Sachin Tendulkar
SELECT DISTINCT
    player_name,
    runs_red_soil_pitch
FROM pitch_performance
WHERE runs_red_soil_pitch >
(
    SELECT MAX(runs_red_soil_pitch)
    FROM pitch_performance
    WHERE player_name = 'SR Tendulkar'
)
ORDER BY runs_red_soil_pitch DESC;

--8.Average dismissals on flat, red-soil and black-soil pitches
SELECT
    ROUND(AVG(dismissals_flat_pitch), 2)
        AS average_flat_pitch_dismissals,
    ROUND(AVG(dismissals_red_soil_pitch), 2)
        AS average_red_soil_dismissals,
    ROUND(AVG(dismissals_black_soil_pitch), 2)
        AS average_black_soil_dismissals
FROM pitch_performance;

--9. Average runs on flat, red-soil and black-soil pitches
SELECT
    ROUND(AVG(runs_flat_pitch), 2)
        AS average_flat_pitch_runs,
    ROUND(AVG(runs_red_soil_pitch), 2)
        AS average_red_soil_runs,
    ROUND(AVG(runs_black_soil_pitch), 2)
        AS average_black_soil_runs
FROM pitch_performance;

--10.count Players who scored zero runs on any pitch type

SELECT COUNT(DISTINCT player_name) AS zero_runs_player_count
FROM pitch_performance
WHERE runs_flat_pitch = 0
   OR runs_red_soil_pitch = 0
   OR runs_black_soil_pitch = 0;