class TradingAccountClearingTradesFile < UploadFile
  validates_attachment_file_name :data_file, :matches => [/dbf\Z/i]

  def cleared_at
    meta_data[:cleared_at]
  end

  def cleared_at=(val)
    meta_data[:cleared_at] = val
  end

  def trading_account_id
    meta_data[:trading_account_id]
  end

  def trading_account_id=(val)
    meta_data[:trading_account_id] = val
  end

  def parse
    widgets = DBF::Table.new(data_file.path, nil, 'gb2312')
    results = {}
    results[:trades] = []
    widgets.each_with_index do |record, index|
      trade = {}
      trade[:exchange_instrument_code] = record['INSTRID']
      trade[:exchange_trade_id] = record['TRADEID']
      trade[:traded_volume] = record['TVOLUME']
      trade[:traded_price] = record['TPRICE']
      trade[:exchange_traded_at] = "#{self.cleared_at} #{record['TTIME']}".to_time
      trade[:order_side] = record['DIRECTION'].strip == '买' ? Acropolis::OrderSides.order_sides.buy : Acropolis::OrderSides.order_sides.sell
      trade[:open_close] = record['OFFSETFLAG'].strip == '开仓' ? Acropolis::TradeOpenFlags.trade_open_flags.open : Acropolis::TradeOpenFlags.trade_open_flags.close
      results[:trades] << trade
    end

    results[:trading_account_id] = trading_account_id
    results[:cleared_at] = cleared_at
    results
  end

end