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

    class RootNamespace
      class LoadFailed < Exception; end

      attr_reader :root, :main
      def initialize context, main
        @context = context
        @main = main
        @root = Module.new { extend self }
        @root.send(:define_method, :context) { context }
        main.include root
      end

      def boot!
        # Import ourselves into the new namespace, and remove ourselves from main.
        @root.const_set :Absinthe, ::Absinthe
        Object.send :remove_const, :Absinthe
      end

      def halt!
        # restore ourselves to the global namespace
        absinthe = @root.const_get :Absinthe
        Object.send :const_set, :Absinthe, absinthe
      end

      def load_file file
        begin
          @root.send(:module_eval, file.read, file.path, 1)
        rescue Exception => ex
          puts "Failed to load #{file.path}: #{ex.message}"
          raise LoadFailed, ex
        end
      end
    end

    class Injector
      def initialize
        @parameters = { }
        @args = { }
      end

      def register name, clazz, *args
        @parameters[name] = clazz
        @args[name] = args if @parameters[name].is_a?(Class)
      end

      def inject name
        return @parameters[name] unless @parameters[name].is_a?(Class)
        injections = @args[name].map do |injection|
          injection.is_a?(Symbol) ? inject(injection) : injection
        end
        @parameters[name] = @parameters[name].new(*injections)
      end
    end

    class Context
      def initialize
        @injector = Injector.new
        register :context, self
      end

      def configure &block
        self.instance_eval &block
      end

      def const name, value
        @injector.register name, value
      end

      def register name, clazz, *args
        @injector.register name, clazz, *args
      end

      def [] name, *args
        @injector.inject name, *args
      end

      def plugin! name
        self[:plugin].load name
      end

      def boot!
        self[:namespace].boot!
        if self[:boot_proc]
          boot_scope = (self[:calling_context] || self[:main_object])
          boot_scope.instance_exec(self, &self[:boot_proc])
        end
      end

      def halt!
        self[:namespace].halt!
      end
    end
  end
end
