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
end