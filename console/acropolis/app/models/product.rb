class Product < ActiveRecord::Base
  belongs_to :client
  belongs_to :broker
  belongs_to :bank
  has_many :product_risk_plans, dependent: :destroy
  has_many :risk_plans, through: :product_risk_plans
  has_many :product_risk_parameters
  has_many :monitoring_products, dependent: :destroy
  has_many :trading_accounts, dependent: :destroy

  def long_name
    "#{bank.name}-#{broker.name}-#{client.name}-#{name}"
  end

  def is_monitored_by?(user)
    !monitoring_products.where(user_id: user.id).first.nil?
  end

  def allocated_budget
    trading_accounts.inject(0) {|sum, item| sum += item.budget if item.budget }
  end

  def fixed_budget
    budget - allocated_budget
  end

  def balance
    fixed_budget + self.trading_accounts.inject(0) {|sum, account| sum += account.balance }
  end

  def customer_benefit
    fixed_budget + self.trading_accounts.inject(0) {|sum, account| sum += account.customer_benefit }
  end

  def net_worth
    return 0 if budget.nil? || budget == 0 || customer_benefit.nil? || customer_benefit == 0
    customer_benefit / budget
  end

  def net_worth_style
    "label label-warning"
  end
end
