class CreateBankAccounts < ActiveRecord::Migration
  def self.up
    create_table :bank_accounts do |t|
      t.integer :owner_id
      t.string :bank_name
      t.string :owner_name
      t.string :account_no
      t.string :blz
      t.string :iban
      t.string :bic

      t.timestamps
    end
  end

  def self.down
    drop_table :bank_accounts
  end
end
