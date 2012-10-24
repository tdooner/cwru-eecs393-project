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
end
