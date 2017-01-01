# Is used to declare a companies' rights to access
# other models' data
class Ability
  include CanCan::Ability

  # rubocop:disable all
  def initialize(company)
    can :create, Worker
    can :manage, Worker do |worker|
      worker.company == company
    end

    can :create, Site
    can :manage, Site do |site|
      site.company == company
    end
  end
end
