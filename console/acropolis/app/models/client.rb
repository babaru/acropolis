class Client < ActiveRecord::Base
  has_many :products
  has_many :capital_accounts
end
