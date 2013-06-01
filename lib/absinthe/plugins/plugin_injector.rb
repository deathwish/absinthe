module Absinthe::Plugins
  class PluginInjector
    def self.register injector
      injector.register :plugin_injector, PluginInjector, :plugin
    end

    def initialize plugin
      @plugin = plugin
    end

    def boot!
      @plugin.names.each do |service_name|
        service = @plugin.injector.inject(service_name)
        proxy = Module.new { extend self }
        proxy.send(:define_method, :method_missing) do |meth, *args, &block|
          service.send meth, *args, &block
        end

        # TODO should be elsewhere.
        clazz_name = service_name.to_s.split('_').map(&:capitalize!).join ''
        @plugin.namespace.root.send :const_set, clazz_name, proxy
      end
    end
  end
end
