class Ability
  include CanCan::Ability

  def initialize(company)
    can :create, Worker
    can :manage, Worker do |worker|
      worker.company == company
    end

    can :create, Site
    can :manage, Site do |site|
      site.company == company
    end

    can :create, Route
    can :manage, Route do |route|
      route.site.company == company
    end
  end
end
