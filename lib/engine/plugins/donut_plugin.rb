class DonutPlugin < ZombieGame::Plugin
  filter_attribute Player, :name, :invert_display_name

  def self.invert_display_name(name)
    "Not #{name}"
  end
end
