<h3>571. Find Median Given Frequency of Numbers</h3>

https://leetcode.ca/2017-06-23-571-Find-Median-Given-Frequency-of-Numbers/

The Numbers table keeps the value of number and its frequency.

```
+----------+-------------+
|  Number  |  Frequency  |
+----------+-------------|
|  0       |  7          |
|  1       |  1          |
|  2       |  3          |
|  3       |  1          |
+----------+-------------+

```

In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

```
+--------+
| median |
+--------|
| 0.0000 |
+--------+

```

Write a query to find the median of all numbers and name the result as median.

---
Overview:
- Look for the number/numbers that has cumulative frequency equal or bigger than half of the total frequency, and its previous number has cumulative frequency equal or less than half of the total frequency
- If there are multiple different values meet the condition, we need to get their average to get the median


- Method 1 - window function
```
WITH RunningTotals AS (
    SELECT
        number,
        frequency,
        SUM(frequency) OVER (ORDER BY number) AS running_total
    FROM
        frequency_table
)
SELECT avg(number)
FROM RunningTotals
WHERE running_total >= (SELECT sum(frequency) FROM frequency_table) / 2
AND running_total - frequency <= (SELECT sum(frequency) FROM frequency_table) / 2
```


- Method 2 - join to itself with numbers <= self and group to get running sum
```
# Write your MySQL query statement below
select avg(Number) as median from (
    select n1.Number from Numbers n1 join Numbers n2 on n1.Number >= n2.Number
        group by n1.Number
        having
        sum(n2.Frequency) >= (select sum(Frequency) from Numbers) / 2
        and
        sum(n2.Frequency) - avg(n1.Frequency) <= (select sum(Frequency) from Numbers) / 2
) med;
```
