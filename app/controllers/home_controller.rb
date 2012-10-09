class HomeController < ActionController::Base
  def index
    # An example call to the engine
    render :text => ENGINE.get_players
  end
end
