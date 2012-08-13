class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is_admin == true
      can :manage, :all
    elsif user.is_admin == false
      can :watch, User
      can :watch, UserGroup
      can :watch, Board do |board|
        user.boards.include?(board)
      end
    end
  end
end
