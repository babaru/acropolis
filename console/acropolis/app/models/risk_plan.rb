class RiskPlan < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :product_risk_plans, dependent: :delete_all
  has_many :products, through: :product_risk_plans
  has_many :risk_plan_operations, dependent: :destroy
  has_many :trading_accoun_risk_plans, dependent: :delete_all
  has_many :trading_accounts, through: :trading_account_risk_plans

  def threshold_string
    risk_plan_operations.inject([]) do |list, item|
      list << "( #{item.threshold_string} )"
    end.join(' | ')
  end

  def matched_operation(product)
    operation = nil
    risk_plan_operations.each do |item|
      if item.is_matched?(product) && item.is_enabled?
        new_operation = item.operation
        if operation.nil?
          operation = new_operation
        else
          if item.operation.level > operation.level
            operation = new_operation
          end
        end
      end
    end
    operation
  end
end
