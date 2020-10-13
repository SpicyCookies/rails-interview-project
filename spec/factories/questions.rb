# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { FFaker::HipsterIpsum.sentence.gsub(/\.$/, '?') }
    private { FFaker::Boolean.random }
  end
end
