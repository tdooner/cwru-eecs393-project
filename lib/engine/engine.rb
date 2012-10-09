module ZombieGame
  class Plugin
    # Class Methods
    class << self
      ##
      # This are the magical methods we will define to provide a nice Domain
      # Specific Language for plugin authors.
      #
      # Since all Plugins will extend ZombieGame::Plugin, they can use these
      # methods as the way of interfacing with the plugin.
      #
      def filter_attribute(classname, attrname, callback)
        # TODO: fix this line to not be so ugly:
        classname.class_variable_get("@@hooks")[attrname] =
          (classname.class_variable_get("@@hooks")[attrname] || []) << [self, callback]

        puts "Registered hook in #{self} for #{classname}.#{attrname} -> #{self}.#{callback}"
        puts "  now we're filtering... #{classname.class_variable_get("@@hooks").inspect}"
      end

      #####
      # Some other examples of the DSL we can provide...
      #####
      def register_page(args)
        # Implement me....
      end

      def register_hook(event, callback)
        # Implement me....
      end
    end
  end

  module FilteredModel
    @@hooks = {}

    def get_attribute(attrname, apply_filters = true)
      if apply_filters
        Plugin.perform_filters(self, attrname)
      else
        self.send(attrname)       # Calls the method of the attribute, i.e. getting the attribute from the ORM
      end
    end

    def apply_filters
      self.class.class_variable_get("@@hooks").each do |attr, filter_list|
        # Use the setter to update the attribute of the models in memory with
        # their filtered values.
        self.send("#{attr}=",
                  filter_list.inject(self.send(attr)) do |a, (plugin_name, method_name)|
                    puts "calling #{plugin_name}.#{method_name}"
                    a = plugin_name.send(method_name.to_sym, a)
                  end
                 )
      end
      self
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

    def get_players
      Player.all.map{ |x| x.apply_filters }
    end
  end
end
