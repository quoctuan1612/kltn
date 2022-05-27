CREATE TABLE questions (
  id bigserial PRIMARY KEY,

  category_id int8 NOT NULL,

  content varchar NOT NULL,

  question_type int8 default 0,

  level int8 NULL default 1,

  user_id int8 NULL,

  created_at timestamp without time zone NOT NULL,

  updated_at timestamp without time zone NOT NULL,

  FOREIGN KEY (category_id) REFERENCES categories(id)
);

COMMENT ON TABLE questions IS 'Questions';

-- Column comments'

COMMENT ON COLUMN questions.id IS 'ID';
COMMENT ON COLUMN questions.category_id IS 'Category Id';
COMMENT ON COLUMN questions.content IS 'Content';
COMMENT ON COLUMN questions.question_type IS 'Question Type';
COMMENT ON COLUMN questions.created_at IS 'Created At';
COMMENT ON COLUMN questions.updated_at IS 'Updated At';