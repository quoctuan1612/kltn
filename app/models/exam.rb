class Exam < ApplicationRecord
  belongs_to :category
  belongs_to :user, foreign_key: :user_id
  has_many :exam_questions, dependent: :destroy
  has_many :questions, through: :exam_questions
  has_many :attempts, dependent: :destroy

  accepts_nested_attributes_for :exam_questions, allow_destroy: true

  validates :title, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 30}
  validates :duration, presence: true, numericality: {greater_than: 0, only_integer: true},
    length: {maximum: 6}
  validates :result_pass, numericality: {greater_than: 0, only_integer: true},
    length: {maximum: 6}
  validates :result_pass, presence: true
  validates :category_id, presence: true
  validates :max_number_of_times, numericality: {greater_than: 0, only_integer: true},
    length: {maximum: 6}, allow_nil: true
  validate :none_question?
  validate :compare_result_vs_question
  validate :max_attempts, on: :update

  scope :order_created_at, -> {order(created_at: :desc)}
  scope :by_category_ids, -> (category_ids){where(category_id: category_ids) if category_ids.present?}
  scope :by_user_ids, -> (user_ids){where(user_id: user_ids) if user_ids.present?}

  delegate :name, to: :category, prefix: true

  Question.levels.keys.each do |level|
    define_method "#{level}_percent" do
      return "0%" if questions.send(level).count == 0
      ((questions.send(level).count.to_f/questions.count)*100).round(0).to_s + "%"
    end
  end

  Question.levels.keys.each do |level|
    define_method "#{level}_questions_count" do
      questions.send(level).count
    end
  end

  def any_perform?
    attempts.any?
  end

  private

  def none_question?
    return if exam_questions.size > 0
    errors.add :base, :none_question
  end

  def compare_result_vs_question
    return if exam_questions.reject(&:marked_for_destruction?).length >= result_pass.to_i
    errors.add :result_pass, :invalid_result_pass 
  end

  def max_attempts
    return if max_number_of_times.nil?
    max_time = attempts.group(:user_id).count.values.max
    return unless max_time
    return if max_time <= max_number_of_times
    errors.add :max_number_of_times, I18n.t("activerecord.errors.models.exam.attributes.max_number_of_times.have_user_do_much_time", max: max_time)
  end
end
