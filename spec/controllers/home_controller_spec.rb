require 'spec_helper'

describe HomeController do
  render_views

  before do
    # Because we actually have some state maintained between tests:
    Player.destroy_all

    @user = FactoryGirl.create(:user)
  end

  describe '#index' do
    context 'when a user is logged out' do
      before do
        sign_out @user
        get :index
      end

      it 'invites the user to log in' do
        response.body.should match(/Log in/)
      end
    end

    context 'when a user is logged in' do
      before do
        sign_in @user
        controller.stub(:default_game => FactoryGirl.create(:game))
        get :index
      end

      it 'allows the user to log out' do
        response.body.should match(/Log Out/)
      end
    end
  end
end
