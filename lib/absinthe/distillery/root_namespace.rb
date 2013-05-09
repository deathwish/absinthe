module Absinthe
  module Distillery
    class RootNamespace
      class LoadFailed < Exception; end

      attr_reader :root, :main
      def initialize main
        @main = main
        @root = Module.new { extend self }
        main.include root
      end

      def register name, value
        @root.send(:define_method, name) { value }
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
