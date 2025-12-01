-- Завдання: порахувати загальну кількість товарів, сумарну доступну кількість та середню ціну.
SELECT 
    COUNT(*) AS total_products,
    SUM(availability) AS total_units_in_stock,
    AVG(price) AS avg_price
FROM product;

-- Завдання: отримати для кожної категорії кількість авто, мінімальну та максимальну ціну.
SELECT 
    c.name AS category_name,
    COUNT(p.product_id) AS product_count,
    MIN(p.price) AS min_price,
    MAX(p.price) AS max_price
FROM categories c
JOIN product p 
    ON p.category_id = c.category_id
GROUP BY c.name
ORDER BY c.name;

-- Завдання: порахувати, скільки характеристик (product_attribute) має кожен товар.
SELECT 
    p.product_id,
    p.title,
    COUNT(pa.attribute_id) AS attribute_count
FROM product p
LEFT JOIN product_attribute pa 
    ON pa.product_id = p.product_id
GROUP BY p.product_id, p.title
ORDER BY p.product_id;

--Завдання: для кожного року випуску авто (атрибут Year) порахувати скільки машин цього року в базі тав яка їхня середня ціна.
SELECT 
    pa.number_value AS year,
    COUNT(*) AS car_count,
    AVG(p.price) AS avg_price
FROM product p
JOIN product_attribute pa
    ON pa.product_id = p.product_id
   AND pa.attribute_id = 3
GROUP BY pa.number_value
ORDER BY pa.number_value;

