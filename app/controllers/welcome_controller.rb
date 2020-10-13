# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @total_users = User.count
    @total_questions = Question.count
    @total_answers = Answer.count
    @total_tenants = Tenant.count
    @tenants = Tenant.all
  end
end
