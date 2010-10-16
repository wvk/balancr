class User < ActiveRecord::Base
  has_many :expenses
  has_many :memberships
  has_many :projects,
      :through => :memberships
  has_many :received_payments,
      :class_name  => Payment,
      :foreign_key => :creditor_user_id
  has_many :issued_payments,
      :class_name  => Payment,
      :foreign_key => :debitor_user_id

  validates_presence_of :login

  def self.[](login)
    self.find_or_create_by_login login
  end

  def balance_to(user)
    own_project_ids = self.project_ids
    shared_projects = Project.having_as_bank(user).select{|project| own_project_ids.include? project.id }
    return shared_projects.collect{|project| self.balance_for project }.sum
  end

  def amount_owed

  end

  def amount_spent
    self.expenses.sum(:amount)
  end

  def amount_spent_on(project)
    self.expenses.where(:project_id => project.id).sum(:amount)
  end

  def balance_for(project)
    project.cost_per_person - self.amount_spent_on(project)
  end

  def spends(amount)
    self.expenses.build(:amount => amount)
  end

  def joins(project)
    self.memberships.create :project => project
  end

end
