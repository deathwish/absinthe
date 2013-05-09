module Absinthe
  module Plugins
    class Context
      def self.register injector
        injector.register :context, Context, :injector
      end

      def initialize injector
        @injector = injector
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
        self[:namespace].register :context, self
        if self[:boot_proc]
          boot_scope = (self[:calling_context] || self[:main_object])
          boot_scope.instance_exec(self, &self[:boot_proc])
        end
      end
    end
  end
end
