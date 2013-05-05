module Absinthe
  module Distillery
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
