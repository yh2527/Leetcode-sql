<h3>1097. Game Play Analysis V</h3>

https://leetcode.ca/all/1097.html

Table: Activity

```
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.

```
 
We define the install date of a player to be the first login day of that player.

We also define day 1 retention of some date X to be the number of players whose install date is X and they logged back in on the day right after X, divided by the number of players whose install date is X, rounded to 2 decimal places.

Write an SQL query that reports for each install date, the number of players that installed the game on that day and the day 1 retention.

The query result format is in the following example:

```
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-01 | 0            |
| 3         | 4         | 2016-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+------------+----------+----------------+
| install_dt | installs | Day1_retention |
+------------+----------+----------------+
| 2016-03-01 | 2        | 0.50           |
| 2017-06-25 | 1        | 0.00           |
+------------+----------+----------------+
Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back in on 2016-03-02 so the day 1 retention of 2016-03-01 is 1 / 2 = 0.50
Player 2 installed the game on 2017-06-25 but didn't log back in on 2017-06-26 so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00

```
---
Overview:
- There are several layers to this question - 
- Get the installation date for each player
	- JOIN:  a1.player_id = a2.player_id AND a1.event_date > a2.event_date WHERE a2.event_date IS NULL
	- Subquery: MIN(event_date) GROUP BY player_id
	- Window function: FIRST_VALUE(event_date) OVER(PARTITION BY player_id ORDER BY event_date)
- Get whether player played on the next day
	- JOIN: a1.player_id = a3.player_id AND DATEDIFF(a3.event_date, a1.event_date) = 1
	- DATE_SUB(IFNULL(LEAD(event_date) OVER(PARTITION BY player_id ...
- As a last step, group by install_dt and do the required calculations

Solution 1 (joins):
```
SELECT 
    a1.event_date AS install_dt, 
    COUNT(a1.player_id) AS installs, 
    ROUND(COUNT(a3.player_id) / COUNT(a1.player_id), 2) AS Day1_retention
FROM 
    Activity a1 
    LEFT JOIN Activity a2 ON a1.player_id = a2.player_id AND a1.event_date > a2.event_date
    LEFT JOIN Activity a3 ON a1.player_id = a3.player_id AND DATEDIFF(a3.event_date, a1.event_date) = 1
WHERE 
    a2.event_date IS NULL
GROUP BY 
    a1.event_date;
```

Solution 2 (window function/CTE):
```
WITH installation AS (
    SELECT 
        MIN(event_date) AS install_dt, 
        player_id
    FROM 
        Activity
    GROUP BY 
        player_id
),
next_play AS (
    SELECT 
        player_id, 
        event_date,
        CASE 
            WHEN DATE_SUB(IFNULL(LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date), event_date), 1) = event_date
            THEN 1 
            ELSE 0 
        END AS next_date
    FROM 
        Activity
)
SELECT 
    i.install_dt, 
    COUNT(i.player_id) AS installs, 
    ROUND(SUM(n.next_date) / COUNT(*), 2) AS Day1_retention
FROM 
    installation i 
    LEFT JOIN next_play n ON i.player_id = n.player_id AND i.install_dt = n.event_date
GROUP BY 
    i.install_dt
```
