class Ability
  include CanCan::Ability

  def initialize(user)
    if user and not user.guest?
      can :access, :dashboard

      can :view, Project do |project|
        user.member_of? project
      end

      can :invite, Project do |project|
        project.owner_id == user.id
      end

      can :assign, Project do |project|
        project.owner_id == user.id
      end

      can :edit, User, :id => user.id

      can :manage, BankAccount do |account|
        account.owner == user
      end

      if user.login == 'wvk'
        can :invite, :anyone
        can :manage, Invitation
        can :manage, Payment
        can :manage, Project
        can :assign, Project
        can :invite, Project
        can :manage, User
      end

      cannot :delete, User do |u|
        u.memberships.any?
      end

      can :access, :logout
    else
      can :access, :login
      can :access, :registration
    end
  end

end
