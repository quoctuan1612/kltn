CREATE TABLE users (
  id bigserial PRIMARY KEY,

  email varchar NOT NULL,

  encrypted_password varchar NULL,

  reset_password_token varchar NULL,

  reset_password_sent_at timestamp without time zone NULL,

  remember_created_at timestamp without time zone NULL,

  avatar varchar NULL,

  user_name varchar NULL,

  role int8 default 0,

  created_at timestamp without time zone NOT NULL,

  updated_at timestamp without time zone NOT NULL
);

COMMENT ON TABLE users IS 'Users';

-- Column comments'

COMMENT ON COLUMN users.id IS 'ID';
COMMENT ON COLUMN users.email IS 'Email';
COMMENT ON COLUMN users.encrypted_password IS 'Encrypted Password';
COMMENT ON COLUMN users.reset_password_token IS 'Reset Password Token';
COMMENT ON COLUMN users.reset_password_sent_at IS 'Reset Password Sent At';
COMMENT ON COLUMN users.remember_created_at IS 'Remember Created At';
COMMENT ON COLUMN users.avatar IS 'Avatar';
COMMENT ON COLUMN users.user_name IS 'User Name';
COMMENT ON COLUMN users.role IS 'Role';
COMMENT ON COLUMN users.created_at IS 'Created At';
COMMENT ON COLUMN users.updated_at IS 'Updated At';