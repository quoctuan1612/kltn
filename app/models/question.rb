class Question < ApplicationRecord
  belongs_to :category
  belongs_to :user, foreign_key: :user_id
  has_many :answers, dependent: :destroy
  has_many :exam_questions, dependent: :destroy
  has_many :exams, through: :exam_questions
  has_many :attempt_questions, dependent: :destroy
  has_many :attempts, through: :attempt_questions
  
  accepts_nested_attributes_for :answers, allow_destroy: true
  delegate :name, to: :category, prefix: true

  enum question_type: { single_choice: 0, multi_choice: 1 }
  enum level: { easy: 1, medium: 2, hard: 3 }

  validates :question_type, presence: true
  validates :content, presence: true
  validates :level, presence: true, inclusion: { in: Question.levels.keys,
    message: "%{value} không hợp lệ" }
  validate :none_answer?
  validate :none_true_answers
  validate :none_content_answers

  scope :order_created_at, -> {order(created_at: :desc)}
  scope :by_not_ids, -> (ids){where.not(id: ids)}
  scope :by_category_ids, -> (category_ids){where(category_id: category_ids) if category_ids.present?}
  scope :by_user_ids, -> (user_ids){where(user_id: user_ids) if user_ids.present?}
  scope :by_levels, -> (levels){where(level: levels) if levels.present?}
  scope :by_type, -> (type){where question_type: type if type.present?}
  
  def question_type_i18n
    single_choice? ? "Một đáp án" : "Nhiều đáp án" 
  end

  def level_label
    case level
    when "easy"
      "primary"
    when "medium"
      "warning"
    when "hard"
      "danger"
    end
  end

  def level_i18n
    case level
    when "easy"
      "Dễ"
    when "medium"
      "Trung bình"
    when "hard"
      "Khó"
    end
  end

  def question_type_label
    single_choice? ? "success" : "primary" 
  end

  private
  
  def none_true_answers
    return if answers.size < 1
    return if answers.any?{|answer| answer.is_true == true && answer.marked_for_destruction? == false}
    errors.add :base, :none_true_answers
  end

  def none_answer?
    return if answers.select{|x| x.valid?}.any?
    errors.add :base, :none_answer
  end

  def none_content_answers
    if answers.select{|x| x.invalid?}.any?
      errors.add :base, :invalid_answer
    end
  end
end
