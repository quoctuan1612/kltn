CREATE TABLE exams (
  id bigserial PRIMARY KEY,

  duration int8 NULL,

  title varchar NULL,

  result_pass int8 NULL,

  max_number_of_times int8 NULL,

  password varchar NULL,

  category_id int8 NULL,

  user_id int8 NULL,

  is_show_detail_result bool default false,

  created_at timestamp without time zone NOT NULL,

  updated_at timestamp without time zone NOT NULL,

  FOREIGN KEY (category_id) REFERENCES categories(id)
);

COMMENT ON TABLE exams IS 'Exams';

-- Column comments'

COMMENT ON COLUMN exams.id IS 'ID';
COMMENT ON COLUMN exams.duration IS 'Duration';
COMMENT ON COLUMN exams.title IS 'Title';
COMMENT ON COLUMN exams.result_pass IS 'Result Pass';
COMMENT ON COLUMN exams.max_number_of_times IS 'Max Number Of Times';
COMMENT ON COLUMN exams.category_id IS 'Category Id';
COMMENT ON COLUMN exams.created_at IS 'Created At';
COMMENT ON COLUMN exams.updated_at IS 'Updated At';