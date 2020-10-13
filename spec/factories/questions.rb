# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { FFaker::HipsterIpsum.sentence.gsub(/\.$/, '?') }
    # BUG-1: The author of the main repository needs to
    #      not use 'private' as an attribute name, it's reserved.
    # rubocop:disable Layout/EmptyLinesAroundAccessModifier
    private { FFaker::Boolean.random }
    # rubocop:enable Layout/EmptyLinesAroundAccessModifier
  end
end
