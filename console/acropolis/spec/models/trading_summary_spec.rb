require "rails_helper"

RSpec.describe TradingSummary, type: :model do

  before(:example) do
  end

  context '#calculate_parameter' do

    before :example do
      trade1 = Trade.create
      allow(trade1).to receive(:traded_volume).and_return(10)
      allow(trade1).to receive(:open_volume).and_return(5)
      allow(trade1).to receive(:open_close).and_return(Acropolis::TradeOpenFlags.trade_open_flags.open)
      allow(trade1).to receive(:trading_account_id).and_return(1)

      trade2 = Trade.create
      allow(trade2).to receive(:traded_volume).and_return(6)
      allow(trade2).to receive(:open_volume).and_return(6)
      allow(trade2).to receive(:open_close).and_return(Acropolis::TradeOpenFlags.trade_open_flags.open)
      allow(trade2).to receive(:trading_account_id).and_return(1)

      @trade3 = Trade.create
      allow(@trade3).to receive(:traded_volume).and_return(10)
      allow(@trade3).to receive(:open_volume).and_return(0)
      allow(@trade3).to receive(:open_close).and_return(Acropolis::TradeOpenFlags.trade_open_flags.close)
      allow(@trade3).to receive(:trading_account_id).and_return(1)

      allow(trade1).to receive(:profit).and_return(1000)
      allow(trade2).to receive(:profit).and_return(-1200)
      allow(@trade3).to receive(:profit).and_return(100)

      allow(trade1).to receive(:margin).and_return(200)
      allow(trade2).to receive(:margin).and_return(100)
      allow(@trade3).to receive(:margin).and_return(0)

      allow(trade1).to receive(:trading_fee).and_return(20)
      allow(trade2).to receive(:trading_fee).and_return(12)
      allow(@trade3).to receive(:trading_fee).and_return(0)

      allow(trade1).to receive(:exposure).and_return(1000)
      allow(trade2).to receive(:exposure).and_return(-1200)
      allow(@trade3).to receive(:exposure).and_return(100)

      allow(trade1).to receive(:position_cost).and_return(1000)
      allow(trade2).to receive(:position_cost).and_return(-1200)
      allow(@trade3).to receive(:position_cost).and_return(100)

      allow(@trade3).to receive(:close_position)

      @trading_summary = TradingSummary.create
      allow(@trading_summary).to receive(:trading_account_id).and_return(1)
      allow(@trading_summary).to receive(:awaiting_trades).and_return([trade1, trade2, @trade3])
      allow(@trading_summary).to receive(:trading_date).and_return(Time.zone.now)

      @trading_summary.calculate_parameters
    end

    it 'move to last trade' do
      expect(@trading_summary.latest_trade.id).to eq(@trade3.id)
    end

    it 'margin' do
      expect(@trading_summary.margin).to eq(300)
    end

    it 'trading_fee' do
      expect(@trading_summary.trading_fee).to eq(32)
    end

    it 'exposure' do
      expect(@trading_summary.exposure).to eq(-100)
    end

    it 'profit' do
      expect(@trading_summary.profit).to eq(-100)
    end

    it 'position_cost' do
      expect(@trading_summary.position_cost).to eq(-100)
    end

  end

end