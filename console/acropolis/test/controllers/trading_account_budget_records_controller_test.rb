require 'test_helper'

class TradingAccountBudgetRecordsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @record = trading_account_budget_records(:one)

    sign_in :user, users(:one)
  end

  test "should get index" do
    get :index, trading_account_id: @record.trading_account_id
    assert_response :success
    assert_not_nil assigns(:trading_account_budget_records_grid)
  end

  test "should get new" do
    get :new, trading_account_id: @record.trading_account_id
    assert_response :success
  end

  test "should create trading_account_budget_record" do
    assert_difference('TradingAccountBudgetRecord.count') do
      post :create, trading_account_budget_record: {
                  trading_account_id: @record.id,
                  budget_type: @record.budget_type,
                  money: @record.money}
    end

    assert_redirected_to trading_account_budget_record_path(assigns(:trading_account_budget_record))
  end

  test "should show trading_account_budget_record" do
    get :show, id: @record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @record
    assert_response :success
  end

  test "should update trading_account_budget_record" do
    patch :update, id: @record, trading_account_budget_record: { money: 9.3 }
    assert_redirected_to trading_account_budget_record_path(assigns(:trading_account_budget_record))
  end

  test "should destroy trading_account_budget_record" do
    assert_difference('TradingAccountBudgetRecord.count', -1) do
      delete :destroy, id: @record
    end

    assert_redirected_to trading_account_budget_records_path
  end
end
