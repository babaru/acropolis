class Parameter < ActiveRecord::Base
  def i18n_name
    I18n.t("activerecord.attributes.parameter.name.#{self.name}")
  end
end
