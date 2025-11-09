# Database Documentation

---

## Schema Overview

- **categories** - hierarchical structure of product categories.  
- **user** — system users with roles.  
- **banner_slide** — main banner slides on the homepage.  
- **attribute** — directory of product attribute types.  
- **attribute_value** — possible values for `SELECT`-type attributes.  
- **category_attribute** — defines which attributes apply to each category.  
- **product** — products.  
- **product_image** — product images.  
- **product_attribute** — concrete attribute values for each product.  

Additional type:
- **ENUM `attribute_type`**: `'SELECT'`, `'TEXT'`, `'NUMBER'`, `'RANGE'`, `'BOOLEAN'`.

---

## Tables and Keys

---

### 1. `categories`

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `category_id` | serial | **PRIMARY KEY** |
| `name` | varchar(120) | Category name |
| `parent_category_id` | integer | **FOREIGN KEY** → `categories(category_id)` (*ON DELETE SET NULL*) |
| `created_at` | timestamp | Creation time |
| `updated_at` | timestamp | Last update time |

**Constraints:**

- `UNIQUE (parent_category_id, name)` — prevents duplicate names within the same parent category.

**Relations:**

- `categories (1)` - `categories (many)` (*self-reference*)  
- `categories (1)` - `product (many)`

---

### 2. `user`

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `user_id` | serial | **PRIMARY KEY** |
| `email` | varchar(255) | **UNIQUE**, NOT NULL |
| `password` | varchar(255) | NOT NULL |
| `first_name` | varchar(100) | NOT NULL |
| `last_name` | varchar(100) | NOT NULL |
| `role` | varchar(32) | **CHECK**: `'admin'`, `'content_manager'`, `'user'` |
| `created_at` | timestamp | DEFAULT now() |
| `updated_at` | timestamp | DEFAULT now() |

---

### 3. `banner_slide`

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `bannerSlide_id` | serial | **PRIMARY KEY** |
| `title` | varchar(255) | Slide title |
| `subtitle` | varchar(255) | Subtitle |
| `image_url` | varchar(512) | Image URL |
| `link_url` | varchar(512) | Optional link |
| `button_text` | varchar(100) | Button text |
| `is_active` | boolean | DEFAULT TRUE |
| `display_order` | smallint | CHECK (>=0) |
| `created_at` | timestamp | DEFAULT now() |
| `updated_at` | timestamp | DEFAULT now() |

**Note:** `display_order` defines the visible order of slides.

---

### 4. `attribute`

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `attribute_id` | serial | **PRIMARY KEY** |
| `name` | varchar(120) | **UNIQUE**, NOT NULL |
| `type` | `attribute_type` | ENUM (`SELECT`, `TEXT`, `NUMBER`, `RANGE`, `BOOLEAN`) |
| `is_filterable` | boolean | DEFAULT FALSE |
| `is_required` | boolean | DEFAULT FALSE |
| `display_order` | integer | CHECK (>=0) |
| `unit` | varchar(32) | Unit of measurement |
| `created_at` | timestamp | DEFAULT now() |
| `updated_at` | timestamp | DEFAULT now() |

**Relations:**

- `attribute (1)` - `attribute_value (many)`  
- `attribute (1)` - `category_attribute (many)`  
- `attribute (1)` - `product_attribute (many)`

---

### 5. `attribute_value`

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `attribute_value_id` | serial | **PRIMARY KEY** |
| `attribute_id` | integer | **FOREIGN KEY** → `attribute(attribute_id)` (*ON DELETE CASCADE*) |
| `value` | varchar(120) | Internal value |
| `display_name` | varchar(120) | Display label |
| `display_order` | integer | CHECK (>=0) |
| `created_at` | timestamp | DEFAULT now() |

**Constraints:**

- `UNIQUE (attribute_id, value)` — prevents duplicate values per attribute.

---

### 6. `category_attribute`

**Purpose:** defines which attributes belong to a specific category.

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `category_attribute_id` | serial | **PRIMARY KEY** |
| `category_id` | integer | **FK** → `categories(category_id)` (*ON DELETE CASCADE*) |
| `attribute_id` | integer | **FK** → `attribute(attribute_id)` (*ON DELETE CASCADE*) |
| `is_required` | boolean | DEFAULT FALSE |
| `display_order` | integer | CHECK (>=0) |

**Constraints:**

- `UNIQUE (category_id, attribute_id)` — each category-attribute pair is unique.

**Relations:**
- `categories (1)` - `category_attribute (many)` - `attribute (1)`

---

### 7. `product`

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `product_id` | serial | **PRIMARY KEY** |
| `category_id` | integer | **FK** → `categories(category_id)` (*ON DELETE RESTRICT*) |
| `main_image_id` | integer | ID of main product image |
| `title` | varchar(255) | Product title |
| `description` | text | Description |
| `price` | numeric(12,2) | CHECK (>=0) |
| `availability` | integer | DEFAULT 0 |
| `view_count` | integer | DEFAULT 0 |
| `mileage` | integer | CHECK (>=0) |
| `transmission` | varchar(50) | Transmission type |
| `wheelbase` | integer | CHECK (>0) |
| `fuel_type` | varchar(50) | Fuel type |
| `created_at` | timestamp | DEFAULT now() |
| `updated_at` | timestamp | DEFAULT now() |

**Relations:**

- **Composite FOREIGN KEY:**  
  `(product_id, main_image_id)` → `product_image(product_id, product_image_id)`  
  (*ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED*)  
  ensures the main image belongs to the same product.

**Indexes:**

- `idx_product_category (category_id)`

---

### 8. `product_image`

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `product_image_id` | serial | **PRIMARY KEY** |
| `product_id` | integer | Product reference |
| `image_url` | varchar(512) | Image URL |
| `display_order` | integer | DEFAULT 0, CHECK (>=0) |
| `is_main` | boolean | DEFAULT FALSE |
| `created_at` | timestamp | DEFAULT now() |

**Constraints:**

- `UNIQUE (product_id, display_order)`  
- `CHECK ((is_main AND display_order = 0) OR (NOT is_main AND display_order > 0))`  
- **Partial UNIQUE INDEX:** `uq_product_image_main` — ensures one main image per product.

**Indexes:**

- `idx_product_image_product (product_id)`

---

### 9. `product_attribute`

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `product_attribute_id` | serial | **PRIMARY KEY** |
| `product_id` | integer | **FK** → `product(product_id)` (*ON DELETE CASCADE*) |
| `attribute_id` | integer | **FK** → `attribute(attribute_id)` (*ON DELETE RESTRICT*) |
| `attribute_value_id` | integer | **FK** → `attribute_value(attribute_value_id)` (*ON DELETE RESTRICT*) |
| `text_value` | text | Text attribute value |
| `number_value` | numeric | Numeric value |
| `boolean_value` | boolean | Boolean value |

**Constraints:**

- `UNIQUE (product_id, attribute_id)` — one attribute per value.  
- `CHECK ((attribute_value_id IS NOT NULL)::int + (text_value IS NOT NULL)::int + (number_value IS NOT NULL)::int + (boolean_value IS NOT NULL)::int = 1)`  
   ensures exactly **one type of value** per record.

**Indexes:**

- `idx_product_attribute_product (product_id)`  
- `idx_product_attribute_attr (attribute_id)`

---

## Data Integrity Rules and Requirements

- **Categories:** unique names within the same parent.  
- **Attributes:** unique names, type enforced via ENUM.  
- **Attribute values:** unique per attribute; cascade deletion on parent removal.  
- **Category–Attribute:** unique pair per category.  
- **Images:** one main image per product.  
- **Products:** main image must belong to the same product.  
- **Product Attributes:** one record per attribute; only one value type allowed.

---

## Recommended Data Insertion Order

1. Create: `categories`, `user`, `attribute`, `attribute_value`  
2. Add: `category_attribute`  
3. Insert: `product` (initially without `main_image_id`)  
4. Insert: `product_image` (main image → `display_order = 0`)  
5. Update: `product.main_image_id` for each product  
6. Insert: `product_attribute`

---

## Performance Notes

- Indexes on all foreign keys (`category_id`, `product_id`, `attribute_id`) improve JOIN speed.  

