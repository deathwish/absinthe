module Absinthe
  module Plugins; end

  module Distillery
    class Plugin
      def initialize injector, namespace, source_loader
        @injector, @namespace, @source_loader = injector, namespace, source_loader
      end

      def load name
        @source_loader.require_dir :plugins, name

        # HACK not like this!
        mod = @namespace.root::Absinthe::Plugins
        plugin_name = mod.constants.grep(/#{name.to_s.gsub('_', '')}/i).first
        plugin = mod.const_get plugin_name
        plugin.register @injector if plugin.respond_to? :register
      end
    end
  end
end
