class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :project_id
      t.integer :invitee_id
      t.integer :inviter_id
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
