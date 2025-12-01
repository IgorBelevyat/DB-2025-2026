--Завдання: знайти всі авто, чия ціна вища за середню ціну по всіх товарах.
SELECT 
    product_id,
    title,
    price
FROM product
WHERE price > (SELECT AVG(price) FROM product)
ORDER BY price DESC;

--Завдання: вивести авто та в окремому полі показати, скільки атрибутів для нього заповнено.
SELECT 
    p.product_id,
    p.title,
    (
        SELECT COUNT(*) 
        FROM product_attribute pa
        WHERE pa.product_id = p.product_id
    ) AS attribute_count
FROM product p
ORDER BY p.product_id;

--Завдання: знайти бренди, середня ціна авто яких вища, ніж середня ціна по всіх авто.
SELECT 
    av.display_name AS brand,
    AVG(p.price) AS avg_brand_price
FROM product p
JOIN product_attribute pa
    ON pa.product_id = p.product_id
    AND pa.attribute_id = 1     
JOIN attribute_value av
    ON av.attribute_value_id = pa.attribute_value_id
GROUP BY av.display_name
HAVING AVG(p.price) > (SELECT AVG(price) FROM product)
ORDER BY avg_brand_price DESC;
