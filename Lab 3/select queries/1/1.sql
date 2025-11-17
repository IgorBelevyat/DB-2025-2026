--Знайти всі активні банери, відсортовані за display_order
SELECT *
FROM banner_slide
WHERE is_active = TRUE
ORDER BY display_order;
