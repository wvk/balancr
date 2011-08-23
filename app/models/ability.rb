class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :access, :dashboard
      can :view, Project do |project|
        user.member_of? project
        can :invite, Project do |project|
          project.owner_id == user.id
        end
        can :assign, Project do |project|
          project.owner_id == user.id
        end
      end
      can :manage, user

      if user.login == 'wvk'
        can :manage, Invitation
        can :manage, Payment
        can :manage, Project
        can :assign, Project
        can :invite, Project
        can :manage, User
      end
    else
      can :access, :login
      can :access, :registration
    end
  end
end
