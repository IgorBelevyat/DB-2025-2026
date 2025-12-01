-- enums
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'attribute_type') THEN
    CREATE TYPE attribute_type AS ENUM ('SELECT','TEXT','NUMBER','RANGE','BOOLEAN');
  END IF;
END$$;

-- Categories 
CREATE TABLE IF NOT EXISTS categories (
  category_id        serial PRIMARY KEY,
  name               varchar(120) NOT NULL,
  parent_category_id integer REFERENCES categories(category_id) ON DELETE SET NULL,
  created_at         timestamp NOT NULL DEFAULT now(),
  updated_at         timestamp NOT NULL DEFAULT now(),
  CONSTRAINT uq_categories_parent_name UNIQUE (parent_category_id, name)
);

-- Users
CREATE TABLE IF NOT EXISTS "user" (
  user_id    serial PRIMARY KEY,
  email      varchar(255) NOT NULL UNIQUE,
  "password" varchar(255) NOT NULL,
  first_name varchar(100) NOT NULL,
  last_name  varchar(100) NOT NULL,
  role       varchar(32)  NOT NULL CHECK (role IN ('admin','content_manager','user')),
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
);

-- Banner Slides
CREATE TABLE IF NOT EXISTS banner_slide (
  bannerSlide_id serial PRIMARY KEY,
  title          varchar(255),
  subtitle       varchar(255),
  image_url      varchar(512) NOT NULL,
  link_url       varchar(512),
  button_text    varchar(100),
  is_active      boolean      NOT NULL DEFAULT TRUE,
  display_order  smallint     NOT NULL DEFAULT 0 CHECK (display_order >= 0),
  created_at     timestamp    NOT NULL DEFAULT now(),
  updated_at     timestamp    NOT NULL DEFAULT now()
);

-- Attributes
CREATE TABLE IF NOT EXISTS attribute (
  attribute_id  serial PRIMARY KEY,
  name          varchar(120) NOT NULL UNIQUE,
  "type"        attribute_type NOT NULL,
  is_filterable boolean   NOT NULL DEFAULT FALSE,
  is_required   boolean   NOT NULL DEFAULT FALSE,
  display_order integer   NOT NULL DEFAULT 0 CHECK (display_order >= 0),
  unit          varchar(32),
  created_at    timestamp NOT NULL DEFAULT now(),
  updated_at    timestamp NOT NULL DEFAULT now()
);

-- For SELECT attributes 
CREATE TABLE IF NOT EXISTS attribute_value (
  attribute_value_id serial PRIMARY KEY,
  attribute_id       integer NOT NULL REFERENCES attribute(attribute_id) ON DELETE CASCADE,
  value              varchar(120) NOT NULL,
  display_name       varchar(120),
  display_order      integer NOT NULL DEFAULT 0 CHECK (display_order >= 0),
  created_at         timestamp NOT NULL DEFAULT now(),
  CONSTRAINT uq_attrvalue UNIQUE (attribute_id, value)
);

-- Category attributes
CREATE TABLE IF NOT EXISTS category_attribute (
  category_attribute_id serial PRIMARY KEY,
  category_id           integer NOT NULL REFERENCES categories(category_id) ON DELETE CASCADE,
  attribute_id          integer NOT NULL REFERENCES attribute(attribute_id)  ON DELETE CASCADE,
  is_required           boolean NOT NULL DEFAULT FALSE,
  display_order         integer NOT NULL DEFAULT 0 CHECK (display_order >= 0),
  CONSTRAINT uq_category_attribute UNIQUE (category_id, attribute_id)
);

-- Product image
CREATE TABLE IF NOT EXISTS product_image (
  product_image_id serial PRIMARY KEY,
  product_id       integer NOT NULL,
  image_url        varchar(512) NOT NULL,
  display_order    integer NOT NULL DEFAULT 0 CHECK (display_order >= 0),
  is_main          boolean NOT NULL DEFAULT FALSE,
  created_at       timestamp NOT NULL DEFAULT now(),

  CONSTRAINT uq_productimage_prod_pair UNIQUE (product_id, product_image_id),
  CONSTRAINT uq_product_image_order UNIQUE (product_id, display_order),
  CONSTRAINT ck_main_is_first CHECK (
    (is_main  AND display_order = 0) OR
    (NOT is_main AND display_order > 0)
  )
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_product_image_main
  ON product_image(product_id)
  WHERE is_main;

CREATE INDEX IF NOT EXISTS idx_product_image_product
  ON product_image(product_id);

-- Product
CREATE TABLE IF NOT EXISTS product (
  product_id     serial PRIMARY KEY,
  category_id    integer NOT NULL REFERENCES categories(category_id) ON DELETE RESTRICT,
  title          varchar(255) NOT NULL,
  description    text,
  price          numeric(12,2) CHECK (price IS NULL OR price >= 0),
  availability   integer      NOT NULL DEFAULT 0 CHECK (availability >= 0),
  view_count     integer      NOT NULL DEFAULT 0 CHECK (view_count >= 0),
  mileage        integer      CHECK (mileage IS NULL OR mileage >= 0),
  transmission   varchar(50),
  wheelbase      integer      CHECK (wheelbase IS NULL OR wheelbase > 0),
  fuel_type      varchar(50),
  created_at     timestamp    NOT NULL DEFAULT now(),
  updated_at     timestamp    NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_product_category ON product(category_id);

-- Product attributies
CREATE TABLE IF NOT EXISTS product_attribute (
  product_attribute_id serial PRIMARY KEY,
  product_id           integer NOT NULL REFERENCES product(product_id)   ON DELETE CASCADE,
  attribute_id         integer NOT NULL REFERENCES attribute(attribute_id) ON DELETE RESTRICT,
  attribute_value_id   integer REFERENCES attribute_value(attribute_value_id) ON DELETE RESTRICT,
  text_value           text,
  number_value         numeric,
  boolean_value        boolean,
  CONSTRAINT ck_only_one_value CHECK (
    (attribute_value_id IS NOT NULL)::int +
    (text_value         IS NOT NULL)::int +
    (number_value       IS NOT NULL)::int +
    (boolean_value      IS NOT NULL)::int = 1
  ),
  CONSTRAINT uq_product_attr UNIQUE (product_id, attribute_id)
);

CREATE INDEX IF NOT EXISTS idx_product_attribute_product ON product_attribute(product_id);
CREATE INDEX IF NOT EXISTS idx_product_attribute_attr    ON product_attribute(attribute_id);