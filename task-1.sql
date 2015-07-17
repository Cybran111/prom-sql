-- DROP TABLE category;

CREATE TABLE
category (
  id INT PRIMARY KEY,
  parent_id INT REFERENCES category(id),
  price INT NULL
);

INSERT INTO category
 (id, parent_id, price)
  VALUES
   (1, null, 1),
   (2, 1, null),
   (3, 1, 2),
   (4, 2, null),
   (5, 4, 3),
   (6, 3, 4),
   (7, 3, null)
;

WITH RECURSIVE
 cat_price (id, parent_id, price) AS (
    SELECT
      c.id,
      c.parent_id,
      c.price
    FROM category c
    UNION ALL
    SELECT
      ct.id,
      c.parent_id,
      c.price
    FROM
      category c
      JOIN cat_price ct ON ct.parent_id = c.id
    WHERE ct.price IS NULL
  )
SELECT cat_price.id, cat_price.price
FROM cat_price
WHERE cat_price.price IS NOT NULL
ORDER BY cat_price.id;