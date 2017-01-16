require File.expand_path('../../customer_benefit_calculator', __FILE__)

describe 'CustomerBenefitCalculator', '#calculate' do
  it 'return initial value at the beginning' do
    initial = 1000000
    calc = Acropolis::Calculators::CustomerBenefitCalculator.new
    expect(calc.calculate({
        initial_capital: initial, trading_fee: 0, open_trades: [], close_trades: []
      })).to eq(initial)
  end

  it 'equals initial value minus trading fee if market price no change' do
    initial = 1000000

    calc = Acropolis::Calculators::CustomerBenefitCalculator.new

    expect(calc.calculate({
      initial_capital: initial,
      trading_fee: 16,
      open_trades: [{side: :buy, price: 3000, market_price: 3000, lot_size: 2, symbol: 'SYM_1'}],
      close_trades: []
      })).to eq(initial - 16)
  end

  it 'equals initial value minus trading fee and total open trade profit if no close trades' do
    initial = 1000000
    calc = Acropolis::Calculators::CustomerBenefitCalculator.new
    expect(calc.calculate({
      initial_capital: initial,
      trading_fee: 16,
      open_trades: [{side: :buy, price: 3000, market_price: 3100, lot_size: 2, symbol: 'SYM_1'}],
      close_trades: []
    })).to eq(initial - 16 + 200)
  end

  it 'equals initial value minus trading fee, total open trade profit and close trades profit' do

    initial = 1000000

    calc = Acropolis::Calculators::CustomerBenefitCalculator.new

    expect(calc.calculate({
      initial_capital: initial,

      trading_fee: 24,

      open_trades: [
        {side: :buy, price: 3000, market_price: 3100, lot_size: 1, symbol: 'SYM_1'}
      ],

      close_trades: [
        {side: :sell, bought_at: 3000, sold_at: 2700, lot_size: 1, symbol: 'SYM_1'}
      ]
    })).to eq(initial - 16 + 100 - 300 - 8)

  end

  it 'equals initial value minus trading fee, total open trade profit and close trades profit when sold open at first' do
    initial = 1000000

    calc = Acropolis::Calculators::CustomerBenefitCalculator.new

    expect(calc.calculate({
      initial_capital: initial,

      trading_fee: 24,

      open_trades: [
        {side: :sell, price: 3000, market_price: 3100, lot_size: 1, symbol: 'SYM_1'}
      ],

      close_trades: [
        {side: :buy, bought_at: 3000, sold_at: 2700, lot_size: 1, symbol: 'SYM_1'}
      ]
    })).to eq(initial - 24 - 100 - 300)
  end
end