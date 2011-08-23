class Payment < ActiveRecord::Base

  belongs_to :creditor_user,
      :class_name => 'User'
  belongs_to :debitor_user,
      :class_name => 'User'

  validates_presence_of :creditor_user, :debitor_user, :amount
  validate :creditor_and_debitor_must_not_be_same

  def to(user)
    self.creditor_user = user
    return self if self.save
  end

  protected

  def creditor_and_debitor_must_not_be_same
    errors.add :debitor_user_id, 'must not be the same user as the creditor user'
  end

end
