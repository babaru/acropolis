class ProductsGrid
  include Datagrid

  scope do
    Product.order('products.updated_at desc')
  end

  column(:name,
    header: I18n.t('activerecord.attributes.product.name'))
end
