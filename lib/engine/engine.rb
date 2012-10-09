module ZombieGame
  class Plugin
    # Class Methods
    class << self
      @@hooks = Hash.new([])    # Dictionary that defaults to [] if key not found.

      def filter_attribute(classname, attrname, callback)   # Maybe this belongs on Models instead?
        @@hooks[[classname, attrname]] = @@hooks[[classname, attrname]].push([self, callback])
        puts "Registered hook in #{self} for #{classname}.#{attrname} -> :#{callback}"
      end

      def perform_filters(klass, attrname)
        puts @@hooks.inspect
        puts "performing filters for #{klass.class}.#{attrname}"
        @@hooks[[klass.class, attrname]].inject(klass.send(attrname)) do |a, (plugin_name, method_name)|
          puts "calling #{plugin_name}.#{method_name}"
          a = plugin_name.send(method_name.to_sym, a)
        end
      end
    end
  end

  class Model
    def get_attribute(attrname, apply_filters = true)
      if apply_filters
        Engine::Plugin.perform_filters(self, attrname)
      else
        self.send(attrname)
      end
    end
  end

  class Engine
    def initialize
      # Load all the plugins, return a list of the intended classnames.
      #
      # So, "plugins/donut_plugin.rb" should provide a class DonutPlugin
      #              \__________/
      Dir["./lib/engine/plugins/*.rb"].map do |file|
        require file

        File.basename(file, '.rb').camelize
      end
    end
  end
end
