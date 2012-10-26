class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_by_facebook(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      flash[:notice] = "Logged in!"
    else
      # not sure when you'd hit this code path.
      puts "Well, here's how..."
      debugger
    end
  end
end
