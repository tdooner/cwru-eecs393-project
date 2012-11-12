require 'spec_helper'

# Tests for User.find_by_facebook, a class method

describe User, '.find_by_facebook' do
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

  it "doesn't register you again for the same game"
  it 'creates a Player model appropriately'

end
