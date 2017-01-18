class ProductGrid
  include Datagrid

  scope do
    Product.order('products.updated_at desc')
  end

  column(:name, header: I18n.t('activerecord.attributes.product.name')) do |asset|
    format(asset.name) do |value|
      link_to value, product_path(asset)
    end
  end
end
