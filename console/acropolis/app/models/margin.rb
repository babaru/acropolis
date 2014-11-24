class Margin < ActiveRecord::Base
  belongs_to :instrument

  def value
    return 0 if self.factor.nil?
    self.factor
  end
end
