class Project < ActiveRecord::Base

  has_many :expenses
  has_many :memberships
  has_many :users,
      :through => :memberships

  validates_presence_of :name

  scope :having_as_bank, lambda {|user|
    joins(:memberships).where('memberships.user_id' => user.id, 'memberships.is_bank' => true)
  }

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
    self.users.where(:is_bank => true).first
  end

end
