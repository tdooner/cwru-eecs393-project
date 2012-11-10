class DonutPlugin < ZombieGame::Plugin
  filter_attribute Player, :name, :invert_display_name
  filter_attribute Player, :caseid, :everyone_is_tom!

  def self.invert_display_name(name)
    "Not #{name}"
  end

  def self.everyone_is_tom!(caseid)
    return 'ted27'
  end
end
