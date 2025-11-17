--Знайти усі підкатегорії категорії Cars, якщо в неї category_id = 1
SELECT *
FROM categories
WHERE parent_category_id = 1;
