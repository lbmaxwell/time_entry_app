class Ability
  include CanCan::Ability

  def initialize(user)

    if user.admin?
      can :manage, :all
      cannot :destroy, User
      cannot :destroy, Assignment
#      cannot :edit, Assignment
#      cannot :update, Assignment
      cannot :destroy, Task
      cannot :destroy, TaskInventory
      cannot :destroy, Team
    else
      if user.team.nil?
        can :change_team, User, user_id: user.id
        can :update, User, user_id: user.id
      else
        can :new, Comment
        can :create, Comment
        can :edit, Comment, user_id: user.id
        can :update, Comment, user_id: user.id
        can :destroy, Comment, user_id: user.id
        can :new, TimeEntry
        can :create, TimeEntry
        can :edit, TimeEntry, user_id: user.id, effective_date: Date.today..(Date.today + 8)
        can :update, TimeEntry, user_id: user.id, effective_date: Date.today..(Date.today + 8)
        can :destroy, TimeEntry, user_id: user.id
        can :show, TimeEntry, user_id: user.id
        can :is_task_direct, TimeEntry
        can :new, PaidTimeEntry
        can :create, PaidTimeEntry
        can :edit, PaidTimeEntry, user_id: user.id, effective_date: Date.today..(Date.today + 8)
        can :update, PaidTimeEntry, user_id: user.id, effective_date: Date.today..(Date.today + 8)
        can :destroy, PaidTimeEntry, user_id: user.id
        can :show, PaidTimeEntry, user_id: user.id
        can :index, PaidTimeEntry
        can :edit, User, user_id: user.id
        can :update, User, user_id: user.id
        can :change_team, User, user_id: user.id
      end
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
