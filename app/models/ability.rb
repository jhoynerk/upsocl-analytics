class Ability
  include CanCan::Ability
  include ActiveAdminRole::CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.super_user?
      can :manage, :all
    else
      register_role_based_abilities(user)
    end
  end
end
