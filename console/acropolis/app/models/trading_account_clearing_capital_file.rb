class TradingAccountClearingCapitalFile < UploadFile
  validates_attachment_file_name :data_file, :matches => [/dbf\Z/]

  def cleared_on
    meta_data[:cleared_on]
  end

  def cleared_on=(val)
    meta_data[:cleared_on] = val
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
    widgets.each_with_index do |record, index|
      case index
      when 0
        results[:previous_currency_balance] = record['ITEMVALUE']
        results[:trading_account_number] = record['ACCOUNTID']
      when 1
        results[:incoming] = record['ITEMVALUE']
      when 2
        results[:profit] = record['ITEMVALUE']
      when 3
        results[:outgoing] = record['ITEMVALUE']
      when 4
        results[:fee] = record['ITEMVALUE']
      when 5
        results[:trading_fee] = record['ITEMVALUE']
      when 6
        results[:clearing_fee] = record['ITEMVALUE']
      when 7
        results[:delivery_fee] = record['ITEMVALUE']
      when 8
        results[:position_transfer_fee] = record['ITEMVALUE']
      when 9
        results[:currency_balance] = record['ITEMVALUE']
      when 10
        results[:margin] = record['ITEMVALUE']
      when 11
        results[:clearing_reserve] = record['ITEMVALUE']
      when 16
        results[:next_currency_balance] = record['ITEMVALUE']
      end
    end

    results[:trading_account_id] = trading_account_id
    results[:cleared_at] = cleared_at
    results
  end
end