require 'test_helper'

class ProductCapitalAccountsControllerTest < ActionController::TestCase
  setup do
    @product_capital_account = product_capital_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_capital_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_capital_account" do
    assert_difference('ProductCapitalAccount.count') do
      post :create, product_capital_account: {  }
    end

    assert_redirected_to product_capital_account_path(assigns(:product_capital_account))
  end

  test "should show product_capital_account" do
    get :show, id: @product_capital_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_capital_account
    assert_response :success
  end

  test "should update product_capital_account" do
    patch :update, id: @product_capital_account, product_capital_account: {  }
    assert_redirected_to product_capital_account_path(assigns(:product_capital_account))
  end

  test "should destroy product_capital_account" do
    assert_difference('ProductCapitalAccount.count', -1) do
      delete :destroy, id: @product_capital_account
    end

    assert_redirected_to product_capital_accounts_path
  end
end
