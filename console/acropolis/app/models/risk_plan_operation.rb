class RiskPlanOperation < ActiveRecord::Base
  belongs_to :risk_plan
  belongs_to :operation
  has_many :thresholds, dependent: :delete_all

  attr_accessor :threshold_ids,
    :threshold_relation_symbols,
    :threshold_values,
    :threshold_parameters,
    :threshold_removal_flags

  def threshold_string
    thresholds.inject([]) { |list, item| list << [item.parameter.human, item.relation_symbol.math, item.value].join(' ')}.join(' & ')
  end

  def human
    I18n.t("activerecord.attributes.operation.#{self.operation.name}")
  end

  def is_matched?(product)
    return false if thresholds.count == 0
    thresholds.each do |threshold|
      return false unless threshold.is_matched?(product)
    end
    true
  end

end
