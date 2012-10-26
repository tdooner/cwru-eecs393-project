class HomeController < ActionController::Base
  layout 'application'

  def index
    # An example call to the engine
    @players = ENGINE.get_players

    # TODO: This should be a call to the engine
    @games   = Game.all
  end
end
