--Завдання: вивести всі авто разом з їх брендом
SELECT 
    p.product_id,
    p.title,
    av.display_name AS brand
FROM product p
JOIN product_attribute pa
    ON pa.product_id = p.product_id
    AND pa.attribute_id = 1           
JOIN attribute_value av
    ON av.attribute_value_id = pa.attribute_value_id
ORDER BY p.product_id;

--Завдання: показати всі категорії, навіть якщо в них ще нема товарів.
SELECT 
    c.category_id,
    c.name AS category_name,
    COUNT(p.product_id) AS product_count
FROM categories c
LEFT JOIN product p 
    ON p.category_id = c.category_id
GROUP BY c.category_id, c.name
ORDER BY c.category_id;

--Завдання: показати всі продукти та їхні категорії, навіть якщо теоретично категорія могла б бути втрачена.
SELECT
    p.product_id,
    p.title,
    c.category_id,
    c.name AS category_name
FROM categories c
RIGHT JOIN product p
    ON p.category_id = c.category_id
ORDER BY p.product_id;
