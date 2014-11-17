class Product < ActiveRecord::Base
  belongs_to :client
  belongs_to :broker
  belongs_to :bank
  has_many :product_risk_plans, dependent: :destroy
  has_many :risk_plans, through: :product_risk_plans
  has_many :product_risk_parameters
  has_many :monitoring_products
  has_many :trading_accounts

  def long_name
    "#{bank.name}-#{broker.name}-#{client.name}-#{name}"
  end

  def is_monitored_by?(user)
    !monitoring_products.where(user_id: user.id).first.nil?
  end

  def allocated_budget
    trading_accounts.inject(0) {|sum, item| sum += item.budget }
  end
end
