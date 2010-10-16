class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :project_id
      t.boolean :is_bank

      t.timestamps
    end

    remove_column :projects, :bank_id
  end

  def self.down
    drop_table :memberships
  end
end
