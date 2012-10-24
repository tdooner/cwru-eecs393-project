module ZombieGame
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
end
