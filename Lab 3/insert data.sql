INSERT INTO categories (category_id, name, parent_category_id)
VALUES
  (1, 'Cars',   NULL),
  (2, 'SUV', 1),
  (3, 'Sedan', 1),
  (4, 'Electric', 1),
  (5, 'Accessories', NULL);

INSERT INTO "user" (user_id, email, "password", first_name, last_name, role)
VALUES
  (1, 'admin@example.com', 'admin_password_hash', 'Igor', 'Admin', 'admin'),
  (2, 'manager@example.com', 'manager_password_hash', 'Anna', 'Manager', 'content_manager'),
  (3, 'user@example.com', 'user_password_hash', 'Oleh', 'User', 'user');

INSERT INTO banner_slide (bannerSlide_id, title, subtitle, image_url, link_url, button_text, is_active, display_order)
VALUES
  (1, 'Hot SUVs',  'Top offers this week', 'https://example.com/img/banners/suv.jpg', '/category/suv', 'View SUVs', TRUE, 0),
  (2, 'Sedan Specials', 'Comfort & efficiency', 'https://example.com/img/banners/sedan.jpg', '/category/sedan', 'Shop Sedans', TRUE, 1),
  (3, 'Go Electric', 'Future is electric', 'https://example.com/img/banners/ev.jpg', '/category/electric', 'See EVs', TRUE, 2);

INSERT INTO attribute (attribute_id, name, "type", is_filterable, is_required, display_order, unit)
VALUES
  (1, 'Brand', 'SELECT', TRUE, TRUE, 1, NULL),
  (2, 'Model', 'TEXT', FALSE, TRUE, 2, NULL),
  (3, 'Year', 'NUMBER', TRUE, TRUE, 3, 'year'),
  (4, 'Mileage', 'NUMBER', TRUE, FALSE, 4, 'km'),
  (5, 'Transmission','SELECT',TRUE, FALSE, 5, NULL),
  (6, 'Fuel type', 'SELECT', TRUE, FALSE, 6, NULL);

INSERT INTO attribute_value (attribute_value_id, attribute_id, value, display_name, display_order)
VALUES
  (1, 1, 'toyota', 'Toyota', 1),
  (2, 1, 'bmw', 'BMW', 2),
  (3, 1, 'tesla', 'Tesla', 3),
  (4, 5, 'mt', 'Manual', 1),
  (5, 5, 'at','Automatic', 2),
  (6, 6, 'petrol','Petrol', 1),
  (7, 6, 'diesel','Diesel', 2),
  (8, 6, 'electric', 'Electric', 3);

INSERT INTO category_attribute (category_attribute_id, category_id, attribute_id, is_required, display_order)
VALUES
  (1, 3, 1, TRUE,  1),
  (2, 3, 2, TRUE,  2),
  (3, 3, 3, TRUE,  3),
  (4, 3, 4, FALSE, 4),
  (5, 3, 5, FALSE, 5),
  (6, 2, 1, TRUE,  1),
  (7, 2, 3, TRUE,  2),
  (8, 2, 4, FALSE, 3),
  (9, 2, 5, FALSE, 4),
  (10,2, 6, FALSE, 5);

INSERT INTO product (product_id, category_id, main_image_id, title, description, price, availability, view_count, mileage, transmission, wheelbase, fuel_type)
VALUES
  (1, 3, NULL, 'Toyota Corolla 2018', 'Compact reliable sedan with good fuel economy.', 15500.00, 3, 0, 85000, 'Automatic', 2700, 'Petrol'),
  (2, 2, NULL, 'BMW X5 2016', 'Premium SUV with diesel engine and rich equipment.', 32000.00, 1, 0, 120000, 'Automatic', 2933, 'Diesel'),
  (3, 4, NULL, 'Tesla Model 3 2021', 'Fully electric sedan with Autopilot support.', 41000.00, 2, 0, 30000, 'Single speed', 2875, 'Electric');

INSERT INTO product_image (product_image_id, product_id, image_url, display_order, is_main)
VALUES
  (1, 1, 'https://example.com/img/products/corolla_main.jpg', 0, TRUE),
  (2, 1, 'https://example.com/img/products/corolla_side.jpg', 1, FALSE),
  (3, 2, 'https://example.com/img/products/x5_main.jpg', 0, TRUE),
  (4, 2, 'https://example.com/img/products/x5_interior.jpg', 1, FALSE),
  (5, 3, 'https://example.com/img/products/model3_main.jpg', 0, TRUE),
  (6, 3, 'https://example.com/img/products/model3_back.jpg', 1, FALSE);

UPDATE product SET main_image_id = 1 WHERE product_id = 1;
UPDATE product SET main_image_id = 3 WHERE product_id = 2;
UPDATE product SET main_image_id = 5 WHERE product_id = 3;

INSERT INTO product_attribute (product_attribute_id, product_id, attribute_id, attribute_value_id, text_value, number_value, boolean_value)
VALUES
  (1, 1, 1, 1, NULL, NULL, NULL),   
  (2, 1, 2, NULL, 'Corolla', NULL, NULL),   
  (3, 1, 3, NULL, NULL, 2018, NULL),   
  (4, 2, 1, 2, NULL, NULL, NULL),  
  (5, 2, 2, NULL, 'X5', NULL, NULL),   
  (6, 2, 3, NULL, NULL, 2016, NULL),   
  (7, 3, 1, 3, NULL, NULL, NULL),   
  (8, 3, 2, NULL, 'Model 3', NULL, NULL),   
  (9, 3, 3, NULL, NULL, 2021, NULL),   
  (10,3, 6, 8, NULL, NULL, NULL);