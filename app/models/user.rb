class User < ApplicationRecord

  has_many :questions, inverse_of: :asker
  has_many :answers,   inverse_of: :answerer

end
