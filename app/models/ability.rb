class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Users can manage themselves but no one else
    cannot :manage, User
    cannot :manage, Player
    can :read, [User, Player]
    can :manage, User, :id => user.id
    can :manage, Player, :user_id => user.id

    # Game admins can manage players of the game they administer
    can :manage, Player do |player|
      user.players.where(:game_id => player.game_id, :game_admin => true).exists?
    end

    # Game admins can manage games they administer
    can :manage, Game do |game|
      user.players.where(:game_id => game.id, :game_admin => true).exists?
    end

    # Only site admins can adminify people
    cannot :adminify, [User, Player]

    # Only site admins can create or destroy games
    cannot [:create, :destroy], Game

    if user.site_admin?
      # Site admins can manage all attributes of users, players, games, squads
      can :manage, [User, Player, Game, Squad]
      can :read, Waiver
    end
  end
end
