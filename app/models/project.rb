class Project < ActiveRecord::Base

  has_many :expenses
  has_many :memberships
  has_many :users,
      :through => :memberships

  validates_presence_of :name

#   scope :having_as_bank, lambda {|user|
#     joins(:memberships).where('memberships.user_id' => user, 'memberships.is_bank' => true)
#   }

  accepts_nested_attributes_for :memberships,
      :allow_destroy => true

  accepts_nested_attributes_for :expenses,
      :allow_destroy => true,
      :reject_if     => lambda {|e| e[:amount].blank? or e[:amount].to_f == 0.0 }

  def self.[](name)
    self.find_or_create_by_name name
  end

  def total_cost
    self.expenses.sum(:amount)
  end

  def cost_per_person
    return nil if self.users.count == 0
    self.total_cost / self.users.count
  end

  def bank
    @bank ||= User.find(self.bank_id)
  rescue
    nil
  end

  def bank_id=(user_id)
    self.memberships.where(:user_id => user_id).first.update_attribute(:is_bank, true)
  end

  def bank_id
    self.memberships.where(:is_bank => true).first.try :user_id
  end

end
