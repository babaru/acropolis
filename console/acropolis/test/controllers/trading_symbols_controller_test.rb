require 'test_helper'

class TradingSymbolsControllerTest < ActionController::TestCase
  setup do
    @trading_symbol = trading_symbols(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trading_symbols)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trading_symbol" do
    assert_difference('TradingSymbol.count') do
      post :create, trading_symbol: {  }
    end

    assert_redirected_to trading_symbol_path(assigns(:trading_symbol))
  end

  test "should show trading_symbol" do
    get :show, id: @trading_symbol
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @trading_symbol
    assert_response :success
  end

  test "should update trading_symbol" do
    patch :update, id: @trading_symbol, trading_symbol: {  }
    assert_redirected_to trading_symbol_path(assigns(:trading_symbol))
  end

  test "should destroy trading_symbol" do
    assert_difference('TradingSymbol.count', -1) do
      delete :destroy, id: @trading_symbol
    end

    assert_redirected_to trading_symbols_path
  end
end
