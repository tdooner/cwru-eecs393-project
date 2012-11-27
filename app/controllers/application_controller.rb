class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_default_game
  before_filter :set_time_zone

  def set_default_game
    # TODO: Use the subdomain to determine the current game.
    @default_game = Game.last
  end

  def set_time_zone
    Time.zone = @default_game.time_zone || Time.now.zone
  end
end
