# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions, inverse_of: :asker, dependent: :destroy
  has_many :answers,   inverse_of: :answerer, dependent: :destroy
end
