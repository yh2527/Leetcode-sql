<h3>607. Sales Person</h3>
---

https://leetcode.com/problems/sales-person/description/

Table: SalesPerson

```
+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
| sales_id        | int     |
| name            | varchar |
| salary          | int     |
| commission_rate | int     |
| hire_date       | date    |
+-----------------+---------+
sales_id is the primary key (column with unique values) for this table.
Each row of this table indicates the name and the ID of a salesperson alongside their salary, commission rate, and hire date.
```

Table: Company

```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| com_id      | int     |
| name        | varchar |
| city        | varchar |
+-------------+---------+
com_id is the primary key (column with unique values) for this table.
Each row of this table indicates the name and the ID of a company and the city in which the company is located.
```

Table: Orders

```
+-------------+------+
| Column Name | Type |
+-------------+------+
| order_id    | int  |
| order_date  | date |
| com_id      | int  |
| sales_id    | int  |
| amount      | int  |
+-------------+------+
order_id is the primary key (column with unique values) for this table.
com_id is a foreign key (reference column) to com_id from the Company table.
sales_id is a foreign key (reference column) to sales_id from the SalesPerson table.
Each row of this table contains information about one order. This includes the ID of the company, the ID of the salesperson, the date of the order, and the amount paid.
```

Question: Write a solution to find the names of all the salespersons who did not have any orders related to the company with the name "RED". Return the result table in any order.



---
Overview:
- select SalesPerson.name
- condition the result by NOT EXISTS in the WHERE clause
	- for each SalesPerson.sales_id, the subquery looks for:
		- orders with the company name 'RED'
		- AND any such order has the same sales_id with SalesPerson.sales_id

Other Points:
- NOT IN vs NOT EXISTS
	- NOT IN: 
		- exclude rows based on a list of values, used when you have a list of static values or when you're using a subquery to generate a list.
		- If there are any NULL values returned by the subquery in the NOT IN list, the entire query will return zero results.
		- SQL standard's treatment of NULL is "unknown."
		- 
	- NOT EXISTS: 
		- used with a subquery and check if the subquery returns any rows. If the subquery returns no rows, the NOT EXISTS condition is true.
		- NOT EXISTS will still include rows in the result set if there are NULL values encountered in the subquery.
		- 

Solution:
```
SELECT s.name
FROM SalesPerson as s 
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders as o JOIN Company as c
        ON o.com_id = c.com_id
    WHERE s.sales_id = o.sales_id
        AND c.name = 'RED'
)
```
