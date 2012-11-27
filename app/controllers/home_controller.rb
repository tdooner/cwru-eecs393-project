class HomeController < ApplicationController
  layout 'homepage'

  def index
    # An example call to the engine
    @players = Player.sort(:points.desc).all

    # TODO: This should be a call to the engine
    @games   = Game.all
  end
end
