require 'test_helper'

class MonitoringProductsControllerTest < ActionController::TestCase
  setup do
    @monitoring_product = monitoring_products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:monitoring_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create monitoring_product" do
    assert_difference('MonitoringProduct.count') do
      post :create, monitoring_product: {  }
    end

    assert_redirected_to monitoring_product_path(assigns(:monitoring_product))
  end

  test "should show monitoring_product" do
    get :show, id: @monitoring_product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @monitoring_product
    assert_response :success
  end

  test "should update monitoring_product" do
    patch :update, id: @monitoring_product, monitoring_product: {  }
    assert_redirected_to monitoring_product_path(assigns(:monitoring_product))
  end

  test "should destroy monitoring_product" do
    assert_difference('MonitoringProduct.count', -1) do
      delete :destroy, id: @monitoring_product
    end

    assert_redirected_to monitoring_products_path
  end
end
