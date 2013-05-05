module Absinthe
  module Distillery
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
  end
end
