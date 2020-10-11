# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { FFaker::HipsterIpsum.sentence }
  end
end
