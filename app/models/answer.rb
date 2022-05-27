class Answer < ApplicationRecord
  belongs_to :question

  validates :content, presence: true

  scope :true_answer, -> {where is_true: true}
end
