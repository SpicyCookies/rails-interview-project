# frozen_string_literal: true

class Tenant < ApplicationRecord
  before_create :generate_api_key

  validates :name,
            presence: true
  validates :request_count,
            presence: true

  private

  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end
end
