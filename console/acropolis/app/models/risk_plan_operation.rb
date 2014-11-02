class RiskPlanOperation < ActiveRecord::Base
  belongs_to :risk_plan
  belongs_to :operation
  has_many :thresholds, dependent: :delete_all

  attr_accessor :threshold_ids,
    :threshold_relation_symbols,
    :threshold_values,
    :threshold_parameters,
    :threshold_removal_flags

  def threshold_value
    thresholds.inject([]) { |list, item| list << [item.parameter.i18n_name, item.relation_symbol.math, item.value].join(' ')}.join(' | ')
  end
end
