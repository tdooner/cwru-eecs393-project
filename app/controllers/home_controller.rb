class HomeController < ActionController::Base
  layout 'application'

  def index
    # An example call to the engine
    @text = ENGINE.get_players
  end
end
