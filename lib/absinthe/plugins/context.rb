module Absinthe
  module Plugins
    class Context
      def self.register injector
        injector.register :context, Context, :injector
      end

      def initialize injector
        @injector = injector
        @run_blocks = []
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

      def inject name
        @injector.inject name
      end

      def [] name
        inject name
      end

      def plugin! name
        self[:plugin].load name
      end

      def run *args, &block
        @run_blocks << {
          :args => args,
          :block => block
        }
      end

      def boot!
        self[:namespace].register :context, self
        if self[:boot_proc]
          instance_exec(&self[:boot_proc])
          boot_scope = (self[:calling_context] || self[:main_object])
          @run_blocks.each do |run|
            injections = run[:args].map(&method(:inject))
            boot_scope.instance_exec(*injections, &run[:block])
          end
        end
      end
    end
  end
end
