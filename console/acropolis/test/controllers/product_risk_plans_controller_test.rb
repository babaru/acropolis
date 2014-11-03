require 'test_helper'

class ProductRiskPlansControllerTest < ActionController::TestCase
  setup do
    @product_risk_plan = product_risk_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_risk_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_risk_plan" do
    assert_difference('ProductRiskPlan.count') do
      post :create, product_risk_plan: {  }
    end

    assert_redirected_to product_risk_plan_path(assigns(:product_risk_plan))
  end

  test "should show product_risk_plan" do
    get :show, id: @product_risk_plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_risk_plan
    assert_response :success
  end

  test "should update product_risk_plan" do
    patch :update, id: @product_risk_plan, product_risk_plan: {  }
    assert_redirected_to product_risk_plan_path(assigns(:product_risk_plan))
  end

  test "should destroy product_risk_plan" do
    assert_difference('ProductRiskPlan.count', -1) do
      delete :destroy, id: @product_risk_plan
    end

    assert_redirected_to product_risk_plans_path
  end
end
