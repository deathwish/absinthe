module Absinthe
  module Distillery
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
  end
end
