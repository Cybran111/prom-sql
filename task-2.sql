CREATE TABLE
  company (
  id           INT PRIMARY KEY,
  name         VARCHAR,
  products_num INT
);

CREATE TABLE
  product (
  id         INT PRIMARY KEY,
  title      VARCHAR,
  company_id INT REFERENCES company (id)
);

INSERT INTO company
(id, name, products_num)
VALUES
  (1, 'UAPROM', 0);

CREATE OR REPLACE FUNCTION increment_products_num()
  RETURNS TRIGGER AS $$
BEGIN
  UPDATE company
  SET products_num = products_num + 1
  WHERE company.id = NEW.company_id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION decrement_products_num()
  RETURNS TRIGGER AS $$
BEGIN
  UPDATE company
  SET products_num = products_num - 1
  WHERE company.id = OLD.company_id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION move_product()
  RETURNS TRIGGER AS $$
BEGIN
  UPDATE company
  SET products_num = products_num - 1
  WHERE company.id = OLD.company_id;

  UPDATE company
  SET products_num = products_num + 1
  WHERE company.id = NEW.company_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER process_insert
AFTER INSERT ON product
FOR EACH ROW
EXECUTE PROCEDURE increment_products_num();

CREATE TRIGGER process_delete
AFTER DELETE ON product
FOR EACH ROW
EXECUTE PROCEDURE decrement_products_num();

CREATE TRIGGER process_update
AFTER UPDATE ON product
FOR EACH ROW
WHEN (OLD.company_id <> NEW.company_id)
EXECUTE PROCEDURE move_product();