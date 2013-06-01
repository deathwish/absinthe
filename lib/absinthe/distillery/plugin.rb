module Absinthe
  module Plugins; end

  module Distillery
    class Plugin
      class NotLoaded < Exception; end

      attr_reader :injector, :namespace, :names
      def initialize injector, namespace, source_loader
        @injector, @namespace, @source_loader = injector, namespace, source_loader
        @names = []
      end

      def load name
        @source_loader.require_dir :plugins, name

        # HACK not like this!
        mod = @namespace.root::Absinthe::Plugins
        plugin_name = mod.constants.grep(/#{name.to_s.gsub('_', '')}/i).first
        raise NotLoaded, "#{name} was not found in Absinthe::Plugins" unless plugin_name
        plugin = mod.const_get plugin_name
        plugin.register @injector if plugin.respond_to? :register
        @names << name
      end

      def boot!
        @names.map do |name|
          @injector.inject(name)
        end.reverse.each do |plugin|
          plugin.boot! if plugin.respond_to?(:boot!)
        end
      end
    end
  end
end
