class HomeController < ActionController::Base
  layout 'homepage'

  def index
    # An example call to the engine
    @players = Player.all

    # TODO: This should be a call to the engine
    @games   = Game.all
  end
end
