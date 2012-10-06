class HomeController < ActionController::Base
  def index
    # The homepage
    p = Player.new
    p.name = 'Tom Dooner'     # In real life this will be pulled from the DB
    render :text => p.get_attribute(:name)
  end
end
