module Absinthe
  module Plugins; end

  class Exception < ::Exception; end

  module Distillery
    require 'distillery/context'
    require 'distillery/source_loader'

    class Warehouse
      attr_reader :root_context
      def initialize main_object
        raise "Warehouse init failure!" if main_object.nil?
        @root_context = Context.new
        root_context.register :namespace, RootNamespace.new(main_object)
        root_context.register :source_loader, SourceLoader
      end
    end

    def self.root_context
      @warehouse.root_context
    end

    def self.configure main_object
      @warehouse = Warehouse.new(main_object)
    end
  end
end
# Always.
Absinthe::Distillery.configure self
