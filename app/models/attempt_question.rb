class AttemptQuestion < ApplicationRecord
  serialize :selected_answer, Array

  belongs_to :attempt
  belongs_to :question

  validates :question_id, presence: true, uniqueness: {scope: :attempt_id}

  def choose_right?
    selected_answer.sort == question.answers.true_answer.collect{|answer| "#{answer.id}"}.sort ? "<p class='label label-success'>Đúng</p>" : "<p class='label label-danger'>Sai</p>"
  end
end
