# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  # Searches for a question title that contains the partial title string
  scope :search, lambda { |title|
    where("title LIKE ?", "%#{title}%")
  }
end
