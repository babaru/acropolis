class ChangeSecurityCodeNameInstruments < ActiveRecord::Migration
  def up
    rename_column :instruments, :security_code, :exchange_instrument_code
  end

  def down
    rename_column :instruments, :exchange_instrument_code, :security_code
  end
end
