class Ability
  include CanCan::Ability

  def initialize(user)

    # Users can manage themselves
    can :manage, User, :id => user.id
    can :manage, Player, :user_id => user.id

    # Game admins can manage players of the game they administer
    can :manage, Player do |player|
      user.players.find(:game_id => player.game_id, :game_admin => true).any?
    end

    # Game admins can manage games they administer
    can :manage, Game do |game|
      user.players.find(:game_id => game.id, :game_admin => true).any?
    end

    if user.site_admin?
      # Site admins can manage all attributes of users, players, games, squads
      can :manage, [User, Player, Game, Squad]
      can :read, Waiver
    else
      # Only site admins can adminify people
      cannot :adminify, [User, Player]

      # Only site admins can create or destroy games
      cannot [:create, :destroy], Game
    end
  end
end
