class Operation < ActiveRecord::Base
  def human
    I18n.t("activerecord.attributes.operation.#{self.name}")
  end
end
