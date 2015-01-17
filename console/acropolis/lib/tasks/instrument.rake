namespace :instrument do
  task :import_from_file, [:exchange_name, :file_path] => :environment do |t, args|
    if defined?(Rails) && (Rails.env == 'development')
      Rails.logger = Logger.new(STDOUT)
    end

    exchange = Exchange.find_by_name(args.exchange_name)
    if exchange.nil?
      Rails.logger "Not found exchange #{args.exchange_name}, quit."
      return
    end

    Instrument.transaction do
      File.open(args.file_path, 'rb') do |file|
        content = file.read
        content.split('|').each_with_index do |line, index|
          line.scan(/ProductID\[(.+)\]\sProductClassID\[.+\]\sProductTypeCode\[(.+)\]\sStrategyTypeCode.+SymbolID\[(.+)\]\sExpirationDateTime\[(.+)\]\sStrikePrice\[\]\sVersionID.+CurrencyID\[(.+)\]\sLotSize/) do |matches|
            if matches.length
              security_code = matches[0]
              type_code = matches[1]
              symbol_id = matches[2]
              expiration_date = matches[3]
              currency_code = matches[4]

              if type_code == 'FUTURE'

                currency = Currency.find_by_code(currency_code.upcase)
                if currency.nil?
                  currency = Currency.create(code: currency_code.upcase, exchange_rate: 1)
                end

                trading_symbol = TradingSymbol.find_by_name_and_exchange_id(symbol_id, exchange.id)
                if trading_symbol.nil?
                  trading_symbol = TradingSymbol.create(
                    name: symbol_id,
                    exchange_id: exchange.id,
                    currency_id: currency.id,
                    trading_fee: TradingFee.new(type: 'FixedTradingFee', factor: 9),
                    margin: Margin.new(type: 'FixedRateMargin', factor: 0.1),
                    trading_symbol_type: Acropolis::TradingSymbolTypes.trading_symbol_types.futures
                  )
                else
                  trading_symbol.update_attributes(
                    name: symbol_id,
                    exchange_id: exchange.id,
                    currency_id: currency.id
                  )
                end

                instrument = Instrument.find_by_security_code_and_exchange_id(security_code, exchange.id)
                if instrument.nil?

                  FuturesInstrument.create(
                      security_code: security_code,
                      trading_symbol_id: trading_symbol.id,
                      exchange_id: exchange.id,
                      expiration_date: expiration_date,
                      instrument_type: Acropolis::InstrumentTypes.instrument_types.futures
                    )
                else
                  instrument.update_attributes(
                      trading_symbol_id: trading_symbol.id,
                      exchange_id: exchange.id,
                      expiration_date: expiration_date
                    )
                end

              end
            end
          end
        end
      end
    end

  end

  task :import_from_q7_csv, [:file] => :environment do |t, args|
    CSV.read(args.file).each_with_index do |line_data, index|
      next if index == 0
      next if line_data[6].nil? || line_data[6] == '组合'

      exchange_short_cn_name = line_data[3]
      exchange = Exchange.find_by_short_cn_name(exchange_short_cn_name)

      trading_symbol_type = 0
      if line_data[6] == '期货'
        trading_symbol_type = 2
      elsif line_data[6] == '期权'
        trading_symbol_type = 3
      else
        trading_symbol_type = 0
      end

      instrument_type = 0
      strike_price = nil
      if line_data[6] == '期货'
        instrument_type = 3
      elsif line_data[6] == '期权'
        if line_data[1].include? "C"
          instrument_type = 4
        elsif line_data[1].include? "P"
          instrument_type = 5
        end

        line_data[1].scan(/(\d+)$/) do |matches|
          if matches.length > 0
            strike_price = matches[0]
          end
        end
      else
        instrument_type = 0
      end

      trading_symbol_name = line_data[0]
      trading_symbol = TradingSymbol.find_by_name_and_exchange_id(trading_symbol_name.strip, exchange.id)
      if trading_symbol.nil?
        trading_symbol = TradingSymbol.create(exchange_id: exchange.id,
          name: trading_symbol_name,
          currency_id: 1,
          multiplier: line_data[4],
          trading_symbol_type: trading_symbol_type)
      else
        trading_symbol.update(exchange_id: exchange.id,
          name: trading_symbol_name,
          currency_id: 1,
          multiplier: line_data[4],
          trading_symbol_type: trading_symbol_type)
      end

      instrument = Instrument.find_by_exchange_instrument_code_and_exchange_id(line_data[1].strip, exchange.id)
      if instrument.nil?
        instrument = Instrument.create(name: line_data[2],
          expiration_date: DateTime.strptime(line_data[7], '%Y%m%d'),
          strike_price: strike_price,
          exchange_id: exchange.id,
          trading_symbol_id: trading_symbol.id,
          exchange_instrument_code: line_data[1],
          instrument_type: instrument_type)
      else
        instrument.update(name: line_data[2],
          expiration_date: DateTime.strptime(line_data[7], '%Y%m%d'),
          strike_price: strike_price,
          exchange_id: exchange.id,
          trading_symbol_id: trading_symbol.id,
          exchange_instrument_code: line_data[1],
          instrument_type: instrument_type)
      end
    end
  end

  task :import_from_margin_trading_fee_csv, [:file] => :environment do |t, args|
    CSV.read(args.file).each_with_index do |line_data, index|
      next if index == 0

      trading_symbol_name = line_data[1]
      trading_symbol = TradingSymbol.find_by_name(trading_symbol_name.strip)
      if trading_symbol.nil?
        puts "Not found trading symbol: #{trading_symbol_name}"
        next
      end

      margin_string = line_data[3]
      trading_fee_string = line_data[4]

      margin_type = 'FixedRateMargin'
      margin_factor = nil

      puts margin_string

      margin_string.scan(/([\d|\.]*)\%$/) do |matches|
        if matches.length > 0
          puts matches[0].to_f
          margin_factor = matches[0].to_f / 100
          trading_symbol.margin = Margin.new(type: margin_type) if trading_symbol.margin.nil?
          trading_symbol.margin.factor = margin_factor
        end
      end

      trading_fee_type = nil
      trading_fee_factor = nil

      trading_fee_string.scan(/([\d|\.]*)\%$/) do |matches|
        if matches.length > 0
          trading_fee_factor = matches[0].to_f / 100
          trading_fee_type = 'FixedRateTradingFee'
          trading_symbol.trading_fee = TradingFee.new(type: trading_fee_type, currency_id: 1) if trading_symbol.trading_fee.nil?
          trading_symbol.trading_fee.factor = trading_fee_factor
          trading_symbol.trading_fee.currency_id = 1
        end
      end

      trading_fee_string.scan(/([\d|\.]*)元\/手$/) do |matches|
        if matches.length > 0
          trading_fee_factor = matches[0].to_f
          trading_fee_type = 'FixedTradingFee'
          trading_symbol.trading_fee = TradingFee.new(type: trading_fee_type, currency_id: 1) if trading_symbol.trading_fee.nil?
          trading_symbol.trading_fee.factor = trading_fee_factor
          trading_symbol.trading_fee.currency_id = 1
        end
      end

      trading_symbol.save
    end
  end
end