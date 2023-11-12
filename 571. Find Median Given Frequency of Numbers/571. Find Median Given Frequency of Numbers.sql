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

/*
select avg(Number) as median from (
    select n1.Number from Numbers n1 join Numbers n2 on n1.Number >= n2.Number
        group by n1.Number
        having
        sum(n2.Frequency) >= (select sum(Frequency) from Numbers) / 2
        and
        sum(n2.Frequency) - avg(n1.Frequency) <= (select sum(Frequency) from Numbers) / 2
) med;
 */
