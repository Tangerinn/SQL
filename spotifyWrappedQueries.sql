--Your Top 5 Artists by Play Count
SELECT
    artistName,
    COUNT(*) AS play_count
FROM
    listening_history
GROUP BY
    artistName
ORDER BY
    play_count DESC
LIMIT 5;

-- Your Total Listening Time (in Hours)
SELECT
    ROUND(SUM(msPlayed) / (1000 * 60 * 60), 2) AS total_hours_played
FROM
    listening_history;

-- Your Top 5 Tracks by Play Count
SELECT
    trackName,
    artistName,
    COUNT(*) AS play_count
FROM
    listening_history
GROUP BY
    trackName,
    artistName
ORDER BY
    play_count DESC
LIMIT 5;

-- Your Top 5 Tracks by Time Spent Listening
SELECT
    trackName,
    artistName,
    ROUND(SUM(msPlayed) / 60000, 2) AS total_minutes_played
FROM
    listening_history
GROUP BY
    trackName,
    artistName
ORDER BY
    total_minutes_played DESC
LIMIT 5;

--Your Most Active Day of the Week
SELECT
    DAYNAME(endTime) AS day_of_week,
    COUNT(*) AS play_count
FROM
    listening_history
GROUP BY
    day_of_week
ORDER BY
    play_count DESC;
