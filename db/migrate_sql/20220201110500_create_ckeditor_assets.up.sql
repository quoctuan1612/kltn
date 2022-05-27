CREATE TABLE ckeditor_assets (
  id bigserial PRIMARY KEY,

  data_file_name varchar NOT NULL,

  data_content_type varchar NULL,

  data_file_size int8 NULL,

  type varchar NULL,

  created_at timestamp without time zone NOT NULL,

  updated_at timestamp without time zone NOT NULL
);

COMMENT ON TABLE ckeditor_assets IS 'Ckeditor Assets';

-- Column comments'

COMMENT ON COLUMN ckeditor_assets.id IS 'ID';
COMMENT ON COLUMN ckeditor_assets.data_file_name IS 'Data File Name';
COMMENT ON COLUMN ckeditor_assets.data_content_type IS 'Data Content Type';
COMMENT ON COLUMN ckeditor_assets.data_file_size IS 'Data File Size';
COMMENT ON COLUMN ckeditor_assets.type IS 'Type';
COMMENT ON COLUMN ckeditor_assets.created_at IS 'Created At';
COMMENT ON COLUMN ckeditor_assets.updated_at IS 'Updated At';