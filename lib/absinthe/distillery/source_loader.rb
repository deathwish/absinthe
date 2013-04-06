module Absinthe::Distillery
  class PluginNotFound < Exception; end

  class SourceLoader
    def boot! ctx
      if ctx[:app_root]
        $LOAD_PATH.unshift(File.expand_path(File.join(ctx[:app_root], 'lib')))
      end

      @plugin_paths = []
      $LOAD_PATH.each do |path|
        plugin_path = File.join path, 'absinthe', 'plugins'
        if File.directory? plugin_path
          @plugin_paths << plugin_path
        end
      end
    end

    def source_files root, paths
      # TODO validate the root param
      sources = []

      # TODO this is a mess
      paths.each do |path|
        plugin_sources = []
        @plugin_paths.each do |plugin_path|
          target = File.join plugin_path, "#{path}.rb"
          if File.file? target
            file = File.new target
            plugin_sources << file

            support_dir = File.join plugin_path, path.to_s
            if File.directory? support_dir
              $LOAD_PATH.unshift support_dir
            end

            yield file
            $LOAD_PATH.delete support_dir
          end
        end
        if plugin_sources.empty?
          raise PluginNotFound, "No plugin named #{path} was found in #{@plugin_paths.join ', '}"
        end
      end
    end
  end
end
