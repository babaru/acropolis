class RiskPlan < ActiveRecord::Base
  belongs_to :parameter
  belongs_to :operation
  belongs_to :user
  belongs_to :product
  has_many :parameter_thresholds, dependent: :destroy
  has_many :net_worth_thresholds, dependent: :destroy

  # validates :parameter_id, :presence => true

  attr_accessor :threshold_ids, :threshold_relation_symbols, :threshold_values

  def threshold_value
    thresholds.inject([]) { |list, item| list << [item.relation_symbol.math, item.value].join(' ')}.join(' | ')
  end
end
