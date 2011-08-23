class Membership < ActiveRecord::Base

  belongs_to :project
  belongs_to :user

  validates_presence_of :user, :project
  validates_uniqueness_of :user_id,
      :scope => :project_id

  before_destroy :prohibit_leave_if_balance_not_zero

#   def as_bank
#     self.update_attribute :is_bank => true
#   end

  def prohibit_leave_if_balance_not_zero
    if self.user.balance_for(self.project) != 0.0
      raise 'user cannot leave project since his balance is not 0.0'
    end
  end
end
