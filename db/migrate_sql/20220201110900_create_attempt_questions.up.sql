CREATE TABLE attempt_questions (
  id bigserial PRIMARY KEY,

  attempt_id int8 NOT NULL,

  question_id int8 NOT NULL,

  selected_answer varchar NULL,

  created_at timestamp without time zone NOT NULL,

  updated_at timestamp without time zone NOT NULL,

  FOREIGN KEY (attempt_id) REFERENCES attempts(id),

  FOREIGN KEY (question_id) REFERENCES questions(id)
);

COMMENT ON TABLE attempt_questions IS 'Attempt Questions';

-- Column comments'

COMMENT ON COLUMN attempt_questions.id IS 'ID';
COMMENT ON COLUMN attempt_questions.attempt_id IS 'Attempt Id';
COMMENT ON COLUMN attempt_questions.question_id IS 'Question Id';
COMMENT ON COLUMN attempt_questions.selected_answer IS 'Selected Answer';
COMMENT ON COLUMN attempt_questions.created_at IS 'Created At';
COMMENT ON COLUMN attempt_questions.updated_at IS 'Updated At';