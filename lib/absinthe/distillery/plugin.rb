module Absinthe
  module Distillery
    class Plugin
      def initialize context, source_loader
        @context, @source_loader = context, source_loader
      end

      def load name
        @source_loader.require_dir :plugins, name

        # HACK not like this!
        plugin_name = Absinthe::Plugins.constants.grep(/#{name.to_s.gsub('_', '')}/i).first
        plugin = Absinthe::Plugins.const_get plugin_name
        plugin.register @context if plugin.respond_to? :register
      end
    end
  end
end
