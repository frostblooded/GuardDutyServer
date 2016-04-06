class Ability
  include CanCan::Ability

  def initialize(company)
    company ||= Company.new

    if company.role? :admin
      can :manage, :all
    end
  end
end