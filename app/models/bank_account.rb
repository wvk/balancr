class BankAccount < ActiveRecord::Base

  belongs_to :owner,
      :class_name => 'User'

  validates_presence_of :owner, :bank_name, :owner_name, :account_no, :blz

end
