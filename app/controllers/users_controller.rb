class UsersController < ApplicationController
  before_filter :set_user

  def show
    if cannot? :read, @user
      flash[:error] = "You do not have permission to view that user's profile."
      return redirect_to show_user_url(@current_user)
    end

    @players = @user.players
  end

  def set_user
    @user = User.find(params[:id])
  end
end
