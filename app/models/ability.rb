# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user || User.new

    if user
      user.admin? ? admin : auth_user
    else
      guest
    end
  end

  def admin
    can :manage, :all
  end

  def auth_user
    guest
    can :read, Payplan

    can :index, :dashboard
    can :users, :dashboard
    can :user_destroy, :dashboard
    can :test_email, :dashboard

    can :show, Account, {user_id: user[:id]}

    can :create, Integration

    can :create, ReviewIntegration
    can :destroy, ReviewIntegration, {user_id: user[:id]}

    can :create, Invoice, {invoiceable: {integration: {user_id: user[:id]}}}
    can :show, Invoice, {user_id: user[:id]}
    can :edit, Invoice, {user_id: user[:id]}
    can :destroy, Invoice, {user_id: user[:id]}

    can :read, Payment, {user_id: user[:id]}
  end

  def guest
    can :index, :home
    can :manual, :home
  end
end
