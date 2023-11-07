SELECT s.name
FROM SalesPerson as s 
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders as o JOIN Company as c
        ON o.com_id = c.com_id
    WHERE s.sales_id = o.sales_id
        AND c.name = 'RED'
)
