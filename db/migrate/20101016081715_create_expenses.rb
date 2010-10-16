class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.integer :project_id
      t.integer :user_id
      t.float   :amount
      t.date    :date
      t.string  :name

      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
