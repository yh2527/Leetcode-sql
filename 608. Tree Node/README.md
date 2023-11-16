<h3>1083. Sales Analysis II</h3>

https://leetcode.ca/all/1083.html

Table: Product
```
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id is the primary key of this table.
```

Table: Sales
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+------ ------+---------+
This table has no primary key, it can have repeated rows.
product_id is a foreign key to Product table.
```

Example:
```
Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+

Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 1          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 3        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+

Result table:
+-------------+
| buyer_id    |
+-------------+
| 1           |
+-------------+
The buyer with id 1 bought an S8 but didn't buy an iPhone. The buyer with id 3 bought both.
```
Question: Write an SQL query that reports the buyers who have bought S8 but not iPhone. Note that S8 and iPhone are products present in the Product table.

---
Overview:
- select distinct buyer_id with 'S8' product purchase
- filter out the buyer_id with 'iPhone' product purchase

Other Points:
- NOT IN vs NOT EXISTS
	- NOT IN: 
		- exclude rows based on a list of values, used when you have a list of static values or when you're using a subquery to generate a list.
		- If there are any NULL values returned by the subquery in the NOT IN list, the entire query will return zero results.
		- SQL standard's treatment of NULL is "unknown."
		```
 		  SELECT *
		  FROM TableA
		  WHERE ColumnX NOT IN (SELECT ColumnY FROM TableB);
  		```

	- NOT EXISTS: 
		- used with a subquery and check if the subquery returns any rows. If the subquery returns no rows, the NOT EXISTS condition is true.
		- NOT EXISTS will still include rows in the result set if there are NULL values encountered in the subquery.
		```
  		  SELECT *
		  FROM TableA a
		  WHERE NOT EXISTS (SELECT 1 FROM TableB b WHERE b.ColumnY = a.ColumnX);
  		```

Solution 1 (CTE):
```
WITH sales_w_products AS (
    SELECT Sales.*, product_name
    FROM Sales LEFT JOIN Product
        on SALES.product_id = Product.product_id
)
SELECT DISTINCT buyer_id
FROM sales_w_products sp
WHERE sp.product_name = 'S8'
    AND NOT EXISTS (
        SELECT 1
        FROM sales_w_products sp2
        WHERE sp2.product_name = 'iPhone'
            AND sp.buyer_id = sp2.buyer_id
    )
```

Solution 2(direct joins):
```
select distinct buyer_id 
    from Sales s left join Product p 
        on s.product_id = p.product_id
    where p.product_name = 'S8'
    and s.buyer_id not in (
        select s.buyer_id 
        from Sales s left join Product p 
            on s.product_id = p.product_id
        where p.product_name = 'iPhone'
    );
```
