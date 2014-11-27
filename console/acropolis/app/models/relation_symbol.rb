class RelationSymbol < ActiveRecord::Base
  def is_matched?(standard, val)
    if name.to_sym == :less_than
      return val < standard
    elsif name.to_sym == :less_than_and_equals_to
      return val <= standard
    elsif name.to_sym == :equals_to
      return val == standard
    elsif name.to_sym == :greater_than_and_equals_to
      return val >= standard
    elsif name.to_sym == :greater_than
      return val > standard
    end

    return false

  end
end
