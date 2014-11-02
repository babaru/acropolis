require 'test_helper'

class RiskPlanOperationsControllerTest < ActionController::TestCase
  setup do
    @risk_plan_operation = risk_plan_operations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:risk_plan_operations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create risk_plan_operation" do
    assert_difference('RiskPlanOperation.count') do
      post :create, risk_plan_operation: {  }
    end

    assert_redirected_to risk_plan_operation_path(assigns(:risk_plan_operation))
  end

  test "should show risk_plan_operation" do
    get :show, id: @risk_plan_operation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @risk_plan_operation
    assert_response :success
  end

  test "should update risk_plan_operation" do
    patch :update, id: @risk_plan_operation, risk_plan_operation: {  }
    assert_redirected_to risk_plan_operation_path(assigns(:risk_plan_operation))
  end

  test "should destroy risk_plan_operation" do
    assert_difference('RiskPlanOperation.count', -1) do
      delete :destroy, id: @risk_plan_operation
    end

    assert_redirected_to risk_plan_operations_path
  end
end
