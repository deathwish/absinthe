module Absinthe
  module Distillery
    class RootNamespace
      class LoadFailed < Exception; end

      attr_reader :root, :main
      def initialize main_object
        @main = main_object
        @plugins = []
      end

      def boot! ctx
        @context = ctx
        @root = Module.new { extend self }

        # Import ourselves into the new namespace, and remove ourselves from main.
        @root.const_set :Absinthe, ::Absinthe
        Object.send :remove_const, :Absinthe

        root.send(:define_method, :context) { ctx }
        main.include root
        (ctx[:calling_context] || main).instance_eval { 
          ctx[:boot_proc].call ctx if ctx[:boot_proc]
        }
      end

      def load_plugin name
        require_dir :plugins, name

        # HACK not like this!
        plugin_name = Absinthe::Plugins.constants.grep(/#{name.to_s.gsub('_', '')}/i).first
        plugin = Absinthe::Plugins.const_get plugin_name
        plugin
      end

      def require_dir root, *paths
        @context[:source_loader].source_files(root, paths) do |file|
          eval_in_scope file
        end
      end

      private
      def eval_in_scope file
        begin
          @root.send(:module_eval, file.read, file.path, 1)
        rescue Exception => ex
          puts "Failed to load #{file.path}: #{ex.message}"
          raise LoadFailed, ex
        end
      end
    end

    class Context
      module Dsl
        def configure &block
          self.instance_eval &block
        end

        def const name, value
          register name, value
        end

        def [] name, *args
          inject name, *args
        end
      end
      include Dsl

      attr_reader :parameters, :args
      def initialize
        @parameters = { }
        @args = { }
      end

      def boot!
        inject(:namespace).boot! self
      end

      def register name, clazz, *args
        @parameters[name] = clazz
        @args[name] = args if @parameters[name].is_a?(Class)
      end

      def inject name, *args
        return @parameters[name] unless @parameters[name].is_a?(Class)
        injections = (@args[name] + args).map do |injection|
          injection.is_a?(Symbol) ? inject(injection) : injection
        end
        @parameters[name].new(*injections).tap do |obj|
          if obj.respond_to?(:boot!)
            # anything responding to boot is treated as a singleton service.
            @parameters[name] = obj
            case obj.method(:boot!).arity
            when 0
              obj.boot!
            when 1
              obj.boot! self
            else
              raise "Invalid boot method for #{name}"
            end
          end
        end
      end

      def plugin! name
        plugin = inject(:namespace).load_plugin name
        plugin.register self if plugin.respond_to? :register
        inject name
      end
    end
  end
end
