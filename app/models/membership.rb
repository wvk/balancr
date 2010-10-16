class Membership < ActiveRecord::Base

  belongs_to :project
  belongs_to :user

  validates_presence_of :user, :project
  validates_uniqueness_of :user_id,
      :scope => :project_id

  def as_bank
    self.update_attribute :is_bank => true
  end
end
