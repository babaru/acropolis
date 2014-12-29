require 'rails_helper'

RSpec.describe Trade, type: :model do

  context 'margin' do

    let(:trade) { Trade.new }

    it 'when exchange margin is greater than 0' do
      trade.exchange_margin = 5
      trade.system_calculated_margin = 10
      expect(trade.margin).to eq(5)
    end

    it 'when exchange margin is 0' do
      trade.system_calculated_margin = 10
      expect(trade.margin).to eq(10)
    end

  end

  context 'position cost' do

    let(:trade) { Trade.new }

    it 'when it is close trade' do
      trade.traded_price = 1000.0
      trade.open_close = Acropolis::TradeOpenFlags.trade_open_flags.close

      expect(trade.position_cost).to eq(0)
    end

    it 'when it is close trade' do
      trade.traded_price = 1000.0
      trade.open_close = Acropolis::TradeOpenFlags.trade_open_flags.close

      expect(trade.position_cost).to eq(0)
    end

    it 'when it is open trade' do
      trade.traded_price = 1000.0
      trade.open_close = Acropolis::TradeOpenFlags.trade_open_flags.open
      trade.traded_volume = 10
      trade.open_volume = 5

      allow(trade).to receive(:instrument_multiplier).and_return(300)
      allow(trade).to receive(:instrument_currency_exchange_rate).and_return(1)

      expect(trade.position_cost).to eq(1500000)
    end

  end

  context 'market value' do

    let(:trade) { Trade.new }

    it 'calcuated on latest traded price' do
      trade.traded_price = 1000.0
      trade.open_close = Acropolis::TradeOpenFlags.trade_open_flags.open
      trade.traded_volume = 10
      trade.open_volume = 5
      allow(trade).to receive(:instrument_latest_price).and_return(1100)
      allow(trade).to receive(:instrument_multiplier).and_return(300)
      allow(trade).to receive(:instrument_currency_exchange_rate).and_return(1)
      expect(trade.market_value).to eq(1650000)
    end

  end

  context 'exposure' do

    let(:trade) { Trade.new }

    it 'when it is a close trade' do
      trade = Trade.new
      trade.traded_price = 1000.0
      trade.open_close = Acropolis::TradeOpenFlags.trade_open_flags.close
      trade.traded_volume = 10
      trade.order_side = Acropolis::OrderSides.order_sides.buy
      allow(trade).to receive(:instrument_latest_price).and_return(1100)
      allow(trade).to receive(:instrument_multiplier).and_return(300)
      allow(trade).to receive(:instrument_currency_exchange_rate).and_return(1)
      expect(trade.exposure).to eq(0)
    end

    it 'when it is an open long trade' do
      trade = Trade.new
      trade.traded_price = 1000.0
      trade.open_close = Acropolis::TradeOpenFlags.trade_open_flags.open
      trade.traded_volume = 10
      trade.open_volume = 5
      trade.order_side = Acropolis::OrderSides.order_sides.buy
      allow(trade).to receive(:instrument_latest_price).and_return(1100)
      allow(trade).to receive(:instrument_multiplier).and_return(300)
      allow(trade).to receive(:instrument_currency_exchange_rate).and_return(1)
      expect(trade.exposure).to eq(1650000)
    end

    it 'when it is an open short trade' do
      trade = Trade.new
      trade.traded_price = 900.0
      trade.open_close = Acropolis::TradeOpenFlags.trade_open_flags.open
      trade.traded_volume = 10
      trade.open_volume = 5
      trade.order_side = Acropolis::OrderSides.order_sides.sell
      allow(trade).to receive(:instrument_latest_price).and_return(1000)
      allow(trade).to receive(:instrument_multiplier).and_return(300)
      allow(trade).to receive(:instrument_currency_exchange_rate).and_return(1)
      expect(trade.exposure).to eq(1500000)
    end

  end

  context 'profit' do

    before :example do
      @trade = Trade.new
      @trade.traded_price = 1000.0
      allow(@trade).to receive(:instrument_multiplier).and_return(300)
      allow(@trade).to receive(:instrument_currency_exchange_rate).and_return(1)
    end

    context 'open' do

      before :example do
        @trade.open_close = Acropolis::TradeOpenFlags.trade_open_flags.open
        @trade.traded_volume = 10
        @trade.open_volume = 5
      end

      context 'long trade' do

        before :example do
          @trade.order_side = Acropolis::OrderSides.order_sides.buy
        end

        it 'has profit' do
          allow(@trade).to receive(:instrument_latest_price).and_return(1100)
          expect(@trade.profit).to eq(150000)
        end

        it 'when get lost' do
          allow(@trade).to receive(:instrument_latest_price).and_return(900)
          expect(@trade.profit).to eq(-150000)
        end

      end

      context 'short trade' do

        before :example do
          @trade.order_side = Acropolis::OrderSides.order_sides.sell
        end

        it 'when has profit' do
          allow(@trade).to receive(:instrument_latest_price).and_return(900)
          expect(@trade.profit).to eq(150000)
        end

        it 'when open short trade has loss' do
          allow(@trade).to receive(:instrument_latest_price).and_return(1100)
          expect(@trade.profit).to eq(-150000)
        end

      end

    end

    context 'close' do

      before :example do
        @trade.open_close = Acropolis::TradeOpenFlags.trade_open_flags.close
        @trade.traded_volume = 10

        @open_trade1 = Trade.new
        @open_trade1.traded_price = 860.0
        @position_close_record1 = PositionCloseRecord.new
        @position_close_record1.open_trade = @open_trade1
        @position_close_record1.close_volume = 2

        @open_trade2 = Trade.new
        @open_trade2.traded_price = 830.0
        @position_close_record2 = PositionCloseRecord.new
        @position_close_record2.open_trade = @open_trade2
        @position_close_record2.close_volume = 3

        @open_trade3 = Trade.new
        @open_trade3.traded_price = 1140.0
        @position_close_record3 = PositionCloseRecord.new
        @position_close_record3.open_trade = @open_trade3
        @position_close_record3.close_volume = 5
        allow(@trade).to receive(:open_trade_records).and_return([@position_close_record1, @position_close_record2, @position_close_record3])

        allow(@open_trade1).to receive(:instrument_multiplier).and_return(300)
        allow(@open_trade1).to receive(:instrument_currency_exchange_rate).and_return(1)

        allow(@open_trade2).to receive(:instrument_multiplier).and_return(300)
        allow(@open_trade2).to receive(:instrument_currency_exchange_rate).and_return(1)

        allow(@open_trade3).to receive(:instrument_multiplier).and_return(300)
        allow(@open_trade3).to receive(:instrument_currency_exchange_rate).and_return(1)
      end

      it 'when long trade' do
        @trade.order_side = Acropolis::OrderSides.order_sides.buy
        expect(@trade.profit).to eq(-27000)
      end

      it 'when short trade' do
        @trade.order_side = Acropolis::OrderSides.order_sides.sell
        expect(@trade.profit).to eq(27000)
      end

    end

  end

  context '#close_position' do

    it 'when open trade' do
      trade = Trade.new
      trade.open_close = Acropolis::TradeOpenFlags.trade_open_flags.open
      trade.close_position
    end

    it 'when close trade' do
      trade1 = Trade.create(traded_volume: 10, open_volume: 5, open_close: Acropolis::TradeOpenFlags.trade_open_flags.open, trading_account_id: 1)
      trade2 = Trade.create(traded_volume: 6, open_volume: 6, open_close: Acropolis::TradeOpenFlags.trade_open_flags.open, trading_account_id: 1)
      trade3 = Trade.create(traded_volume: 10, open_volume: 0, open_close: Acropolis::TradeOpenFlags.trade_open_flags.close, trading_account_id: 1)

      allow(trade3).to receive(:available_open_trades).and_return([trade1, trade2])

      trade3.close_position
      expect(trade1.open_volume).to eq(0)
      expect(trade2.open_volume).to eq(1)

      close_record1 = PositionCloseRecord.find_by_open_trade_id(trade1.id)
      close_record2 = PositionCloseRecord.find_by_open_trade_id(trade2.id)

      expect(close_record1.close_trade_id).to eq(trade3.id)
      expect(close_record1.close_volume).to eq(5)

      expect(close_record2.close_trade_id).to eq(trade3.id)
      expect(close_record2.close_volume).to eq(5)
    end

  end

  context '#calculate_close_volume' do

    it 'when rest volume is greater than open volume' do
      open_trade = Trade.new
      open_trade.traded_volume = 10
      open_trade.open_volume = 3

      rest_volume = 5
      trade = Trade.new
      result = trade.calculate_close_volume(open_trade, rest_volume)
      expect(result).to eq([3, 2])
      expect(open_trade.open_volume).to eq(0)
    end

    it 'when rest volume is less than open volume' do
      open_trade = Trade.new
      open_trade.traded_volume = 10
      open_trade.open_volume = 10

      rest_volume = 5
      trade = Trade.new
      result = trade.calculate_close_volume(open_trade, rest_volume)
      expect(result).to eq([5, 0])
      expect(open_trade.open_volume).to eq(5)
    end

  end

  context '#reset_position' do

    it 'reset all open volume' do
      trade1 = Trade.create(traded_volume: 10, open_volume: 5, open_close: Acropolis::TradeOpenFlags.trade_open_flags.open, trading_account_id: 1)
      trade2 = Trade.create(traded_volume: 6, open_volume: 6, open_close: Acropolis::TradeOpenFlags.trade_open_flags.open, trading_account_id: 1)
      trade3 = Trade.create(traded_volume: 10, open_volume: 0, open_close: Acropolis::TradeOpenFlags.trade_open_flags.close, trading_account_id: 1)

      allow(trade3).to receive(:available_open_trades).and_return([trade1, trade2])

      trade3.close_position

      Trade.reset_position(TradingAccount.new(id: 1))

      expect(PositionCloseRecord.count(close_trade_id: trade3.id)).to eq(0)

      expect(Trade.find(trade1.id).open_volume).to eq(trade1.traded_volume)
      expect(Trade.find(trade2.id).open_volume).to eq(trade2.traded_volume)
    end

  end

end