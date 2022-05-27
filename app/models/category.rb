class Category < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :exams, dependent: :destroy
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  scope :order_created_at, -> {order(created_at: :desc)}
end
