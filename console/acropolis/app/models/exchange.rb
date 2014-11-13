class Exchange < ActiveRecord::Base
  has_many :instruments

  def is_derivatives_exchange?
    false
  end
end
