<h3>1141. User Activity for the Past 30 Days I</h3>

https://leetcode.com/problems/user-activity-for-the-past-30-days-i/description/

Table: Activity
```
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| session_id    | int     |
| activity_date | date    |
| activity_type | enum    |
+---------------+---------+
This table may have duplicate rows.
The activity_type column is an ENUM (category) of type ('open_session', 'end_session', 'scroll_down', 'send_message').
The table shows the user activities for a social media website. 
Note that each session belongs to exactly one user.
``` 

Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.

Return the result table in any order.

The result format is in the following example.

---
Overview:
- Count distinct users by date
- Limit the range of the dates
	- Arithmetic operators 
		- option 1: manually calculate the  start date
			- activity_date>'2019-06-27' AND activity_date<='2019-07-27'
		- option 2: DATEDIFF(d1, d2)
			- DATEDIFF(date1, date2) calculates date1 - date2
			- DATEDIFF('2019-07-27', activity_date)<30 AND DATEDIFF('2019-07-27', activity_date)>=0 
	- use BETWEEN
		- option 1: manually calculate the start date
			- activity_day BETWEEN '2019-06-28' AND '2019-07-27'
			- 2019-06-28' is used because the BETWEEN operator is inclusive, which means the begin and end values are included.
		- option 2: DATEDIFF(d1, d2)
			- DATEDIFF('2019-07-27', activity_date) BETWEEN 0 AND 29
		- option 3: DATE_SUB(date, INTERVAL value unit)
			- returns a date/datetime after the specified interval is subtracted from given date
			- activity_date BETWEEN date_sub('2019-07-27', INTERVAL 29 DAY) AND '2019-07-27'

Solution:
```
SELECT 
    activity_date AS day, 
    COUNT(DISTINCT user_id) AS active_users
FROM 
    Activity
WHERE 
    DATEDIFF('2019-07-27', activity_date) < 30
    AND DATEDIFF('2019-07-27', activity_date)>=0
GROUP BY 1
```
