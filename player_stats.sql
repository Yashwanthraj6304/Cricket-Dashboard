select*from players_stats

--1. Calculate total career runs in all formats
SELECT
    player_name,
    test_runs,
    odi_runs,
    t20_runs,
    test_runs + odi_runs + t20_runs AS total_runs
FROM players_stats
ORDER BY total_runs DESC;

--Find players whose ODI runs are greater than Test and T20 runs
SELECT
    player_name,
    test_runs,
    odi_runs,
    t20_runs
FROM players_stats
WHERE odi_runs > test_runs
  AND odi_runs > t20_runs
ORDER BY odi_runs DESC;

--3. Find players with more Test runs than ODI runs
SELECT
    player_name,
    test_runs,
    odi_runs,
    test_runs - odi_runs AS run_difference
FROM players_stats
WHERE test_runs > odi_runs
ORDER BY run_difference DESC;

--4. Compare total runs with wickets for all-rounders
SELECT
    player_name,
    test_runs + odi_runs + t20_runs AS total_runs,
    wickets,
    ROUND(
        (test_runs + odi_runs + t20_runs)::NUMERIC /
        NULLIF(wickets, 0),
        2
    ) AS runs_per_wicket
FROM players_stats
WHERE LOWER(player_role) IN ('all-rounder', 'all rounder')
ORDER BY runs_per_wicket DESC;

--5. Find players with more centuries than expected from their fifties
SELECT
    player_name,
    fifties,
    hundreds,
    ROUND(
        hundreds::NUMERIC / NULLIF(fifties, 0),
        2
    ) AS century_to_fifty_ratio
FROM players_stats
WHERE hundreds > 0
  AND fifties < hundreds * 2
ORDER BY century_to_fifty_ratio DESC;

--6.Calculate statistics by nationality
SELECT
    nationality,
    COUNT(*) AS total_players,
    SUM(test_runs + odi_runs + t20_runs) AS total_runs,
    SUM(wickets) AS total_wickets,
    SUM(fifties) AS total_fifties,
    SUM(hundreds) AS total_centuries
FROM players_stats
GROUP BY nationality
ORDER BY total_runs DESC;

--7.Find the top player from each nationality based on total runs
WITH ranked_players AS (
    SELECT
        player_name,
        nationality,
        test_runs + odi_runs + t20_runs AS total_runs,
        ROW_NUMBER() OVER (
            PARTITION BY nationality
            ORDER BY test_runs + odi_runs + t20_runs DESC
        ) AS player_rank
    FROM players_stats
)
SELECT
    player_name,
    nationality,
    total_runs
FROM ranked_players
WHERE player_rank = 1
ORDER BY total_runs DESC;

UPDATE players_stats
SET nationality = 'England'
WHERE player_name ='T Kohler-Cadmore';


--8.list all players based on selected nation
SELECT *
FROM players_stats
WHERE nationality = 'India'
ORDER BY player_name;
