# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # user ||= User.new
    # if user.manager?
    #   can :manage, :all
    # else
    #   can :read, :all
    # end
  end
end
