class User < ActiveRecord::Base
  has_many :expenses
  has_many :memberships
  has_many :projects,
      :through => :memberships
  has_many :received_payments,
      :class_name  => 'Payment',
      :foreign_key => :creditor_user_id
  has_many :issued_payments,
      :class_name  => 'Payment',
      :foreign_key => :debitor_user_id
  has_many :received_invitations,
      :class_name  => 'Invitation',
      :foreign_key => :invitee_id
  has_many :issued_invitations,
      :class_name  => 'Invitation',
      :foreign_key => :inviter_id
  has_one :bank_account,
      :foreign_key => 'owner_id'

  attr_accessor :password, :terms_accepted, :use_full_validation

  before_save :encrypt_password

  scope :without, lambda {|*user_ids|
    user_ids = user_ids.flatten
    if user_ids.empty?
      {}
    else
      where ['users.id NOT IN (?)', user_ids]
    end
  }

  scope :in_projects, lambda {|*project_ids|
    where('memberships.project_id' => project_ids.flatten).includes(:memberships)
  }

  validates_presence_of :login
  validates_confirmation_of :password,
      :on => :update
  validates_presence_of :forename, :surname, :email, :password,
      :if => :use_full_validation
  validates_acceptance_of :terms_accepted,
      :if => :use_full_validation

  def self.[](login)
    self.find_or_create_by_login login
  end

  def full_name
    "#{self.forename} #{self.surname}"
  end

  # amount owed to or owed by other user.
  # a negative amount means: self owes money to user.
  # a positive amount means: user owes money to self.
  def balance_to(user)
    shared_projects     = user.projects.where('projects.id' => self.project_ids)
    money_from_projects = shared_projects.reduce(0.0) do |sum, project|
      case project.bank
      when user
        sum - self.balance_for(project)
      when self
        sum + user.balance_for(project)
      when nil
        sum + (self.amount_spent_on(project) - user.amount_spent_on(project)) / project.users.count
      else
        sum
      end
    end
    money_from_projects + self.amount_payed_to(user) - self.amount_received_from(user)
  end

  def payment_instruction_for(user, silent = false)
    balance = balance_to user
    if balance < 0
      %q(You owe %s %0.2f€) % [user.full_name, -balance]
    elsif balance > 0
      %q(You get %0.2f€ from %s) % [balance, user.full_name]
    elsif not silent
      %q(You're all good with %s) % user.full_name
    end
  end

  def payment_instructions_for(users, silent = false)
    users.map {|u| self.payment_instruction_for u, silent }.compact
  end

  def amount_payed_to(user)
    self.issued_payments.where(:creditor_user_id => user.id).sum(:amount)
  end

  def amount_received_from(user)
    self.received_payments.where(:debitor_user_id => user.id).sum(:amount)
  end

#   def amount_spent
#     self.expenses.sum(:amount)
#   end

  def amount_spent_on(project)
    self.expenses.where(:project_id => project.id).sum(:amount)
  end

  def balance_for(project)
    project.cost_per_person - self.amount_spent_on(project)
  end

  def pays(amount)
    self.issued_payments.build(:amount => amount)
  end

  def spends(amount)
    self.expenses.build(:amount => amount)
  end

  def joins(project)
    self.memberships.create :project => project
  end

  def leaves(project)
    self.memberships.where(:project_id => project.id).first.destroy
  end

  def member_of?(project)
    project.memberships.where(:project_id => project.id).exists?
  end

  def password_matches?(passwd)
    Digest::SHA1.hexdigest(passwd) == password_hash
  end

  def encrypt_password
    self.password_hash = Digest::SHA1.hexdigest(@password) if @password
  end

  def friends
    User.includes(:memberships).where(['memberships.project_id IN (?) AND users.id != ?', self.project_ids, self.id])
  end

  def with_full_validation
    self.use_full_validation = true
    self
  end
end
