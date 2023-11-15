SELECT *
FROM(
    SELECT team_id, team_name, SUM(
        CASE 
            WHEN t.team_id = m.host_team THEN
                CASE WHEN host_goals > guest_goals THEN 3
                    WHEN host_goals = guest_goals THEN 1
                    ELSE 0 END
            WHEN t.team_id = m.guest_team THEN
                CASE WHEN guest_goals > host_goals THEN 3
                    WHEN guest_goals = host_goals THEN 1
                    ELSE 0 END
            ELSE 0 END
    ) AS scores
    FROM Teams t LEFT JOIN Matches m 
        ON t.team_id = m.host_team or t.team_id = m.guest_team
    GROUP BY team_id
)
ORDER BY scores DESC, team_name
