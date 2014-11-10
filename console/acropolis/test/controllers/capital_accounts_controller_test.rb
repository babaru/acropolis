require 'test_helper'

class CapitalAccountsControllerTest < ActionController::TestCase
  setup do
    @capital_account = capital_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:capital_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create capital_account" do
    assert_difference('CapitalAccount.count') do
      post :create, capital_account: {  }
    end

    assert_redirected_to capital_account_path(assigns(:capital_account))
  end

  test "should show capital_account" do
    get :show, id: @capital_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @capital_account
    assert_response :success
  end

  test "should update capital_account" do
    patch :update, id: @capital_account, capital_account: {  }
    assert_redirected_to capital_account_path(assigns(:capital_account))
  end

  test "should destroy capital_account" do
    assert_difference('CapitalAccount.count', -1) do
      delete :destroy, id: @capital_account
    end

    assert_redirected_to capital_accounts_path
  end
end
