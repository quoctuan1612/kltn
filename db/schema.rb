# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_01_110900) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", comment: "Answers", force: :cascade do |t|
    t.string "content", null: false, comment: "Content"
    t.bigint "question_id", null: false, comment: "Question Id"
    t.boolean "is_true", default: false, comment: "Is True"
    t.datetime "created_at", null: false, comment: "Created At"
    t.datetime "updated_at", null: false, comment: "Updated At"
  end

  create_table "attempt_questions", comment: "Attempt Questions", force: :cascade do |t|
    t.bigint "attempt_id", null: false, comment: "Attempt Id"
    t.bigint "question_id", null: false, comment: "Question Id"
    t.string "selected_answer", comment: "Selected Answer"
    t.datetime "created_at", null: false, comment: "Created At"
    t.datetime "updated_at", null: false, comment: "Updated At"
  end

  create_table "attempts", comment: "Attempts", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "User Id"
    t.bigint "exam_id", null: false, comment: "Exam Id"
    t.bigint "spent_time"
    t.bigint "status", default: 0, comment: "Status"
    t.bigint "score"
    t.datetime "created_at", null: false, comment: "Created At"
    t.datetime "updated_at", null: false, comment: "Updated At"
  end

  create_table "categories", comment: "Categories", force: :cascade do |t|
    t.string "name", null: false, comment: "Name"
    t.string "description", comment: "Description"
    t.datetime "created_at", null: false, comment: "Created At"
    t.datetime "updated_at", null: false, comment: "Updated At"
  end

  create_table "ckeditor_assets", comment: "Ckeditor Assets", force: :cascade do |t|
    t.string "data_file_name", null: false, comment: "Data File Name"
    t.string "data_content_type", comment: "Data Content Type"
    t.bigint "data_file_size", comment: "Data File Size"
    t.string "type", comment: "Type"
    t.datetime "created_at", null: false, comment: "Created At"
    t.datetime "updated_at", null: false, comment: "Updated At"
  end

  create_table "exam_questions", comment: "Exam Questions", force: :cascade do |t|
    t.bigint "question_id", null: false, comment: "Question Id"
    t.bigint "exam_id", null: false, comment: "Exam Id"
    t.datetime "created_at", null: false, comment: "Created At"
    t.datetime "updated_at", null: false, comment: "Updated At"
  end

  create_table "exams", comment: "Exams", force: :cascade do |t|
    t.bigint "duration", comment: "Duration"
    t.string "title", comment: "Title"
    t.bigint "result_pass", comment: "Result Pass"
    t.bigint "max_number_of_times", comment: "Max Number Of Times"
    t.string "password"
    t.bigint "category_id", comment: "Category Id"
    t.bigint "user_id"
    t.boolean "is_show_detail_result", default: false
    t.datetime "created_at", null: false, comment: "Created At"
    t.datetime "updated_at", null: false, comment: "Updated At"
  end

  create_table "questions", comment: "Questions", force: :cascade do |t|
    t.bigint "category_id", null: false, comment: "Category Id"
    t.string "content", null: false, comment: "Content"
    t.bigint "question_type", default: 0, comment: "Question Type"
    t.bigint "level", default: 1
    t.bigint "user_id"
    t.datetime "created_at", null: false, comment: "Created At"
    t.datetime "updated_at", null: false, comment: "Updated At"
  end

  create_table "users", comment: "Users", force: :cascade do |t|
    t.string "email", null: false, comment: "Email"
    t.string "encrypted_password", comment: "Encrypted Password"
    t.string "reset_password_token", comment: "Reset Password Token"
    t.datetime "reset_password_sent_at", comment: "Reset Password Sent At"
    t.datetime "remember_created_at", comment: "Remember Created At"
    t.string "avatar", comment: "Avatar"
    t.string "user_name", comment: "User Name"
    t.bigint "role", default: 0, comment: "Role"
    t.datetime "created_at", null: false, comment: "Created At"
    t.datetime "updated_at", null: false, comment: "Updated At"
  end

  add_foreign_key "answers", "questions", name: "answers_question_id_fkey"
  add_foreign_key "attempt_questions", "attempts", name: "attempt_questions_attempt_id_fkey"
  add_foreign_key "attempt_questions", "questions", name: "attempt_questions_question_id_fkey"
  add_foreign_key "attempts", "exams", name: "attempts_exam_id_fkey"
  add_foreign_key "attempts", "users", name: "attempts_user_id_fkey"
  add_foreign_key "exam_questions", "exams", name: "exam_questions_exam_id_fkey"
  add_foreign_key "exam_questions", "questions", name: "exam_questions_question_id_fkey"
  add_foreign_key "exams", "categories", name: "exams_category_id_fkey"
  add_foreign_key "questions", "categories", name: "questions_category_id_fkey"
end
