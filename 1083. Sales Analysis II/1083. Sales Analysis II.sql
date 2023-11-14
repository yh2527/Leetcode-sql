WITH(
    SELECT Sales.*, product_name
    FROM Sales LEFT JOIN Product
        on SALES.product_id = Product.product_id
) AS sales_w_products
SELECT DISTINCT buyer_id
FROM sales_w_products sp
WHERE sp.product_name = 'S8'
    AND NOT EXISTS (
        SELECT 1
        FROM sales_w_products sp2
        WHERE sp2.product_name = 'iPhone'
            AND sp.buyer_id = sp2.buyer_id
    )
