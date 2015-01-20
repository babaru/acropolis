require 'rails_helper'

RSpec.describe TradingAccount, :type => :model do

  context 'parameters' do

    it 'net worth has default value 1' do
      ta = TradingAccount.new
      expect(ta.net_worth).to eq(1)
    end

    it 'leverage has default value 0' do
      ta = TradingAccount.new
      expect(ta.leverage).to eq(0)
    end

  end

  context '#received_trade' do
    before :example do
      trade = Trade.new

      trading_summary1 = TradingSummary.new
      trading_summary2 = TradingSummary.new
      trading_summary3 = TradingSummary.new

      allow(trade).to receive(:exchange_id).and_return(1)
      allow(trade).to receive(:trading_account_id).and_return(1)
      allow(trade).to receive(:exchange_traded_at).and_return(Time.zone.now)

      allow(trading_summary1).to receive(:profit).and_return(1000)
      allow(trading_summary2).to receive(:profit).and_return(-1200)
      allow(trading_summary3).to receive(:profit).and_return(100)

      allow(trading_summary1).to receive(:margin).and_return(200)
      allow(trading_summary2).to receive(:margin).and_return(100)
      allow(trading_summary3).to receive(:margin).and_return(0)

      allow(trading_summary1).to receive(:trading_fee).and_return(20)
      allow(trading_summary2).to receive(:trading_fee).and_return(12)
      allow(trading_summary3).to receive(:trading_fee).and_return(0)

      allow(trading_summary1).to receive(:exposure).and_return(1000)
      allow(trading_summary2).to receive(:exposure).and_return(-1300)
      allow(trading_summary3).to receive(:exposure).and_return(100)

      allow(trading_summary1).to receive(:position_cost).and_return(1000)
      allow(trading_summary2).to receive(:position_cost).and_return(-1200)
      allow(trading_summary3).to receive(:position_cost).and_return(400)

      @trading_account = TradingAccount.new
      allow(@trading_account).to receive(:id).and_return(1)
      allow(@trading_account).to receive(:get_trading_summaries_by_date).and_return(
        [trading_summary1, trading_summary2, trading_summary3])

      @trading_account.capital = 10000

      @trading_account.received_trade(trade)

      @trading_account2 = TradingAccount.new
      allow(@trading_account2).to receive(:id).and_return(2)
      allow(@trading_account2).to receive(:get_trading_summaries_by_date).and_return(
        [trading_summary1, trading_summary2, trading_summary3])

      @trading_account2.capital = 0

      @trading_account2.received_trade(trade)
    end

    it 'profit' do
      expect(@trading_account.profit).to eq(-100)
    end

    it 'margin' do
      expect(@trading_account.margin).to eq(300)
    end

    it 'trading_fee' do
      expect(@trading_account.trading_fee).to eq(32)
    end

    it 'exposure' do
      expect(@trading_account.exposure).to eq(-200)
    end

    it 'position_cost' do
      expect(@trading_account.position_cost).to eq(200)
    end

    it 'customer_benefit' do
      expect(@trading_account.customer_benefit).to eq(9868)
    end

    it 'balance' do
      expect(@trading_account.balance).to eq(9568)
    end

    it 'net_worth' do
      expect(@trading_account.net_worth).to eq(0.9868)
    end

    it 'leverage' do
      expect(@trading_account.leverage).to eq(0.02)
    end

    it 'net_worth when capital is zero' do
      expect(@trading_account2.net_worth).to eq(1)
    end

    it 'leverage when capital is zero' do
      expect(@trading_account2.leverage).to eq(0)
    end
  end

end