CREATE TABLE answers (
  id bigserial PRIMARY KEY,

  content varchar NOT NULL,

  question_id int8 NOT NULL,

  is_true bool default false,

  created_at timestamp without time zone NOT NULL,

  updated_at timestamp without time zone NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id)
);

COMMENT ON TABLE answers IS 'Answers';

-- Column comments'

COMMENT ON COLUMN answers.id IS 'ID';
COMMENT ON COLUMN answers.content IS 'Content';
COMMENT ON COLUMN answers.question_id IS 'Question Id';
COMMENT ON COLUMN answers.is_true IS 'Is True';
COMMENT ON COLUMN answers.created_at IS 'Created At';
COMMENT ON COLUMN answers.updated_at IS 'Updated At';