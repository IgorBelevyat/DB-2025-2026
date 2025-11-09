-- Users 
INSERT INTO "user" (user_id, email, "password", first_name, last_name, role)
VALUES
  (1, 'admin@example.com',  'hashed_pwd', 'Admin', 'User', 'admin'),
  (2, 'manager@example.com','hashed_pwd', 'Content','Manager','content_manager'),
  (3, 'john@example.com',   'hashed_pwd', 'John',  'Doe',  'user');

-- Categories 
INSERT INTO categories (category_id, name, parent_category_id)
VALUES
  (1, 'Cars',   NULL),
  (2, 'SUV',    1),
  (3, 'Sedan',  1);

-- Banner slides
INSERT INTO banner_slide (bannerSlide_id, title, subtitle, image_url, link_url, button_text, is_active, display_order)
VALUES
  (1, 'Осінні знижки', 'До -10% на обрані моделі', 'https://cdn.example.com/banners/fall.jpg', '/sale', 'Детальніше', TRUE, 0),
  (2, 'Електромобілі', 'Нові поставки 2025',       'https://cdn.example.com/banners/ev.jpg',   '/ev',   'Подивитись', TRUE, 1);

-- Attributes 
INSERT INTO attribute (attribute_id, name, "type", is_filterable, is_required, display_order, unit)
VALUES
  (1, 'Color',        'SELECT', TRUE,  FALSE, 1, NULL),
  (2, 'Transmission', 'SELECT', TRUE,  FALSE, 2, NULL),
  (3, 'Fuel Type',    'SELECT', TRUE,  FALSE, 3, NULL),
  (4, 'Mileage',      'NUMBER', TRUE,  FALSE, 4, 'km'),
  (5, 'Year',         'NUMBER', TRUE,  TRUE,  5, NULL),
  (6, 'Power (HP)',   'NUMBER', FALSE, FALSE, 6, 'hp'),
  (7, 'Is New',       'BOOLEAN',TRUE,  FALSE, 7, NULL);

-- Значення для SELECT-атрибутів
INSERT INTO attribute_value (attribute_value_id, attribute_id, value, display_name, display_order)
VALUES
  (1, 1, 'Red',   'Red',   1),
  (2, 1, 'Blue',  'Blue',  2),
  (3, 1, 'Black', 'Black', 3);

INSERT INTO attribute_value (attribute_value_id, attribute_id, value, display_name, display_order)
VALUES
  (4, 2, 'Manual',    'Manual',    1),
  (5, 2, 'Automatic', 'Automatic', 2);

INSERT INTO attribute_value (attribute_value_id, attribute_id, value, display_name, display_order)
VALUES
  (6, 3, 'Petrol',  'Petrol',  1),
  (7, 3, 'Diesel',  'Diesel',  2),
  (8, 3, 'Hybrid',  'Hybrid',  3),
  (9, 3, 'Electric','Electric',4);


-- Category -> Attributes (які атрибути доступні)
INSERT INTO category_attribute (category_attribute_id, category_id, attribute_id, is_required, display_order)
VALUES
  (1, 2, 5, TRUE,  1),   -- Year
  (2, 2, 1, FALSE, 2),   -- Color
  (3, 2, 2, FALSE, 3),   -- Transmission
  (4, 2, 3, FALSE, 4),   -- Fuel Type
  (5, 2, 4, FALSE, 5),   -- Mileage
  (6, 2, 6, FALSE, 6),   -- Power
  (7, 2, 7, FALSE, 7),   -- Is New
  (8, 3, 5, TRUE,  1),   -- Year
  (9, 3, 1, FALSE, 2),   -- Color
  (10,3, 2, FALSE, 3),   -- Transmission
  (11,3, 3, FALSE, 4),   -- Fuel Type
  (12,3, 4, FALSE, 5),   -- Mileage
  (13,3, 6, FALSE, 6),   -- Power
  (14,3, 7, FALSE, 7);   -- Is New


-- Products
INSERT INTO product (product_id, category_id, main_image_id, title, description, price, availability, view_count, mileage, transmission, wheelbase, fuel_type)
VALUES
  (1, 3, NULL, 'Toyota Camry 2.5 (2019)', 'Охайний седан, один власник, сервісна історія.', 17999.00, 3, 0, 45000, 'Automatic', 2825, 'Petrol'),
  (2, 2, NULL, 'BMW X5 xDrive30d (2021)', 'Повний привід, M-пакет. Дуже гарний стан.',     48900.00, 2, 0, 38000, 'Automatic', 2975, 'Diesel'),
  (3, 3, NULL, 'Nissan Leaf (2022)',       'Електро, батарея 62 кВт·год, відмінний стан.',  22900.00, 4, 0, 12000, NULL,       2700, 'Electric');

-- Product images 
-- Camry 
INSERT INTO product_image (product_image_id, product_id, image_url, display_order, is_main)
VALUES
  (1, 1, 'https://cdn.example.com/cars/camry/front.jpg', 0, TRUE),
  (2, 1, 'https://cdn.example.com/cars/camry/interior.jpg', 1, FALSE);

-- X5 
INSERT INTO product_image (product_image_id, product_id, image_url, display_order, is_main)
VALUES
  (3, 2, 'https://cdn.example.com/cars/x5/front.jpg', 0, TRUE),
  (4, 2, 'https://cdn.example.com/cars/x5/rear.jpg',  1, FALSE),
  (5, 2, 'https://cdn.example.com/cars/x5/interior.jpg', 2, FALSE);

-- Leaf 
INSERT INTO product_image (product_image_id, product_id, image_url, display_order, is_main)
VALUES
  (6, 3, 'https://cdn.example.com/cars/leaf/front.jpg', 0, TRUE),
  (7, 3, 'https://cdn.example.com/cars/leaf/dash.jpg',  1, FALSE);

-- Прив`язуємо головні фото 
UPDATE product SET main_image_id = 1 WHERE product_id = 1;
UPDATE product SET main_image_id = 3 WHERE product_id = 2;
UPDATE product SET main_image_id = 6 WHERE product_id = 3;

-- Product attributes
-- Camry 
INSERT INTO product_attribute (product_attribute_id, product_id, attribute_id, attribute_value_id, text_value, number_value, boolean_value)
VALUES
  (1, 1, 1, 2, NULL, NULL, NULL),       -- Color = Blue (id=2)
  (2, 1, 2, 5, NULL, NULL, NULL),       -- Transmission = Automatic (id=5)
  (3, 1, 3, 6, NULL, NULL, NULL),       -- Fuel = Petrol (id=6)
  (4, 1, 4, NULL, NULL, 45000, NULL),   -- Mileage = 45000
  (5, 1, 5, NULL, NULL, 2019, NULL),    -- Year = 2019
  (6, 1, 6, NULL, NULL, 203,  NULL),    -- PowerHP = 203
  (7, 1, 7, NULL, NULL, NULL, FALSE);   -- IsNew = false

-- BMW X5 (product_id=2)
INSERT INTO product_attribute (product_attribute_id, product_id, attribute_id, attribute_value_id, text_value, number_value, boolean_value)
VALUES
  (8, 2, 1, 3, NULL, NULL, NULL),       -- Color = Black
  (9, 2, 2, 5, NULL, NULL, NULL),       -- Transmission = Automatic
  (10,2, 3, 7, NULL, NULL, NULL),       -- Fuel = Diesel
  (11,2, 4, NULL, NULL, 38000, NULL),   -- Mileage = 38000
  (12,2, 5, NULL, NULL, 2021, NULL),    -- Year = 2021
  (13,2, 6, NULL, NULL, 265,  NULL),    -- PowerHP = 265
  (14,2, 7, NULL, NULL, NULL, FALSE);   -- IsNew = false

-- Nissan Leaf (product_id=3)
INSERT INTO product_attribute (product_attribute_id, product_id, attribute_id, attribute_value_id, text_value, number_value, boolean_value)
VALUES
  (15,3, 1, 1, NULL, NULL, NULL),       -- Color = Red
  (16,3, 2, 5, NULL, NULL, NULL),       -- Transmission = Automatic
  (17,3, 3, 9, NULL, NULL, NULL),       -- Fuel = Electric
  (18,3, 4, NULL, NULL, 12000, NULL),   -- Mileage = 12000
  (19,3, 5, NULL, NULL, 2022, NULL),    -- Year = 2022
  (20,3, 6, NULL, NULL, 150,  NULL),    -- PowerHP = 150
  (21,3, 7, NULL, NULL, NULL, TRUE);    -- IsNew = true

