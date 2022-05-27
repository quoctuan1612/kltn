class Attempt < ApplicationRecord
  belongs_to :user
  belongs_to :exam
  has_many :attempt_questions, dependent: :destroy
  has_many :questions, through: :attempt_questions

  accepts_nested_attributes_for :attempt_questions, allow_destroy: true

  enum status: { pending: 0, finish: 1}

  validates :user_id, presence: true
  validates :exam_id, presence: true
  validate :max_attempts, on: :create

  delegate :title, :category_name, :duration, to: :exam, prefix: true

  scope :order_created_at, -> {order(created_at: :desc)}
  scope :by_exam_id, -> (exam_id){where(exam_id: exam_id) if exam_id.present?}
  scope :by_category_id, ->(category_id){includes(:exam).where(exams: {category_id: category_id}) if category_id.present?}
  scope :by_user_id, -> (user_id){where user_id: user_id}
  scope :by_status, -> (status){where(status: status) if Attempt.statuses.keys.include?(status)}

  after_update :set_score

  def self.by_result result
    if result == Settings.attempt.result.passed
      joins(:exam).where("score >= exams.result_pass")
    elsif result == Settings.attempt.result.failed
      joins(:exam).where("score < exams.result_pass")
    else
      all
    end
  end

  def i18n_status
    finish? ? "Đã hoàn thành" : "Chưa hoàn thành"
  end

  def label_status
    finish? ? "primary" : "warning"
  end

  def result
    if score < exam.result_pass
      "<p class='label label-danger'>Trượt</p>"
    else
      "<p class='label label-success'>Đỗ</p>"
    end
  end

  def set_score
    final_score = 0
    self.attempt_questions.eager_load(question: :answers).each do |attempt_question|
      list_true_answers_id = attempt_question.question.answers.true_answer.collect{|answer| "#{answer.id}"}
      if attempt_question.selected_answer.sort == list_true_answers_id.sort
        final_score += 1
      end
    end
    self.update_column(:score, final_score)
  end

  private

  def max_attempts
    return unless exam.max_number_of_times
    return unless Attempt.by_exam_id(exam_id).by_user_id(user_id).count >= exam.max_number_of_times
    errors.add :base, :is_max_attempts
  end

end
