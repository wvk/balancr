class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :creditor_user_id
      t.integer :debitor_user_id
      t.float :amount
      t.date :date
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
