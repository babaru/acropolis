require 'test_helper'

class RiskPlansControllerTest < ActionController::TestCase
  setup do
    @risk_plan = risk_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:risk_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create risk_plan" do
    assert_difference('RiskPlan.count') do
      post :create, risk_plan: {  }
    end

    assert_redirected_to risk_plan_path(assigns(:risk_plan))
  end

  test "should show risk_plan" do
    get :show, id: @risk_plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @risk_plan
    assert_response :success
  end

  test "should update risk_plan" do
    patch :update, id: @risk_plan, risk_plan: {  }
    assert_redirected_to risk_plan_path(assigns(:risk_plan))
  end

  test "should destroy risk_plan" do
    assert_difference('RiskPlan.count', -1) do
      delete :destroy, id: @risk_plan
    end

    assert_redirected_to risk_plans_path
  end
end
