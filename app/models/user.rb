class User
  include MongoMapper::Document
  devise :omniauthable

  key :name, String
  key :email, String
  key :image_url, String
  key :auth_provider, String     # OmniAuth provider (:facebook, :cas, etc.)
  key :auth_uid, String          # OmniAuth access key
  key :site_admin, Boolean

  many :players

  def registered?(game)
    game.players.where(:user_id => self.id).count > 0
  end

  def register_for_game(game)
    Player.create(:user_id => self.id, :registered => true, :game_id => game.id)
  end

  def unregister_for_game(game)
    game.players.where(:user_id => self.id).remove
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
