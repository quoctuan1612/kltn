CREATE TABLE exam_questions (
  id bigserial PRIMARY KEY,

  question_id int8 NOT NULL,

  exam_id int8 NOT NULL,

  created_at timestamp without time zone NOT NULL,

  updated_at timestamp without time zone NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),

  FOREIGN KEY (exam_id) REFERENCES exams(id)
);

COMMENT ON TABLE exam_questions IS 'Exam Questions';

-- Column comments'

COMMENT ON COLUMN exam_questions.id IS 'ID';
COMMENT ON COLUMN exam_questions.question_id IS 'Question Id';
COMMENT ON COLUMN exam_questions.exam_id IS 'Exam Id';
COMMENT ON COLUMN exam_questions.created_at IS 'Created At';
COMMENT ON COLUMN exam_questions.updated_at IS 'Updated At';