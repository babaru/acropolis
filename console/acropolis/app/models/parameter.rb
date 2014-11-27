class Parameter < ActiveRecord::Base
  def human
    I18n.t("activerecord.attributes.parameter.#{self.name}")
  end
end
