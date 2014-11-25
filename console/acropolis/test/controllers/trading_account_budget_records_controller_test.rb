require 'test_helper'

class TradingAccountBudgetRecordsControllerTest < ActionController::TestCase
  setup do
    @trading_account_budget_record = trading_account_budget_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trading_account_budget_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trading_account_budget_record" do
    assert_difference('TradingAccountBudgetRecord.count') do
      post :create, trading_account_budget_record: {  }
    end

    assert_redirected_to trading_account_budget_record_path(assigns(:trading_account_budget_record))
  end

  test "should show trading_account_budget_record" do
    get :show, id: @trading_account_budget_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @trading_account_budget_record
    assert_response :success
  end

  test "should update trading_account_budget_record" do
    patch :update, id: @trading_account_budget_record, trading_account_budget_record: {  }
    assert_redirected_to trading_account_budget_record_path(assigns(:trading_account_budget_record))
  end

  test "should destroy trading_account_budget_record" do
    assert_difference('TradingAccountBudgetRecord.count', -1) do
      delete :destroy, id: @trading_account_budget_record
    end

    assert_redirected_to trading_account_budget_records_path
  end
end
