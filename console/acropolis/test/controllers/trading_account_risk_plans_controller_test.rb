require 'test_helper'

class TradingAccountRiskPlansControllerTest < ActionController::TestCase
  setup do
    @trading_account_risk_plan = trading_account_risk_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trading_account_risk_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trading_account_risk_plan" do
    assert_difference('TradingAccountRiskPlan.count') do
      post :create, trading_account_risk_plan: {  }
    end

    assert_redirected_to trading_account_risk_plan_path(assigns(:trading_account_risk_plan))
  end

  test "should show trading_account_risk_plan" do
    get :show, id: @trading_account_risk_plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @trading_account_risk_plan
    assert_response :success
  end

  test "should update trading_account_risk_plan" do
    patch :update, id: @trading_account_risk_plan, trading_account_risk_plan: {  }
    assert_redirected_to trading_account_risk_plan_path(assigns(:trading_account_risk_plan))
  end

  test "should destroy trading_account_risk_plan" do
    assert_difference('TradingAccountRiskPlan.count', -1) do
      delete :destroy, id: @trading_account_risk_plan
    end

    assert_redirected_to trading_account_risk_plans_path
  end
end
