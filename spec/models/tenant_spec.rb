# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tenant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :request_count }
  end
end
