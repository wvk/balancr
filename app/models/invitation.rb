class Invitation < ActiveRecord::Base

  belongs_to :inviter,
      :class_name => 'User'
  belongs_to :invitee,
      :class_name => 'User'
  belongs_to :project

  validates_presence_of :inviter, :invitee, :project
  validates_uniqueness_of :invitee_id,
      :scope   => [:project_id, :inviter_id],
      :message => 'You have already invited this user to this project'

  delegate :full_name,
      :to => :inviter,
      :allow_nil => true,
      :prefix => true
  delegate :full_name,
      :to => :invitee,
      :allow_nil => true,
      :prefix => true
  delegate :name,
      :to => :project,
      :allow_nil => true,
      :prefix => true
end
