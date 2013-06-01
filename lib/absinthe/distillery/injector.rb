module Absinthe
  module Distillery
    class Injector
      attr_reader :service_names

      def initialize
        @parameters = { }
        @args = { }
        @service_names = []
        register :injector, self
      end

      def register name, clazz, *args
        @parameters[name] = clazz
        if @parameters[name].is_a?(Class)
          @args[name] = args
          @service_names << name # we lack ordered hash traversal on 1.8.
        end
      end

      def inject name
        return @parameters[name] unless @parameters[name].is_a?(Class)
        injections = @args[name].map do |injection|
          injection.is_a?(Symbol) ? inject(injection) : injection
        end
        @parameters[name] = @parameters[name].new(*injections)
      end
    end
  end
end
