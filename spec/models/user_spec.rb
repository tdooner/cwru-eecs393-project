require 'spec_helper'

# Tests for User.find_by_facebook, a class method

describe User, '.find_by_facebook' do
  before do
    User.delete_all
  end

  context 'when given auth parameters that match a user' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:auth_blob) {
      stub(:uid => user.auth_uid, :info => 
           stub(:name => user.name, :email => user.email, :image => user.image_url))
    }

    it 'returns an array with the user in it' do
      User.find_by_facebook(auth_blob).should eq(user)
    end
  end

  context 'when given auth parameters that do not match a user' do
    let!(:auth_blob) {
      stub(:uid => '987654321', :info => 
           stub(:name => 'John Doe', :email => 'john@example.com', :image => 'http://example.com/image.png'))
    }

    it 'creates the user' do
      User.find_by_facebook(auth_blob).should be_a(User)
    end
  end
end

# Tests for User#registered?(game), an instance method
describe User, '#registered?' do
  let!(:game) { FactoryGirl.create(:game) }
  let!(:user) { FactoryGirl.create(:user) }

  context 'for a game which the user has no registration' do
    subject { user.registered?(game) }
    it { should be_false }
  end

  context 'for a game to which the user is registered' do
    before do
      user.register_for_game(game)
    end

    it 'returns true' do
      user.registered?(game).should be_true
    end
  end
end

describe User, '#register_for_game' do
  let!(:game) { FactoryGirl.create(:game) }
  let!(:user) { FactoryGirl.create(:user) }

  it "doesn't create multiple Player models" do
    user.register_for_game(game)

    expect { user.register_for_game(game) }.
      to_not change { Player.count }
  end

  it 'creates a Player model appropriately' do
    expect { user.register_for_game(game) }.
      to change { Player.count }.by 1
  end
end

describe User, '#unregister_for_game' do
  let!(:game) { FactoryGirl.create(:game) }
  let!(:user) { FactoryGirl.create(:user) }

  context 'when the player is registered for the game' do
    before do
      # Note: Tests here share state -- the database will retain its
      # state between tests. So this relies on register_for_game doing the right
      # thing.
      user.register_for_game(game)
    end

    it 'should destroy the registration instance' do
      expect { user.unregister_for_game(game) }.
        to change { Player.count }.by -1
    end

    it 'should make the player no longer registered for the game' do
      expect { user.unregister_for_game(game) }.
        to change { user.registered?(game) }.to false
    end
  end

  context 'when the player is not registered for the game' do
    it 'makes no changes to the Players collection' do
      expect { user.unregister_for_game(game) }.
        to_not change { Player.count }
    end
  end
end
