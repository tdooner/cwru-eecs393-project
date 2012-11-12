class User
  include MongoMapper::Document
  devise :omniauthable

  key :name, String
  key :email, String
  key :image_url, String
  key :auth_provider, String     # OmniAuth provider (:facebook, :cas, etc.)
  key :auth_uid, String          # OmniAuth access key

  def registered?(game)
    Player.where(:game_id => game.id, :user_id => self.id).count > 0
  end

  def register_for_game(game)
    Player.create(:game_id => game.id, :user_id => self.id)
  end

  def unregister_for_game(game)
    Player.where(:game_id => game.id, :user_id => self.id).destroy_all
  end

  class << self
    def find_by_facebook(auth_blob, current_user = nil)
      user = User.where(:auth_provider => :facebook, :auth_uid => auth_blob.uid).first
      user ||= User.create(
        :auth_provider => :facebook,
        :auth_uid => auth_blob.uid
      )
      user.set(
        :name => auth_blob.info.name,
        :email => auth_blob.info.email,
        :image_url => auth_blob.info.image,
      )

      return user
    end
  end
end
