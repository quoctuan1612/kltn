CREATE TABLE categories (
  id bigserial PRIMARY KEY,

  name varchar NOT NULL,

  description varchar NULL,

  created_at timestamp without time zone NOT NULL,

  updated_at timestamp without time zone NOT NULL
);

COMMENT ON TABLE categories IS 'Categories';

-- Column comments'

COMMENT ON COLUMN categories.id IS 'ID';
COMMENT ON COLUMN categories.name IS 'Name';
COMMENT ON COLUMN categories.description IS 'Description';
COMMENT ON COLUMN categories.created_at IS 'Created At';
COMMENT ON COLUMN categories.updated_at IS 'Updated At';