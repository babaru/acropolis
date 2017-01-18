class ProductsGrid
  include Datagrid

  scope do
    Product.order('products.updated_at desc')
  end

  column(:name)
end
