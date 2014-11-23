require 'test_helper'

class TradingAccountInstrumentsControllerTest < ActionController::TestCase
  setup do
    @trading_account_instrument = trading_account_instruments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trading_account_instruments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trading_account_instrument" do
    assert_difference('TradingAccountInstrument.count') do
      post :create, trading_account_instrument: {  }
    end

    assert_redirected_to trading_account_instrument_path(assigns(:trading_account_instrument))
  end

  test "should show trading_account_instrument" do
    get :show, id: @trading_account_instrument
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @trading_account_instrument
    assert_response :success
  end

  test "should update trading_account_instrument" do
    patch :update, id: @trading_account_instrument, trading_account_instrument: {  }
    assert_redirected_to trading_account_instrument_path(assigns(:trading_account_instrument))
  end

  test "should destroy trading_account_instrument" do
    assert_difference('TradingAccountInstrument.count', -1) do
      delete :destroy, id: @trading_account_instrument
    end

    assert_redirected_to trading_account_instruments_path
  end
end
