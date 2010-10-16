class Payment < ActiveRecord::Base

  belongs_to :creditor_user,
      :class_name => User
  belongs_to :debitor_user,
      :class_name => User

  validates_presence_of :creditor_user, :debitor_user, :amount

end
