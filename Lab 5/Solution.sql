ALTER TABLE product
  DROP CONSTRAINT IF EXISTS fk_product_main_image;

ALTER TABLE product
  DROP COLUMN IF EXISTS main_image_id;
