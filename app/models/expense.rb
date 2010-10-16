class Expense < ActiveRecord::Base

  belongs_to :project
  belongs_to :user

  validates_presence_of :project, :user, :amount

  validates_numericality_of :amount

  def on(project)
    self.project = project
    return self if self.save
  end

end
