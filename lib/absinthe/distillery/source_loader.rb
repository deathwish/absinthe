module Absinthe::Distillery
  class PluginNotFound < Exception; end

  class SourceLoader
    def initialize app_root, namespace
      @namespace = namespace
      if app_root
        $LOAD_PATH.unshift(File.expand_path(File.join(app_root, 'lib')))
      end

      @plugin_paths = []
      $LOAD_PATH.each do |path|
        plugin_path = File.join path, 'absinthe', 'plugins'
        if File.directory? plugin_path
          @plugin_paths << plugin_path
        end
      end
    end

    def require_dir root, *paths
      # TODO validate the root param
      # TODO this is a mess
      paths.each do |path|
        plugin_sources = []
        @plugin_paths.each do |plugin_path|
          target = File.join plugin_path, "#{path}.rb"
          next unless File.file? target

          support_dir = File.join plugin_path, path.to_s

          with_hooked_require(support_dir) do
            plugin_sources << target
            @namespace.load_file File.new(target)
          end
        end

        if plugin_sources.empty?
          raise PluginNotFound, "No plugin named #{path} was found in #{@plugin_paths.join ', '}"
        end
      end
    end

    private
    def with_hooked_require support_dir
      original_require = ::Kernel.method(:require)
      namespace = @namespace
      ::Kernel.send(:define_method, :require) do |filename|
        target = File.join support_dir, "#{filename}.rb"
        if File.file? target
          namespace.load_file File.new(target)
        else
          original_require.call filename
        end
      end

      yield
    ensure
      ::Kernel.send(:define_method, :require, &original_require)
    end
  end
end
