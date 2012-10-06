class OtherPlugin < Engine::Plugin
  filter_attribute Player, :name, :add_some_excitement!

  def self.add_some_excitement!(name)
    return "#{name}!"
  end
end
