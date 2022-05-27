CREATE TABLE attempts (
  id bigserial PRIMARY KEY,

  user_id int8 NOT NULL,

  exam_id int8 NOT NULL,

  spent_time int8 NULL,

  status int8 default 0,

  score int8 NULL,

  created_at timestamp without time zone NOT NULL,

  updated_at timestamp without time zone NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),

  FOREIGN KEY (exam_id) REFERENCES exams(id)
);

COMMENT ON TABLE attempts IS 'Attempts';

-- Column comments'

COMMENT ON COLUMN attempts.id IS 'ID';
COMMENT ON COLUMN attempts.user_id IS 'User Id';
COMMENT ON COLUMN attempts.exam_id IS 'Exam Id';
COMMENT ON COLUMN attempts.status IS 'Status';
COMMENT ON COLUMN attempts.created_at IS 'Created At';
COMMENT ON COLUMN attempts.updated_at IS 'Updated At';