require 'filtered_model'
require 'plugin'

module ZombieGame
  class Engine
    def initialize
      # Load all the plugins, return a list of the intended classnames.
      #
      # So, "plugins/donut_plugin.rb" should provide a class DonutPlugin
      #              \__________/
      Dir["./lib/zombie_game/plugins/*.rb"].map do |file|
        require file

        File.basename(file, '.rb').camelize
      end
    end

    def get_players
      Player.all.map{ |x| x.apply_filters }
    end
  end
end
