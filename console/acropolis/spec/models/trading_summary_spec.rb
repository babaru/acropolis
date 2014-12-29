require "rails_helper"

RSpec.describe TradingSummary, type: :model do

  before(:example) do
  end

  context '#calculate_trading_summary' do

    before :example do
      @trade1 = Trade.create(traded_volume: 10, open_volume: 5, open_close: Acropolis::TradeOpenFlags.trade_open_flags.open, trading_account_id: 1)
      @trade2 = Trade.create(traded_volume: 6, open_volume: 6, open_close: Acropolis::TradeOpenFlags.trade_open_flags.open, trading_account_id: 1)
      @trade3 = Trade.create(traded_volume: 10, open_volume: 0, open_close: Acropolis::TradeOpenFlags.trade_open_flags.close, trading_account_id: 1)

      allow(@trade1).to receive(:profit).and_return(1000)
      allow(@trade2).to receive(:profit).and_return(-1200)
      allow(@trade3).to receive(:profit).and_return(100)

      allow(@trade1).to receive(:margin).and_return(200)
      allow(@trade2).to receive(:margin).and_return(100)
      allow(@trade3).to receive(:margin).and_return(0)

      allow(@trade1).to receive(:trading_fee).and_return(20)
      allow(@trade2).to receive(:trading_fee).and_return(12)
      allow(@trade3).to receive(:trading_fee).and_return(0)

      allow(@trade1).to receive(:exposure).and_return(1000)
      allow(@trade2).to receive(:exposure).and_return(-1200)
      allow(@trade3).to receive(:exposure).and_return(100)

      allow(@trade3).to receive(:close_position)
    end

    it 'move to last trade' do
      trading_summary = TradingSummary.new(trading_account_id: 1)
      allow(trading_summary).to receive(:unhandled_trades).and_return([@trade1, @trade2, @trade3])
      trading_summary.calculate

      expect(trading_summary.latest_trade.id).to eq(@trade3.id)
    end

    it 'calculate margin' do
      trading_summary = TradingSummary.new(trading_account_id: 1)
      allow(trading_summary).to receive(:unhandled_trades).and_return([@trade1, @trade2, @trade3])
      trading_summary.calculate

      expect(trading_summary.margin).to eq(300)
    end

    it 'calculate trading_fee' do
      trading_summary = TradingSummary.new(trading_account_id: 1)
      allow(trading_summary).to receive(:unhandled_trades).and_return([@trade1, @trade2, @trade3])
      trading_summary.calculate

      expect(trading_summary.trading_fee).to eq(32)
    end

    it 'calculate exposure' do
      trading_summary = TradingSummary.new(trading_account_id: 1)
      allow(trading_summary).to receive(:unhandled_trades).and_return([@trade1, @trade2, @trade3])
      trading_summary.calculate

      expect(trading_summary.exposure).to eq(-100)
    end

    it 'calculate profit' do
      trading_summary = TradingSummary.new(trading_account_id: 1)
      allow(trading_summary).to receive(:unhandled_trades).and_return([@trade1, @trade2, @trade3])
      trading_summary.calculate

      expect(trading_summary.profit).to eq(-100)
    end

  end

end