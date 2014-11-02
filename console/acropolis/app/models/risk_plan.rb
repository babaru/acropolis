class RiskPlan < ActiveRecord::Base
  has_many :parameter_thresholds, dependent: :destroy
  has_many :net_worth_thresholds, dependent: :destroy
  has_many :thresholds, dependent: :destroy
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :product_risk_plans, dependent: :destroy
  has_many :prducts, through: :product_risk_plans

  # validates :parameter_id, :presence => true

  attr_accessor :net_worth_threshold_ids,
    :net_worth_threshold_relation_symbols,
    :net_worth_threshold_values,
    :net_worth_threshold_parameters,
    :net_worth_threshold_removal_flags

  def net_worth_threshold_value
    net_worth_thresholds.inject([]) { |list, item| list << [item.parameter.i18n_name, item.relation_symbol.math, item.value].join(' ')}.join(' | ')
  end
end
