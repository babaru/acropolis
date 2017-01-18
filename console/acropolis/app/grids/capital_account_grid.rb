class CapitalAccountGrid
  include Datagrid

  scope do
    CapitalAccount.order('updated_at desc')
  end

  column(:name, header: I18n.t('activerecord.attributes.capital_account.name')) do |asset|
    format(asset.name) do |value|
      link_to value, capital_account_path(asset)
    end
  end
end
